import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:opentrip/Helpers/constant.dart';
import 'package:opentrip/Models/index.dart';
import 'package:opentrip/Pages/App/Provider/app_provider.dart';
import 'package:opentrip/Pages/App/Provider/auth_provider.dart';
import 'package:opentrip/Pages/App/Styles/index.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/AddNotePage/add_note_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/POD/pod_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/ShipPicturePage/ship_picture_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/stop_details_page.dart';
import 'package:opentrip/Widgets/index.dart';
import 'package:opentrip/Widgets/loading_container.dart';

import '../../../../Repositories/index.dart';

class UpdatePlacePage extends StatefulWidget {
  const UpdatePlacePage({Key? key}) : super(key: key);

  @override
  _UpdatePlacePageState createState() => _UpdatePlacePageState();
}

class _UpdatePlacePageState extends State<UpdatePlacePage> {
  // Page Strings
  final pageStrings = AppStrings();

  // Form Validation Global key
  final _formKey = GlobalKey<FormState>();

  // Text Contollers
  final actualPieceCtl = TextEditingController();
  final actualSpotsCtl = TextEditingController();
  final actualWeightCtl = TextEditingController();
  final trailerCtl = TextEditingController();
  final sealCtl = TextEditingController();
  final bolCtl = TextEditingController();

  AppState appState = AppState.LOADING;
  TripPlaceDetailModel placeDetail = TripPlaceDetailModel();
  TripTaskModel tripTask = TripTaskModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      appState = AppState.LOADING;
    });
    placeDetail = AppProvider.of(context).tripPlaceDetail;
    tripTask = AppProvider.of(context).tripTask;
    setState(() {
      appState = AppState.SUCCESS;
    });
    actualPieceCtl.text = placeDetail.ActualPCS;
    actualSpotsCtl.text = placeDetail.ActualSpots;
    actualWeightCtl.text = placeDetail.ActualWeight;

    trailerCtl.text = placeDetail.containerNumber.toString();
    sealCtl.text = placeDetail.sealNumber.toString();
    bolCtl.text = placeDetail.BoLNumber.toString();
  }

  // Save Data
  Future<void> save() async {
    try {
      if (appState == AppState.ACTION_PROGRESS) return;
      setState(() {
        appState = AppState.ACTION_PROGRESS;
      });
      UserModel userModel = AuthProvider.of(context).userModel;
      int unixtime = (DateTime.now().millisecondsSinceEpoch / 1000).ceil();
      print(unixtime);

      var actWeight = (actualWeightCtl.text == "")
          ? null
          : double.parse(double.parse(actualWeightCtl.text).toStringAsFixed(1));

      Map data = {
        "username": userModel.name,
        "loadID": placeDetail.loadID,
        "pieces": placeDetail.pcs,
        "weight": placeDetail.weight,
        "actualPieces": int.tryParse(actualPieceCtl.text.toString()),
        "actualSpots": int.tryParse(actualSpotsCtl.text.toString()),
        "actualWeight": actWeight,
        "container": trailerCtl.text,
        "seal": sealCtl.text,
        "bol": bolCtl.text,
        "timestamp": unixtime,
        "timezone": "CST"
      };

      Map res = await AppRepository.updatePlace(data);
      if (res['success']) {
        setState(() {
          appState = AppState.ACTION_SUCCESS;
        });
        ToastAlart.success(context, "Updated successfully!");

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => StopDetailsPage(
        //       tripTask: tripTask,
        //     ),
        //   ),
        // );
      } else {
        setState(() {
          appState = AppState.ACTION_ERROR;
        });
        ToastAlart.error(
            context,
            res['message'] ??
                res['error'] ??
                "Something went wrong. Please try again!");
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

    //Actual Pieces TextField
    final actualPiecesText = commonTextForm(
      context: context,
      fieldname: "Actual Pieces: ",
      hint: "Actual Pieces",
      validator: (value) {
        // if (value == null || value.isEmpty) {
        //   return 'Please enter some text';
        // } else if (value.length < 3) {
        //   return 'The password must be at least 8 characters.';
        // }
        return null;
      },
      controller: actualPieceCtl,
    );

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
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  // Original Pieces
                  myInput(
                    context: context,
                    enable: false,
                    title: pageStrings.updatePlace_originalPieces,
                    hint: placeDetail.pcs.toString(),
                    controller: TextEditingController(),
                  ),

                  // Original Weight
                  myInput(
                    context: context,
                    enable: false,
                    title: pageStrings.updatePlace_originalWeight,
                    hint: placeDetail.weight.toString(),
                    controller: TextEditingController(),
                  ),

                  // Actual Pieces
                  myInput(
                    context: context,
                    title: pageStrings.updatePlace_actualPieces,
                    hint: "Actual Pieces",
                    controller: actualPieceCtl,
                    keyboard: TextInputType.number,
                  ),
                  // Actual Weight
                  myInput(
                    context: context,
                    title: pageStrings.updatePlace_actualSpots,
                    hint: "Actual Spots",
                    controller: actualSpotsCtl,
                    keyboard: TextInputType.number,
                  ),
                  // Actual Weight
                  myInput(
                    context: context,
                    title: pageStrings.updatePlace_actualWeight,
                    hint: "Actual Weight",
                    controller: actualWeightCtl,
                    keyboard: TextInputType.number,
                  ),

                  // Trailer
                  myInput(
                    context: context,
                    title: pageStrings.updatePlace_trailer,
                    hint: "trailer",
                    controller: trailerCtl,
                  ),

                  // Seal
                  myInput(
                    context: context,
                    title: pageStrings.updatePlace_seal,
                    hint: "seal",
                    controller: sealCtl,
                  ),

                  // Bol
                  myInput(
                    context: context,
                    title: pageStrings.updatePlace_bol,
                    hint: "BoL",
                    controller: bolCtl,
                  ),

                  // Save Button
                  RoundButton(
                    context: context,
                    onTap: save,
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
