import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart'
//     as CustomeDateTimePicker;
import 'package:opentrip/Configs/app_styles.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:opentrip/Models/index.dart';
import 'package:opentrip/Models/repair_type.dart';
import 'package:opentrip/Models/trip_place_detail_model.dart';
import 'package:opentrip/Models/trip_place_model.dart';
import 'package:opentrip/Pages/App/Provider/app_provider.dart';
import 'package:opentrip/Pages/App/Styles/index.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/AddNotePage/add_note_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/POD/pod_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/ShipPicturePage/ship_picture_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/UpdatePlacePage/update_place_page.dart';
import 'package:opentrip/Repositories/index.dart';
import 'package:opentrip/Widgets/index.dart';
import 'package:opentrip/Widgets/loading_container.dart';
import 'package:opentrip/Widgets/round_button.dart';

class TruckProblemPage extends StatefulWidget {
  final String truckId;
  const TruckProblemPage({
    Key? key,
    required this.truckId,
    // required this.tripTask,
  }) : super(key: key);
  // final TripTaskModel tripTask;
  @override
  _TruckProblemPageState createState() => _TruckProblemPageState();
}

class _TruckProblemPageState extends State<TruckProblemPage> {
  final pageStrings = AppStrings();

  // Gloabal key for progress dialog
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  TextEditingController odoCtl = TextEditingController();
  String _chosenValue = "Android";

  // Form Validation Global key
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List<RepairType> listRepairTypes = [];
  RepairType? _currentRepairType;
  DateTime _currentDateTime = DateTime.now();
  final TextEditingController _noteController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    odoCtl.text = "";
    // Get Data
    getInitData();
  }

  Future<void> getInitData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      listRepairTypes = await AppRepository.getRepairTypes();
      _currentRepairType = listRepairTypes.first;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ToastAlart.error(context, e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  _save() async {
    if (_noteController.text.isEmpty) {
      ToastAlart.error(context, "Note is required");
      return;
    }
    try {
      setState(() {
        _isLoading = true;
      });
      final user = await getDataInLocal(
          key: AppLocalKeys.USERNAME, type: StorableDataType.String);
      Map res = await AppRepository.createRepairTask({
        "dueDate":
            formatTime(dateTime: _currentDateTime, newPattern: 'yyyy-MM-dd'),
        // "dueDate": _currentDateTime.toUtc().toIso8601String(),
        "repairTypeID": "${_currentRepairType!.repairTypeId}",
        "task": _noteController.text,
        "truckID": widget.truckId,
        "user": user,
      });

      if (res['success']) {
        setState(() {
          _isLoading = false;
        });
        ToastAlart.success(context, "Send report problem successfully!");
      } else {
        setState(() {
          _isLoading = false;
        });
        ToastAlart.error(
            context,
            res['message'] ??
                res['error'] ??
                "Something went wrong. Please try again!");
      }

      Navigator.pop(context);
    } catch (e) {
      ToastAlart.error(context, e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        // bottomNavigationBar: BottomNavigationBar(
        //   backgroundColor: Theme.of(context).primaryColor,
        //   unselectedLabelStyle: TextStyle(
        //     color: Colors.grey,
        //   ),
        //   selectedItemColor: Colors.white,
        //   unselectedItemColor: Colors.grey,
        //   currentIndex: 1,
        //   items: const [
        //     BottomNavigationBarItem(
        //         icon: Icon(
        //           Icons.edit,
        //           color: Colors.white,
        //         ),
        //         label: "ODO Update"),
        //     BottomNavigationBarItem(
        //         backgroundColor: Colors.white,
        //         icon: Icon(
        //           Icons.send,
        //           color: Colors.white,
        //         ),
        //         label: "Report Problem"),
        //     BottomNavigationBarItem(
        //         icon: Icon(
        //           Icons.edit,
        //           color: Colors.white,
        //         ),
        //         label: "Repairs"),
        //   ],
        //   onTap: (int i) {
        //     print('click index=$i');
        //     // switch (i) {
        //     //   case 0: // Update
        //     //     // Go to Update Place Page
        //     //     Navigator.pushReplacement(
        //     //       context,
        //     //       MaterialPageRoute(
        //     //           builder: (context) => const UpdatePlacePage()),
        //     //     );
        //     //     break;

        //     //   case 1: // Add Note
        //     //     // Go to Update Place Page
        //     //     Navigator.pushReplacement(
        //     //       context,
        //     //       MaterialPageRoute(builder: (context) => const AddNotePage()),
        //     //     );
        //     //     break;

        //     //   case 2: // Details

        //     //     break;

        //     //   case 3: // Pictures
        //     //     // Go to Update Place Page
        //     //     Navigator.pushReplacement(
        //     //       context,
        //     //       MaterialPageRoute(
        //     //           builder: (context) => const ShipPicturePage()),
        //     //     );
        //     //     break;

        //     //   case 4: // POD
        //     //     // Go to POD Page
        //     //     Navigator.pushReplacement(
        //     //       context,
        //     //       MaterialPageRoute(builder: (context) => const PODPage()),
        //     //     );
        //     //     break;

        //     //   default:
        //     // }
        //   },
        // ),
        appBar: AppBar(
          title: Text(pageStrings.truck_problem_title),
          centerTitle: true,
          // backgroundColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: LoadingContainer(
          isLoading: _isLoading,
          context: context,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Type:",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        // color: Colors
                        // .lightGreen, //background color of dropdown button
                        color: Theme.of(context).primaryColor,
                        // border: Border.all(
                        //     color: Colors.black38,
                        //     width: 3), //border of dropdown button
                        borderRadius: BorderRadius.circular(
                            50), //border raiuds of dropdown button
                        boxShadow: <BoxShadow>[
                          //apply shadow on Dropdown button
                          BoxShadow(
                              color: Color.fromRGBO(
                                  0, 0, 0, 0.57), //shadow for button
                              blurRadius: 5) //blur radius of shadow
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: DropdownButton(
                          value: _currentRepairType,
                          items: listRepairTypes.map((e) {
                            return DropdownMenuItem(
                              child: Text("${e.repairTypeName}"),
                              value: e,
                            );
                          }).toList(),

                          onChanged: (value) {
                            //get value when changed
                            setState(() {
                              _currentRepairType = value as RepairType?;
                            });
                          },
                          icon: const Padding(
                              //Icon at tail, arrow bottom is default icon
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(Icons.arrow_circle_down_sharp)),
                          iconEnabledColor: Colors.white, //Icon color
                          style: const TextStyle(
                              //te
                              color: Colors.white, //Font color
                              fontSize: 20 //font size on dropdown button
                              ),

                          dropdownColor: Theme.of(context)
                              .primaryColor, //dropdown background color
                          underline: Container(), //remove underline
                          isExpanded: true, //make true to make width 100%
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Due: ",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        var result = await showDatePicker(
                            context: context,
                            initialDate: _currentDateTime,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100));
                        if (result != null) {
                          setState(() {
                            _currentDateTime = result;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          border: Border.all(color: Colors.white),
                        ),
                        width: double.infinity,
                        // alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text(
                          formatTime(
                              dateTime: _currentDateTime,
                              newPattern: 'MM-dd-yyyy'),
                          style: AppStyles.textSize16(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Description: ",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      minLines:
                          4, // any number you need (It works as the rows for the textarea)
                      keyboardType: TextInputType.multiline,
                      maxLines: 20,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                      maxLength: 100,
                      cursorColor: Colors.white,
                      controller: _noteController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        // // border: InputBorder.none,
                        // focusedBorder: InputBorder.none,
                        // enabledBorder: InputBorder.none,
                        // errorBorder: InputBorder.none,
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 61, 61, 61), width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white70, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white70, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 118, 0, 253),
                              width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: "comment/note",
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    RoundButton(
                      context: context,
                      onTap: _save,
                      title: "SAVE",
                      icon: const Icon(
                        Icons.save,
                        color: Color.fromARGB(255, 238, 206, 206),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget myInput({
    required BuildContext context,
    required String title,
    required String hint,
    required TextEditingController controller,
    bool? enable,
    TextInputType? keyboard,
  }) {
    // Page Text Styles
    final textStyles = Theme.of(context).textTheme;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: textStyles.headline6!.copyWith(color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          commonTextForm(
            context: context,
            fieldname: hint,
            hint: hint,
            enable: enable ?? true,
            keyboard: keyboard ?? TextInputType.text,
            validator: (value) {
              // if (value == null || value.isEmpty) {
              //   return 'Please enter some text';
              // } else if (value.length < 3) {
              //   return 'The password must be at least 8 characters.';
              // }
              return null;
            },
            controller: controller,
          ),
        ],
      ),
    );
  }
}
