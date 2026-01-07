import 'package:flutter/material.dart';
import 'package:opentrip/Configs/app_routes.dart';
import 'package:opentrip/Configs/app_styles.dart';
import 'package:opentrip/Pages/App/Styles/index.dart';
import 'package:opentrip/Pages/Others/messages/message_received_page.dart';
import 'package:opentrip/Pages/Others/messages/send_message.dart';
import 'package:opentrip/Widgets/custom_appbar.dart';

class MessagesHistory extends StatefulWidget {
  const MessagesHistory({Key? key}) : super(key: key);

  @override
  State<MessagesHistory> createState() => _MessagesHistoryState();
}

class _MessagesHistoryState extends State<MessagesHistory> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              AppRoutes.push(context, const SendMessage());
            },
            label: Text(
              "Send Message",
              style: AppStyles.textSize15(color: Colors.white),
            )),
        appBar: const CustomAppBar(
          height: 100,
          title: "Messages History",
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "Received"),
              Tab(
                text: "Sent",
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          const MessageReceivedPage(),
          const MessageReceivedPage(),
        ]),
      ),
    );
  }
}
