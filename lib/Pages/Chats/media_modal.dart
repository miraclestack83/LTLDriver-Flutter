import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:opentrip/Configs/app_assets.dart';
import 'package:opentrip/Configs/app_styles.dart';

import '../App/Styles/index.dart';

class MediaModal extends StatelessWidget {
  const MediaModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
        color: AppColors.white(context),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Send Media",
                  style: AppStyles.textSize16(fontWeight: FontWeight.w500),
                ),
                Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.black(context).withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.clear,
                      size: 20,
                    )),
              ],
            ),
          ),

          GestureDetector(
            onTap: () async {
              if (context.mounted) {
                Navigator.pop(context, "camera");
              }
            },
            child: Item(
              title: "Camera",
              iconPath: AppAssets.imageIcon,
              icon: Icon(
                Icons.camera_alt,
                color: AppColors.primary(context),
              ),
            ),
          ),
          // Divider(
          //   height: 10,
          // ),
          const SizedBox(
            height: 14,
          ),
          GestureDetector(
            onTap: () async {
              if (context.mounted) {
                Navigator.pop(context, "image");
              }
            },
            child: const Item(
              title: "Image",
              iconPath: AppAssets.imageIcon,
            ),
          ),

          const SizedBox(
            height: 14,
          ),
          GestureDetector(
            onTap: () async {
              if (context.mounted) {
                Navigator.pop(context, "video");
              }
            },
            child: Item(
              title: "Video",
              iconPath: AppAssets.videoIcon,
            ),
          ),
        ],
      ),
    );
  }
}

class Item extends StatelessWidget {
  final String title;
  final String iconPath;
  final Widget? icon;
  const Item(
      {super.key, required this.title, required this.iconPath, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.black(context).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: icon ??
                  SvgPicture.asset(
                    iconPath,
                    color: AppColors.primary(context),
                  ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: AppStyles.textSize14(),
          )
        ],
      ),
    );
  }
}
