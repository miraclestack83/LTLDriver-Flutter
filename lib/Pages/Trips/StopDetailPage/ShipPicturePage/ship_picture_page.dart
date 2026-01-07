import 'dart:io';

// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:app_settings/app_settings.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
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

class ShipPicturePage extends StatefulWidget {
  const ShipPicturePage({Key? key}) : super(key: key);

  @override
  _ShipPicturePage createState() => _ShipPicturePage();
}

class _ShipPicturePage extends State<ShipPicturePage> {
  // Page Strings
  final pageStrings = AppStrings();

  // Form Validation Global key
  final _formKey = GlobalKey<FormState>();

  AppState appState = AppState.LOADING;
  File? uploadImage;
  // String? _dayImageURL;
  TripTaskModel tripTask = TripTaskModel();
  final _noteController = TextEditingController();

  int uploadPercent = 0;

  @override
  void initState() {
    super.initState();
    tripTask = AppProvider.of(context).tripTask;
  }

  /*****************************
   * Pick Photo Dialog
   */
  Future<void> _pickPhoto() async {
    // ignore: avoid_single_cascade_in_expression_statements
    // AwesomeDialog(
    //   context: context,
    //   animType: AnimType.SCALE,
    //   headerAnimationLoop: false,
    //   showCloseIcon: true,
    //   dialogType: DialogType.question,
    //   customHeader: dialogCamera(context),
    //   body: Center(
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(
    //           // vertical: 10,
    //           // horizontal: 20,
    //           ),
    //       child: Column(
    //         children: <Widget>[
    //           Card(
    //             child: ListTile(
    //               leading: const Icon(Icons.camera),
    //               title: const Text("Camera"),
    //               onTap: () async {
    //                 Navigator.of(context).pop();
    //                 if (await Permission.camera.request().isGranted) {
    //                   final ImagePicker _picker = ImagePicker();
    //                   final XFile? image = await _picker.pickImage(
    //                     source: ImageSource.camera,
    //                     maxWidth: 1920,
    //                     maxHeight: 1080,
    //                   );
    //                   if (image != null) {
    //                     setState(() {
    //                       uploadImage = File(image.path);
    //                     });
    //                     await cropImage(uploadImage!);
    //                   }
    //                 } else {
    //                   // ToastAlart.info(context,
    //                   //     "Permission denied.\r\n Please grant camera permission");
    //                   // openAppSettings();
    //                 }
    //               },
    //             ),
    //           ),
    //           Card(
    //             child: ListTile(
    //               leading: const Icon(Icons.folder),
    //               title: const Text("Gallery"),
    //               onTap: () async {
    //                 Navigator.of(context).pop();

    //                 try {
    //                   // await Permission.storage.request();
    //                   // print("Granted PHOTO Gallery!!!!!!!");
    //                   if (await Permission.storage.request().isGranted) {
    //                     final ImagePicker _picker = ImagePicker();
    //                     final XFile? image = await _picker.pickImage(
    //                       source: ImageSource.gallery,
    //                       maxWidth: 1920,
    //                       maxHeight: 1080,
    //                     );

    //                     if (image != null) {
    //                       setState(() {
    //                         uploadImage = File(image.path);
    //                       });
    //                       var size = uploadImage!.lengthSync() / 1024;
    //                       print("size: $size kb");
    //                       await cropImage(uploadImage!);
    //                     }
    //                   } else {
    //                     ToastAlart.info(context, "Permission denied");
    //                   }
    //                 } catch (e) {
    //                   print(e.toString());

    //                   ToastAlart.error(context, e.toString());
    //                 }
    //               },
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    //   title: 'Pick a Photo',
    //   desc: '',
    //   // btnOkOnPress: () {},
    // )..show();

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
                  // final permission = await Permission.camera.request();
                  try {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.camera,
                      maxWidth: 1920,
                      maxHeight: 1080,
                    );
                    if (image != null) {
                      setState(() {
                        uploadImage = File(image.path);
                      });
                      await cropImage(uploadImage!);
                    }
                  } catch (e) {
                    ToastAlart.info(context,
                        "Permission denied.\r\n Please grant camera permission");
                    // openAppSettings();
                    await alertOpenSetting(ImageSource.camera);
                    // openAppSettings();
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
                        var path = image.path;
                        uploadImage = File(path);
                      });
                      var size = uploadImage!.lengthSync() / 1024;
                      print("size: $size kb");
                      await cropImage(uploadImage!);
                    }
                  } catch (e) {
                    print("Permission Denied!!!!!!!");
                    ToastAlart.info(context, "Permission denied");
                    await alertOpenSetting(ImageSource.gallery);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> alertOpenSetting(ImageSource source) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Required'),
          content: Text(
              'To use this feature, please open the app settings and grant the required permissions.\r\n After change setting. Please restart your app!'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                if (source == ImageSource.camera) {
                  // Open app settings
                  await AppSettings.openAppSettings(
                      type: AppSettingsType.settings);
                } else {
                  // Open app settings
                  await AppSettings.openAppSettings(
                      type: AppSettingsType.settings);
                }
              },
            ),
          ],
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
        uploadImage = File(croppedFile.path);
      });
    }
  }

  _submit() async {
    if (uploadImage == null) {
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
      Map res = await AppRepository.updatePlaceImage({
        "shipment_id": tripTask.pro,
        "username": userName.toString().toLowerCase(),
        "txtFileNotes": _noteController.text,
        "btnSubmit11": "Upload File",
        "load_id": tripTask.loadID
      }, uploadImage!.path, onSendProgress: (current, total) {
        if (mounted) {
          setState(() {
            uploadPercent = current * 100 ~/ total;
          });
        }
      });

      print("Upload Image========>");
      print(res);

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
        final msg = res['message'] ?? "Something went wrong!";
        ToastAlart.error(context, msg);
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
      message: "$uploadPercent%",
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Image Picker
                  (uploadImage != null)
                      ? Container(
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.8),
                            image: DecorationImage(
                              image: FileImage(
                                uploadImage!,
                              ),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(1, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: InkWell(
                              onTap: () async {
                                await _pickPhoto();
                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 0, 0, 0)
                                          .withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          1, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color:
                                // Theme.of(context).primaryColor.withOpacity(0.8),
                                Colors.grey,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(1, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: InkWell(
                              onTap: () async {
                                await _pickPhoto();
                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 0, 0, 0)
                                          .withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          1, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _noteController,
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
                      hintText: pageStrings.shipPicture_desc,
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
                    title: pageStrings.shipPicture_save,
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
}
