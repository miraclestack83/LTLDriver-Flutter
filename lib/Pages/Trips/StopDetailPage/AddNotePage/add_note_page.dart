import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:opentrip/Helpers/constant.dart';
import 'package:opentrip/Pages/App/Styles/index.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/POD/pod_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/ShipPicturePage/ship_picture_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/UpdatePlacePage/update_place_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/stop_details_page.dart';
import 'package:opentrip/Widgets/index.dart';
import 'package:opentrip/Widgets/loading_container.dart';
import 'package:opentrip/Widgets/round_button.dart';

import '../../../../Models/trip_task_model.dart';
import '../../../../Repositories/app_repository.dart';
import '../../../App/Provider/app_provider.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key? key}) : super(key: key);

  @override
  _AddNotePage createState() => _AddNotePage();
}

class _AddNotePage extends State<AddNotePage> {
  // Page Strings
  final pageStrings = AppStrings();

  // Form Validation Global key
  final _formKey = GlobalKey<FormState>();

  // Text Contollers
  final _commentController = TextEditingController();
  AppState appState = AppState.LOADING;
  TripTaskModel tripTask = TripTaskModel();
  @override
  void initState() {
    tripTask = AppProvider.of(context).tripTask;
    super.initState();
  }

  _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      if (appState == AppState.ACTION_PROGRESS) return;
      setState(() {
        appState = AppState.ACTION_PROGRESS;
      });

      Map data = {
        "SRID": tripTask.srID,
        "isPickup": tripTask.isPickup,
        "comment": _commentController.text
      };

      Map res = await AppRepository.addComment(data);

      if (res['success']) {
        setState(() {
          appState = AppState.ACTION_SUCCESS;
        });
        ToastAlart.success(context, "Updated successfully!");
        // final tripTask = AppProvider.of(context).tripTask;
        // tripTask.Notes = _commentController.text;
        // AppProvider.of(context).setTripTask(tripTask);

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => StopDetailsPage(
        //       tripTask: tripTask,
        //     ),
        //   ),
        // );
        // Navigator.of(context).pop();
      } else {
        setState(() {
          appState = AppState.ACTION_ERROR;
        });
        ToastAlart.error(
            context, res['message'] ?? res['error'] ?? "Failed update");
      }
    } catch (e) {
      setState(() {
        appState = AppState.ACTION_ERROR;
      });
      ToastAlart.error(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Page Text Styles
    final textStyles = Theme.of(context).textTheme;

    return LoadingContainer(
      context: context,
      isLoading: (appState == AppState.ACTION_PROGRESS),
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _commentController,
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
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white70, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white70, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 118, 0, 253), width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintText: "comment/note",
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),

                // Save Button
                RoundButton(
                  context: context,
                  onTap: _submit,
                  title: "SAVE",
                  icon: const Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
