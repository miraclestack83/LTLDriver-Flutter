import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Helpers/index.dart';

class Network {
  // final String _url = 'http://10.10.12.134/api/v1';

  // final String _url = Constant.app_base_url;
  String _url = '';
  String _suffix = '';
  int timeout = 10;
  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;

  /*************************************************
   * Get Customer Server's URL saved by customer code
   */
  Future<String> getAppURL() async {
    _url = await getDataInLocal(
            key: AppLocalKeys.API_URL, type: StorableDataType.String) ??
        '';
    _suffix = await getDataInLocal(
            key: AppLocalKeys.API_SUFFIX, type: StorableDataType.String) ??
        '';
    return _url;
  }

  /*********************************************************
   * Get Customer Server's API Suffix saved by customer code
   */
  Future<String> getAppSuffix() async {
    _suffix = await getDataInLocal(
            key: AppLocalKeys.API_SUFFIX, type: StorableDataType.String) ??
        '';
    return _suffix;
  }

  Future _getToken() async {
    token = await getDataInLocal(
        key: AppLocalKeys.TOKEN, type: StorableDataType.String);
  }

  authData(data, apiUrl) async {
    await getAppURL();
    await _getToken();

    var fullUrl = Uri.parse(_url + apiUrl + _suffix);
    Logger().i(fullUrl);
    return await http
        .post(fullUrl, body: jsonEncode(data), headers: _setHeaders())
        .timeout(
      Duration(seconds: timeout),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
  }

  Future<Response> getDataURL(apiUrl, {Map<String, dynamic>? params}) async {
    // var fullUrl = _url + apiUrl;
    String fullPath = apiUrl;
    if (params != null) {
      fullPath += "?";
      int index = 0;
      params.forEach((k, v) {
        index++;
        fullPath += k.toString() + "=" + v.toString();
        if (index < params.length) fullPath += "&";
      });
    }
    var fullUrl = Uri.parse(fullPath);

    await _getToken();
    return await http.get(fullUrl, headers: _setHeaders()).timeout(
      Duration(seconds: timeout),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
  }

  Future<Response> getData(apiUrl, {Map<String, dynamic>? params}) async {
    await getAppURL();

    // var fullUrl = _url + apiUrl;
    String fullPath = _url + apiUrl + _suffix;

    print('fullpath');
    if (params != null) {
      fullPath += "?";
      int index = 0;
      params.forEach((k, v) {
        index++;
        fullPath += k.toString() + "=" + v.toString();
        if (index < params.length) fullPath += "&";
      });
    }
    print(fullPath);

    var fullUrl = Uri.parse(fullPath);

    await _getToken();
    return await http.get(fullUrl, headers: _setHeaders()).timeout(
      Duration(seconds: timeout),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
  }

  postData(data, apiUrl) async {
    await getAppURL();

    // var fullUrl = _url + apiUrl;
    var fullUrl = Uri.parse(_url + apiUrl + _suffix);

    await _getToken();
    return await http
        .post(fullUrl, body: json.encode(data), headers: _setHeaders())
        .timeout(
      Duration(seconds: timeout),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
  }

  deleteData(apiUrl) async {
    await getAppURL();

    // var fullUrl = _url + apiUrl;
    var fullUrl = Uri.parse(_url + apiUrl + _suffix);

    await _getToken();
    return await http.delete(fullUrl, headers: _setHeaders()).timeout(
      Duration(seconds: timeout),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
  }

  uploadFile(file, apiUrl, name) async {
    await getAppURL();

    // var fullUrl = Uri.parse(_url + apiUrl);
    var fullUrl = Uri.parse(_url + apiUrl + _suffix);
    String fileName = file.path.split('/').last;
    await _getToken();

    var request = http.MultipartRequest('POST', fullUrl);
    request.files.add(
      await http.MultipartFile.fromPath(
        name ?? 'file',
        file.path,
        filename: fileName,
      ),
    );

    request.headers.addAll(_setHeaders());
    request.headers['Content-Type'] = "multipart/form-data";
    request.fields['name'] = name;
    // request.fields['deviceid'] = deviceid;
    // request.fields['letter'] = letter;
    // request.fields['comment'] = commentCtrl.text;

    // var res = await request.send().then((value) {
    //   print(value.toString());
    // }).catchError((onError) {
    //   //------------ Dismiss Porgress Dialog  -------------------
    //   print(onError.toString());
    // });

    // http.Response response =
    //     await http.Response.fromStream(await request.send());

    // print("Result: ${response.body}");
    // return response;

    print(request.headers);

    return await request.send();
    // .then((res) async {
    //   print(res.headers);
    //   print(res.statusCode);
    //   print(await res.stream.bytesToString());
    // }).catchError((e) {
    //   print(e);
    // });
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}
