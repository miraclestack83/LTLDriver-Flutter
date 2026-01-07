import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:open_filex/open_filex.dart';
import 'package:opentrip/Configs/app_styles.dart';
import 'package:opentrip/Helpers/helper.dart';
import 'package:opentrip/Models/documents.dart';
import 'package:path_provider/path_provider.dart';

import '../../../Repositories/app_repository.dart';
import '../../../Widgets/loading_container.dart';
import '../../../Widgets/toast_alert.dart';

class TrailerTabView extends StatefulWidget {
  final String trailerId;
  const TrailerTabView({Key? key, required this.trailerId}) : super(key: key);

  @override
  State<TrailerTabView> createState() => _TrailerTabViewState();
}

class _TrailerTabViewState extends State<TrailerTabView> {
  bool _isLoading = false;
  List<Document> documents = [];
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  _fetchData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      print("**************************************");
      print(widget.trailerId);
      Logger().i(widget.trailerId);

      documents = await AppRepository.getTrailerImagesList(widget.trailerId);
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

  _getDetails(String imageId, String fileName, String type) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final result = await AppRepository.getEquipImagebyID(imageId);
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
      ToastAlart.error(context, e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingContainer(
      isLoading: _isLoading,
      context: context,
      child: documents.isEmpty
          ? Center(child: Text("No Data"))
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () async {
                    await _getDetails(
                        "${documents[index].id}",
                        "${documents[index].descr}",
                        "${documents[index].docType}");
                  },
                  child: Card(
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 16),
                      child: Row(
                        children: [
                          Text("${index + 1}."),
                          const SizedBox(
                            width: 6,
                          ),
                          Expanded(
                            child: Text(
                              "${documents[index].descr}",
                              style: AppStyles.textSize17(),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                                color: Colors.grey, shape: BoxShape.circle),
                            child: const Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.white,
                              size: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) {
                return const SizedBox(
                  height: 4,
                );
              },
              itemCount: documents.length),
    );
  }
}
