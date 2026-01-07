import 'package:flutter/material.dart';
import 'package:opentrip/Configs/app_styles.dart';
import 'package:opentrip/Repositories/index.dart';
import 'package:opentrip/Widgets/text_show_more.dart';

import '../../../Helpers/library.dart';
import '../../../Helpers/local_storage.dart';
import '../../../Models/message_model.dart';
import '../../../Widgets/loading_container.dart';
import '../../../Widgets/toast_alert.dart';

class MessageReceivedPage extends StatefulWidget {
  const MessageReceivedPage({Key? key}) : super(key: key);

  @override
  State<MessageReceivedPage> createState() => _MessageReceivedPageState();
}

class _MessageReceivedPageState extends State<MessageReceivedPage> {
  List<MessageModel> messages = [];
  bool _isLoading = false;
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final driverId = await getDataInLocal(
        key: AppLocalKeys.DRIVER_ID, type: StorableDataType.INT);
    messages = await AppRepository.getLastMessage("$driverId");
    setState(() {
      _isLoading = false;
    });
    try {} catch (e) {
      ToastAlart.error(context, e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingContainer(
      isLoading: _isLoading && messages.isEmpty,
      context: context,
      child: RefreshIndicator(
        onRefresh: _fetchData,
        child: Scrollbar(
          child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
              separatorBuilder: (_, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: messages.length,
              itemBuilder: (_, index) {
                return MessageItem(
                  messageModel: messages[index],
                );
              }),
        ),
      ),
    );
  }
}

class MessageItem extends StatefulWidget {
  final MessageModel messageModel;
  const MessageItem({Key? key, required this.messageModel}) : super(key: key);

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.blue[200],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "${formatUtcTime(dateUtc: widget.messageModel.dateTime!, format: "EEE, MM/dd/yyyy, hh:mm a")} ${widget.messageModel.createdBy}"),
          Text("• Type: ${widget.messageModel.type}"),
          Text("• From: ${widget.messageModel.msgFrom}"),
          Text("• To: ${widget.messageModel.msgTo}"),
          Text("• Subject: ${widget.messageModel.subject}"),
          ExpandableText(
            max: 100,
            scrollAble: false,
            text: "${widget.messageModel.msgBody}",
            textStyle: AppStyles.textSize14(),
          )
        ],
      ),
    );
  }
}
