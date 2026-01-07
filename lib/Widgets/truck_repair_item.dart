import 'dart:io';
import 'dart:typed_data';

// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:opentrip/Configs/app_styles.dart';
import 'package:opentrip/Helpers/helper.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:opentrip/Pages/App/Styles/index.dart';
import 'package:opentrip/Widgets/index.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tab_container/tab_container.dart';

import '../Models/repair.dart';
import '../Repositories/app_repository.dart';
import 'loading_container.dart';

class TruckRepairItem extends StatefulWidget {
  final Repair repair;
  final VoidCallback refreshData;
  const TruckRepairItem(
      {Key? key, required this.repair, required this.refreshData})
      : super(key: key);

  @override
  _TruckRepairItemState createState() => _TruckRepairItemState();
}

class _TruckRepairItemState extends State<TruckRepairItem> {
  bool _isLoading = false;
  File? uploadImage;
  late Repair repair;
  @override
  void initState() {
    super.initState();
    repair = widget.repair;
  }

  @override
  void didUpdateWidget(covariant TruckRepairItem oldWidget) {
    setState(() {
      repair = widget.repair;
    });
    super.didUpdateWidget(oldWidget);
  }

  int uploadPercent = 0;
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
    //                 if (await Permission.storage.request().isGranted) {
    //                   final ImagePicker _picker = ImagePicker();
    //                   final XFile? image = await _picker.pickImage(
    //                     source: ImageSource.gallery,
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
    //                   // ToastAlart.info(context, "Permission denied");
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
                    openAppSettings();
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  if (await Permission.storage.request().isGranted) {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 1920,
                      maxHeight: 1080,
                    );
                    if (image != null) {
                      setState(() {
                        uploadImage = File(image.path);
                      });
                      await cropImage(uploadImage!);
                    }
                  } else {
                    ToastAlart.info(context,
                        "Permission denied. Please allow to access to your photo gallery");
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
        uploadImage = File(croppedFile.path);
      });
    }
  }

  _uploadImage() async {
    if (uploadImage == null) {
      return;
    }

    try {
      if (_isLoading) return;
      setState(() {
        uploadPercent = 0;
        _isLoading = true;
      });

      Map<String, dynamic> res = await AppRepository.uploadRepairImage(
          data: {"username": "${repair.createUser}", "rt_id": "${repair.rtid}"},
          filePath: uploadImage!.path,
          onSendProgress: (current, total) {
            if (mounted) {
              setState(() {
                uploadPercent = current * 100 ~/ total;
              });
            }
          });
      setState(() {
        _isLoading = false;
      });
      if (res['success']) {
        ToastAlart.success(context, "Updated successfully!");
        widget.refreshData();
      } else {
        ToastAlart.error(context, res['message']);
        // widget.refreshData();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ToastAlart.error(context, e.toString());
    }
  }

  _getImageDetails(String fileName, String imageId, String type) async {
    try {
      setState(() {
        uploadPercent = 0;
        _isLoading = true;
      });

      final result = await AppRepository.getRepairImage(imageId);
      final tempDir = await getTemporaryDirectory();
      String newFilename = Helpers.fixFileName(fileName);
      String path = '${tempDir.path}/$newFilename.${type.trim().toLowerCase()}';
      File file = await File(path).create();

      file.writeAsBytesSync(result);
      OpenFilex.open(file.path);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      ToastAlart.error(context, e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingContainer(
      context: context,
      isLoading: _isLoading,
      message: uploadPercent == 0 ? null : "$uploadPercent%",
      child: ExpandableTheme(
        data: ExpandableThemeData(
          iconColor: Theme.of(context).primaryColor,
          useInkWell: true,
        ),
        child: ExpandableNotifier(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  ScrollOnExpand(
                    scrollOnExpand: true,
                    scrollOnCollapse: false,
                    child: ExpandablePanel(
                      theme: const ExpandableThemeData(
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        tapBodyToCollapse: true,
                      ),
                      header: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.gear,
                              size: 16,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${stringToDateFormat(repair.createdAt ?? '', 'yyyy-MM-dd')} ${repair.repairTypeName}",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                      collapsed: Text(
                        "${repair.createUser}",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      expanded: Container(
                        height: 300,
                        child: Container(
                          child: TabContainer(
                            isStringTabs: false,
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.8),
                            tabEdge: TabEdge.bottom,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${repair.task}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Details about Repair#${repair.rtid}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Created On: ${stringToDateFormat(repair.createdAt ?? '', 'yyyy-MM-dd')}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Done by: ${repair.doneby ?? "N/A"}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: Container(
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(20),
                                  //   color: Theme.of(context)
                                  //       .primaryColor
                                  //       .withOpacity(0.8),
                                  //   // boxShadow: [
                                  //   //   BoxShadow(
                                  //   //     color: Color.fromARGB(255, 0, 0, 0)
                                  //   //         .withOpacity(0.5),
                                  //   //     spreadRadius: 2,
                                  //   //     blurRadius: 5,
                                  //   //     offset: Offset(
                                  //   //         1, 3), // changes position of shadow
                                  //   //   ),
                                  //   // ],
                                  // ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: List.generate(
                                          repair.images?.length ?? 0, (index) {
                                        final image = repair.images![index];
                                        return GestureDetector(
                                          onTap: () {
                                            _getImageDetails(
                                                "Image ${index + 1}",
                                                "${image.erimgid}",
                                                "png");
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.8),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 10),
                                            child: Row(
                                              children: [
                                                (image.picture == null)
                                                    ? const Icon(
                                                        Icons.image,
                                                        color: Colors.white,
                                                        size: 50,
                                                      )
                                                    : ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image.memory(
                                                          image.picture!,
                                                          width: 50,
                                                          height: 50,
                                                          fit: BoxFit.cover,
                                                        )),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "Image ${index + 1}",
                                                    style: AppStyles.textSize16(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    // Image Picker
                                    (uploadImage != null)
                                        ? Container(
                                            height: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.8),
                                              image: DecorationImage(
                                                image: FileImage(
                                                  uploadImage!,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                          255, 0, 0, 0)
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: Offset(1,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: InkWell(
                                                onTap: () async {
                                                  // await _pickPhoto();
                                                },
                                                child: Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromARGB(
                                                                255, 0, 0, 0)
                                                            .withOpacity(0.5),
                                                        spreadRadius: 2,
                                                        blurRadius: 5,
                                                        offset: Offset(1,
                                                            3), // changes position of shadow
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
                                            height: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color:
                                                  // Theme.of(context).primaryColor.withOpacity(0.8),
                                                  Colors.grey,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                          255, 0, 0, 0)
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: Offset(1,
                                                      3), // changes position of shadow
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
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromARGB(
                                                                255, 0, 0, 0)
                                                            .withOpacity(0.5),
                                                        spreadRadius: 2,
                                                        blurRadius: 5,
                                                        offset: Offset(1,
                                                            3), // changes position of shadow
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
                                    RoundButton(
                                      context: context,
                                      onTap: () {
                                        _uploadImage();
                                      },
                                      title: "UPLOAD",
                                    )
                                  ],
                                ),
                              ),
                            ],
                            tabs: [
                              Icon(Icons.note),
                              Icon(Icons.more_horiz),
                              Icon(Icons.image),
                              Icon(Icons.add_a_photo),
                            ],
                          ),
                        ),
                      ),
                      builder: (_, collapsed, expanded) {
                        return Padding(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: Expandable(
                            collapsed: collapsed,
                            expanded: expanded,
                            theme: const ExpandableThemeData(crossFadePoint: 0),
                          ),
                        );
                      },
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
