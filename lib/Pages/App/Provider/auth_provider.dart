import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:opentrip/Models/chat_model.dart';
import 'package:opentrip/Models/index.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  static AuthProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<AuthProvider>(context, listen: listen);

  /// user info - login info
  UserModel _userModel = UserModel();
  UserChatModel? _userChatModel;
  UserModel get userModel => _userModel;
  UserChatModel? get userChatModel => _userChatModel;
  Future<void> setUserModel(UserModel userModel,
      {bool isNotifiable = true}) async {
    _userModel = userModel;
    if (isNotifiable) notifyListeners();
  }

  Future<void> setUseChatModel(UserChatModel userChatModel) async {
    _userChatModel = userChatModel;
    notifyListeners();
  }
}
