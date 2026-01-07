import 'package:flutter/material.dart';
import 'package:opentrip/Configs/app_styles.dart';
import 'package:opentrip/Repositories/index.dart';

import '../../../Helpers/local_storage.dart';
import '../../../Widgets/custom_appbar.dart';
import '../../../Widgets/custom_textfield.dart';
import '../../../Widgets/custom_textform.dart';
import '../../../Widgets/loading_container.dart';
import '../../../Widgets/round_button.dart';
import '../../../Widgets/toast_alert.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isLoading = false;
  _submit() async {
    if (_textEditingController.text.isEmpty) {
      return;
    }
    try {
      setState(() {
        _isLoading = true;
      });
      final driverId = await getDataInLocal(
          key: AppLocalKeys.DRIVER_ID, type: StorableDataType.INT);
      await AppRepository.saveSettings({
        "driverId": driverId,
        "lastxshipments": _textEditingController.text
      });
      setState(() {
        _isLoading = false;
      });
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
        appBar: const CustomAppBar(title: "Others"),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(21),
          child: RoundButton(
            context: context,
            title: "Save",
            onTap: _submit,
          ),
        ),
        body: LoadingContainer(
          isLoading: _isLoading,
          context: context,
          child: Container(
            padding: const EdgeInsets.all(21),
            child: Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "Theme",
                //       style: AppStyles.textSize16(),
                //     ),
                //     Row(
                //       children: [
                //         Container(
                //           width: 20,
                //           height: 20,
                //           margin: const EdgeInsets.symmetric(horizontal: 4),
                //           decoration: const BoxDecoration(
                //             color: Colors.red,
                //             shape: BoxShape.circle,
                //           ),
                //         ),
                //         Container(
                //           width: 20,
                //           height: 20,
                //           margin: const EdgeInsets.symmetric(horizontal: 4),
                //           decoration: const BoxDecoration(
                //             color: Colors.blue,
                //             shape: BoxShape.circle,
                //           ),
                //         ),
                //         Container(
                //           width: 20,
                //           height: 20,
                //           margin: const EdgeInsets.symmetric(horizontal: 4),
                //           decoration: BoxDecoration(
                //             color: Colors.grey[900],
                //             shape: BoxShape.circle,
                //           ),
                //         ),
                //         Container(
                //           width: 20,
                //           height: 20,
                //           margin: const EdgeInsets.symmetric(horizontal: 4),
                //           decoration: const BoxDecoration(
                //             color: Colors.yellow,
                //             shape: BoxShape.circle,
                //           ),
                //         )
                //       ],
                //     )
                //   ],
                // ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        "Number of shipments on search results page:",
                        style: AppStyles.textSize16(),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 5,
                      child: CustomTextField(
                        controller: _textEditingController,
                        textInputType: TextInputType.number,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
