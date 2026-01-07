import 'dart:io';

// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:opentrip/Pages/App/Styles/index.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/AddNotePage/add_note_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/POD/pod_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/UpdatePlacePage/update_place_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/stop_details_page.dart';
import 'package:opentrip/Widgets/index.dart';
import 'package:opentrip/Widgets/round_button.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../Helpers/constant.dart';
import '../../../../Models/trip_task_model.dart';
import '../../../../Repositories/app_repository.dart';
import '../../../../Widgets/loading_container.dart';
import '../../../App/Provider/app_provider.dart';
import '../ShipPicturePage/ship_picture_page.dart';

class PODPage extends StatefulWidget {
  const PODPage({Key? key}) : super(key: key);

  @override
  _PODPage createState() => _PODPage();
}

class _PODPage extends State<PODPage> {
  // Page Strings
  final pageStrings = AppStrings();

  // Picked File
  File? pickFile;
  AppState appState = AppState.LOADING;
  TripTaskModel tripTask = TripTaskModel();

  int uploadPercent = 0;

  @override
  void initState() {
    super.initState();
    tripTask = AppProvider.of(context).tripTask;
  }

  _submit() async {
    if (pickFile == null) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      if (appState == AppState.ACTION_PROGRESS) return;
      setState(() {
        appState = AppState.ACTION_PROGRESS;
      });
      final userName = await getDataInLocal(
          key: AppLocalKeys.USERNAME, type: StorableDataType.String);
      Map res = await AppRepository.uploadPODImage({
        "shipment_id": tripTask.pro,
        "username": userName.toString().toLowerCase(),
      }, pickFile!.path, onSendProgress: (current, total) {
        if (mounted) {
          setState(() {
            uploadPercent = current * 100 ~/ total;
          });
        }
      });

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
    } catch (e) {
      setState(() {
        appState = AppState.ACTION_ERROR;
      });
      ToastAlart.error(context, e.toString());
    }
  }

  Future<void> _pickPhoto() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();

                  if (await Permission.camera.request().isGranted) {
                    final ImagePicker _picker = ImagePicker();

                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.camera,
                      maxWidth: 1920,
                      maxHeight: 1080,
                    );

                    if (image != null) {
                      setState(() {
                        pickFile = File(image.path);
                      });

                      await cropImage(pickFile!);
                    }
                  } else {
                    ToastAlart.info(context,
                        "Permission denied.\r\n Please grant camera permission");

                    openAppSettings();
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  try {
                    final ImagePicker _picker = ImagePicker();

                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 1920,
                      maxHeight: 1080,
                    );

                    if (image != null) {
                      setState(() {
                        pickFile = File(image.path);
                      });

                      await cropImage(pickFile!);
                    }
                  } catch (e) {
                    openAppSettings();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future cropImage(File file) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        )
      ],
    );

    if (croppedFile != null) {
      setState(() {
        pickFile = File(croppedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Page Text Styles
    final textStyles = Theme.of(context).textTheme;

    return LoadingContainer(
      context: context,
      message: "$uploadPercent%",
      isLoading: (appState == AppState.ACTION_PROGRESS),
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "PRO#: 92",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
              Text(
                "Username: adam",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),

              GestureDetector(
                  onTap: _pickPhoto,
                  child: uploadWidget(context: context, file: pickFile)),
              // Save Button
              RoundButton(
                context: context,
                onTap: _submit,
                title: pageStrings.pod_save,
                icon: const Icon(
                  Icons.upload,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
