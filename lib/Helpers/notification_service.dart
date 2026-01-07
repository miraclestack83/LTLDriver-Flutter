import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:opentrip/Configs/app_styles.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:opentrip/Helpers/navigator_service.dart';
import 'package:opentrip/Models/chat_model.dart';
import 'package:opentrip/Pages/App/Styles/colors.dart';
import 'package:opentrip/Pages/Chats/chat_details.dart';
import 'package:opentrip/Services/firestore_service.dart';

import 'package:overlay_support/overlay_support.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  static StreamSubscription? fcmListener;

  static Future<void> showNotification(
      String title, String body, RemoteMessage remoteMessage) async {
    showOverlayNotification(
      (context) {
        return Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              _handleMessage(remoteMessage);
            },
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 21, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppStyles.textSize15(
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          Text(
                            body,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: AppStyles.textSize13(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      duration: const Duration(milliseconds: 3000),
    );
  }

  Future<void> settingNotifcation(BuildContext context) async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await messaging.getToken();
      print("token: $token");
      var email = await getDataInLocal(
          key: AppLocalKeys.EMAIL, type: StorableDataType.String);
      Logger().d("👏👏👏EMAIL FROM LOCALSTORAGE👏👏👏 ${email}");
      if (email != null && token != null) {
        await FirestoreService.updateFCM(email: email, fcmToken: token);
      }

      var company = await getDataInLocal(
          key: AppLocalKeys.CODE, type: StorableDataType.String);
      await messaging.subscribeToTopic(company);
      fcmListener =
          FirebaseMessaging.onMessage.asBroadcastStream().listen((message) {
        if (message.notification != null) {
          if (message.data.containsKey("room")) {
            var data = jsonDecode(message.data['room']);
            var room = RoomModel.fromJson(data, data['id']);
            if (room.id != FirestoreService.currentRoomId) {
              showNotification(message.notification!.title!,
                  message.notification?.body ?? "", message);
            }
          } else {
            showNotification(message.notification!.title!,
                message.notification?.body ?? "", message);
          }
        }
      });
      await setupInteractedMessage();
    }
  }

  static void selectNotification(String payload) {
    // NavigationService.instance.push(const NotificationPage());
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  static void _handleMessage(RemoteMessage message) {
    print("onTap message, $message");
    var data = jsonDecode(message.data['room']);
    var room = RoomModel.fromJson(data, data['id']);
    push(
        NavigationService.instance.navigationKey!.currentContext!,
        ChatDetails(
          roomModel: room,
        ));
  }

  dispose() async {
    await fcmListener?.cancel();
  }
}
