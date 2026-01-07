import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:opentrip/Widgets/custom_appbar.dart';

import 'dart:typed_data';

import '../../Helpers/constant.dart';

class ViewImagePage extends StatefulWidget {
  final Uint8List image;
  const ViewImagePage({Key? key, required this.image}) : super(key: key);

  @override
  State<ViewImagePage> createState() => _ViewImagePageState();
}

class _ViewImagePageState extends State<ViewImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: "View Image"),
        // body: Image.network(
        //   "${Constant.app_base_url}GetProImage.ds?imgID=${widget.imageId}",
        //   loadingBuilder: (context, child, loadingProgress) {
        //     return Center(child: child);
        //   },
        //   errorBuilder: (_, __, error) {
        //     return Text("${error}");
        //   },
        // ),
        body: Center(
            child: Image.memory(
          widget.image,
          frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: frame != null
                  ? child
                  : SizedBox(
                      height: 60,
                      width: 60,
                      child: CircularProgressIndicator(strokeWidth: 6),
                    ),
            );
          }),
        )));
  }
}
