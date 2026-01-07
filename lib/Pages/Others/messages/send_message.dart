import 'package:flutter/material.dart';
import 'package:opentrip/Widgets/custom_appbar.dart';

import '../../../Helpers/local_storage.dart';
import '../../../Repositories/app_repository.dart';
import '../../../Widgets/loading_container.dart';
import '../../../Widgets/toast_alert.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({Key? key}) : super(key: key);

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isLoading = false;
  _submit() async {
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      setState(() {
        _isLoading = true;
      });
      final driverId = await getDataInLocal(
          key: AppLocalKeys.DRIVER_ID, type: StorableDataType.INT);
      final user = await getDataInLocal(
          key: AppLocalKeys.USERNAME, type: StorableDataType.String);
      await AppRepository.sendMessage({
        "driverID": driverId,
        "body": _textEditingController.text,
        "user": user
      });
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context, true);
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
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: CustomAppBar(title: "Send Message"),
          floatingActionButton: FloatingActionButton(
            onPressed: _submit,
            child: Icon(Icons.send),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _textEditingController,
              minLines: 5,
              maxLines: 10,
              decoration: InputDecoration(
                  hintText: "Enter Message",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey))),
            ),
          ),
        ),
      ),
    );
  }
}
