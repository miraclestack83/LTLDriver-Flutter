import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:opentrip/Helpers/constant.dart';
import 'package:opentrip/Services/api.dart';
import 'package:opentrip/Services/firestore_service.dart';

class UserRepository {
  // ========== LOGIN ==================
  static Future<Map<String, dynamic>> login(data) async {
    Logger().d("😎------- LOGIN ---------😎");
    Logger().d(data);
    var res = await Network().authData(data, 'login');
    Logger().i('================= LOGIN WITH CUSTOMER SERVER =============');
    print(res.statusCode);
    Logger().i(res.body);

    var result = callback(res);
    Logger().i('😎 ------------------>');
    Logger().i(result);
    Logger().i(result['result']);
    if (result['result'] == true) {
      return result['data'];
    } else {
      return result;
    }
  }

  static Map<String, dynamic> callback(res) {
    Map<String, dynamic> result;
    switch (res.statusCode) {
      case 200:
        if (res.body != null) {
          Map<String, dynamic> body = json.decode(res.body);
          if (body['success'] != null && body['success'] == false) {
            result = {'result': false, 'error': body['error']};
          } else {
            result = {'result': true, 'data': body};
          }
        } else {
          result = {
            'result': false,
            'error': "User doesn't exsit. Please conatct support team"
          };
        }
        break;
      case 204:
        result = {
          'result': false,
          'error': "User doesn't exsit. Please conatct support team"
        };
        break;
      case 400:
        result = {
          'result': false,
          'error': "Server Error! Please contact administrator"
        };
        break;

      case 500:
        result = {'result': false, 'error': "Server error. Please retry!"};
        break;
      default:
        final data = res.body;
        result = {
          'result': false,
          'error': data['error'] ?? "Server Error! Please contact administrator"
        };
    }
    return result;
  }
  // ========== REGISTER  ==================
  // static Future<Map<String, dynamic>> register(UserModel userModel) async {
  //   var res = await Network().authData(userModel.toJson(), '/register');
  //   var body = json.decode(res.body);
  //   return body;
  // }

  // // ========= LOG OUT =============
  // static Future logout() async {
  //   var res = await Network().getData('/logout');
  //   // var body = json.decode(res.body);
  //   // return body;
  //   return res;
  // }

  // // ========= SIGN WITH GOOGLE or FACEBOOK
  // static Future registerUser(String name, String email, String avatar) async {
  //   var data = {"name": name, "email": email, "avatar": avatar};
  //   var res = await Network().authData(data, '/registerUser');
  //   var body = json.decode(res.body);
  //   return body;
  // }

  // // ======== UPDATE USER ======
  // static Future updateUser(UserModel userModel) async {
  //   var res = await Network().authData(userModel.toJson(), '/updateUser');
  //   // var body = json.decode(res.body);
  //   return res;
  // }

  // // ======== CHANGE USER ======
  // static Future changePassword(Map data) async {
  //   var res = await Network().authData(data, '/changePassword');
  //   // var body = json.decode(res.body);
  //   return res;
  // }

  // //=========== UPLOAD AVATAR ==============
  // static Future<String> uploadAvatarImage(File image, String email) async {
  //   try {
  //     var res = await Network().uploadFile(image, '/uploadAvatar', email);
  //     if (res.statusCode == 200) {
  //       var data = await res.stream.bytesToString();
  //       var body = json.decode(data);
  //       return body['path'];
  //     } else {
  //       return '';
  //     }
  //   } catch (e) {
  //     return '';
  //   }
  // }

  // /****************************************************
  //  * FORGET PASSWORD
  //  *
  //  */

  // // ======== SEND CODE ======
  // static Future sendCode(Map data) async {
  //   var res = await Network().authData(data, '/sendCode');
  //   // var body = json.decode(res.body);
  //   return res;
  // }

  // // ======== SEND VERIFY CODE ======
  // static Future verifyCode(Map data) async {
  //   var res = await Network().authData(data, '/verifyCode');
  //   // var body = json.decode(res.body);
  //   return res;
  // }

  // // ======== SEND VERIFY CODE ======
  // static Future resetPassword(Map data) async {
  //   var res = await Network().authData(data, '/resetPassword');
  //   // var body = json.decode(res.body);
  //   return res;
  // }
}
