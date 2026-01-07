import 'package:flutter/material.dart';

class Constant {
  //--------------------------------------------------------------------
  // change this URL with server's URL
  //--------------------------------------------------------------------
  // static String app_base_url = 'http://m2022.ltlmaster.com/DriverServices/';
  static String BASE_API_URL = 'https://ltlnodeapi.ltlmaster.com/';
  static String BASE_API_SUFFIX = '';

  // static String api_suffix = '';
  // static String api_suffix = '.php';

  //customer's paid Google Map API Key
  static String gmap_api_key = '';

  static const String AUTH0_DOMAIN = 'dev-y2irjqfo.us.auth0.com';
  static const String AUTH0_CLIENT_ID = 'WcLNvoBF4ibbYV88FDyj5lXCPKVZRl8t';

  static const String AUTH0_REDIRECT_URI = 'com.ltldriver.app://login-callback';
  static const String AUTH0_LOUTOUT_REDIRECT_URI =
      'com.ltldriver.app://logout-callback';
  static const String AUTH0_ISSUER = 'https://$AUTH0_DOMAIN';
  static const String AUTH0_AUDIENCE = 'https://ltldriver/api';
}

enum LoginType {
  email,

  google,

  facebook,
}

enum AppState {
  LOADING,
  ERROR,
  SUCCESS,

  // Action
  ACTION_PROGRESS,
  ACTION_ERROR,
  ACTION_SUCCESS,
}

class UserRole {
  ///Company role
  static String DRIVER = "driver";
  static String FORK_LIFT_OPERATOR = "forkliftoperator";
  static String DISPATCHER = "dispatch";
}

class AppConstans {
  // room type
  static const String roomPublic = 'public';
  static const String roomPrivate = 'private';

  // message type
  static const String messageTextType = 'text';
  static const String messageMediaType = 'media';

  static const String fcmServerKey =
      '';
}
