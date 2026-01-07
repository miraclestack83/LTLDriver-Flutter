import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:opentrip/Helpers/local_storage.dart';
import 'package:opentrip/Models/Equipment.dart';
import 'package:opentrip/Models/company_contact.dart';
import 'package:opentrip/Models/documents.dart';
import 'package:opentrip/Models/message_model.dart';
import 'package:opentrip/Models/my_truck.dart';
import 'package:opentrip/Models/plan.dart';
import 'package:opentrip/Models/repair.dart';
import 'package:opentrip/Models/repair_type.dart';
import 'package:opentrip/Models/shipment_model.dart';

import 'package:opentrip/Services/api.dart';
import 'package:http_parser/http_parser.dart';
import '../Helpers/constant.dart';

import '../Helpers/constant.dart';

class AppRepository {
  /**
   * @Auth: geniusdev0813@gmail.com
   * @Date: 2022.5.4
   * @Desc: Get Open Trips
   */
  static Future<Map<String, dynamic>> getOpenTrips(int driverID) async {
    try {
      var res = await Network().getData(
        'GetOpenTripsByDriver2',
        params: {
          "driverID": driverID,
        },
      );

      if (res.statusCode == 200) {
        var body = json.decode(res.body);

        return {'success': true, 'data': body};
      } else {
        return {'success': false, 'message': "Some error occured"};
      }
    } catch (e) {
      print(e.toString());
      return {
        'success': false,
        'message': "Can't connect server.\n\r Please check your connection!"
      };
    }
  }

  /**
   * @Auth: geniusdev0813@gmail.com
   * @Date: 2022.5.4
   * @Desc: Get Open Trips
   */
  static Future<Map<String, dynamic>> getURLWithCode(String code) async {
    try {
      String url = '${Constant.BASE_API_URL}GetMobileSite';
      Logger().i("Get Mobile Site URL::::>");
      Logger().i(url);
      var res = await Network().getDataURL(
        url,
        params: {
          "siteCode": code,
        },
      );
      if (res.statusCode == 200) {
        var body = json.decode(res.body);

        return {'success': true, 'data': body[0]};
      } else {
        return {'success': false, 'message': "Some error occured"};
      }
    } catch (e) {
      print(e.toString());
      return {
        'success': false,
        'message': "Can't connect server.\n\r Please check your connection!"
      };
    }
  }

  /**
   * @Auth: geniusdev0813@gmail.com
   * @Date: 2022.5.4
   * @Desc: Get Trip Places
   */
  static Future<Map<String, dynamic>> getTripPlaces(int tripID) async {
    try {
      var res = await Network().getData(
        'GetTripPlaces',
        params: {
          "tripID": tripID,
        },
      );
      if (res.statusCode == 200) {
        var body = json.decode(res.body);

        return {'success': true, 'data': body};
      } else {
        return {'success': false, 'message': "Some error occured"};
      }
    } catch (e) {
      print(e.toString());
      return {
        'success': false,
        'message': "Can't connect server.\n\r Please check your connection!"
      };
    }
  }

  /**
   * @Auth: geniusdev0813@gmail.com
   * @Date: 2022.5.4
   * @Desc: Get Trip Tasks
   */
  static Future<Map<String, dynamic>> getTripTasks(int tpID) async {
    try {
      var res = await Network().getData(
        'GetPlaceTasks',
        params: {
          "tpID": tpID,
        },
      );
      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        return {'success': true, 'data': body};
      } else {
        return {'success': false, 'message': "Some error occured"};
      }
    } catch (e) {
      print(e.toString());
      return {
        'success': false,
        'message': "Can't connect server.\n\r Please check your connection!"
      };
    }
  }

  /**
   * @Auth: geniusdev0813@gmail.com
   * @Date: 2022.5.4
   * @Desc: Get Place Data By ID
   */
  static Future<Map<String, dynamic>> getPlaceByID(
      int placeID, String stopType) async {
    try {
      var res = await Network().getData(
        'GetPlaceById',
        params: {
          "placeID": placeID,
          "stopType": stopType,
        },
      );
      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        return {'success': true, 'data': body};
      } else {
        return {'success': false, 'message': "Some error occured"};
      }
    } catch (e) {
      print(e.toString());
      return {
        'success': false,
        'message': "Can't connect server.\n\r Please check your connection!"
      };
    }
  }

  /**
   * @Auth: geniusdev0813@gmail.com
   * @Date: 2022.5.4
   * @Desc: Make Arrived
   */
  static Future<Map<String, dynamic>> makeArrived(Map data) async {
    try {
      var res = await Network().postData(
        data,
        'arrived',
      );
      var body = json.decode(res.body);
      if (res.statusCode == 200 && body['result'] == true) {
        return {'success': true, 'data': body};
      } else {
        return {
          'success': false,
          'message': body['message'] ?? "Some error occured.Please retry!"
        };
      }
    } catch (e) {
      print(e.toString());
      return {
        'success': false,
        'message': "Can't connect server.\n\r Please check your connection!"
      };
    }
  }

  /**
   * @Auth: geniusdev0813@gmail.com
   * @Date: 2022.5.4
   * @Desc: Make Done
   */
  static Future<Map<String, dynamic>> makeDone(Map data) async {
    try {
      var res = await Network().postData(
        data,
        'placeDone',
      );

      var body = json.decode(res.body);
      if (res.statusCode == 200 && body['result'] == true) {
        return {'success': true, 'data': ""};
      } else {
        return {
          'success': false,
          'message': body["message"] ?? "Some error occured.Please retry!"
        };
      }
    } catch (e) {
      print(e.toString());
      return {
        'success': false,
        'message': "Can't connect server.\n\r Please check your connection!"
      };
    }
  }

  /**
   * @Auth: geniusdev0813@gmail.com
   * @Date: 2022.5.4
   * @Desc: Update Place
   */
  static Future<Map<String, dynamic>> updatePlace(Map data) async {
    try {
      var res = await Network().postData(
        data,
        'updatePlace',
      );

      var body = json.decode(res.body);
      if (res.statusCode == 200 && body["result"] == true) {
        return {'success': true, 'data': body};
      } else {
        return {'success': false, 'message': body["message"]};
      }
    } catch (e) {
      print(e.toString());
      return {
        'success': false,
        'message': "Can't connect server.\n\r Please check your connection!"
      };
    }
  }

  static Future<Map<String, dynamic>> addComment(Map data) async {
    try {
      var res = await Network().postData(
        data,
        'AddComment',
      );

      var body = json.decode(res.body);

      if (res.statusCode == 200 && body['result'] == true) {
        return {'success': true, 'data': body};
      } else {
        return {'success': false, 'message': body["message"]};
      }
    } catch (e) {
      print(e.toString());
      return {
        'success': false,
        'message': "Can't connect server.\n\r Please check your connection!"
      };
    }
  }

  static Future<Map<String, dynamic>> updatePlaceImage(
      Map<String, dynamic> data, String filePath,
      {Function(int, int)? onSendProgress}) async {
    try {
      //
      final dio = Dio();
      final api = new Network();
      String apiEndpoint = await api.getAppURL();
      Logger().i(apiEndpoint);
      final url = "${apiEndpoint}UploadPlaceImage";
      // final url = "http://162.226.37.113:3016/UploadPlaceImage";
      print('url');
      print(url);

      data.addAll({
        "image11": await MultipartFile.fromFile(filePath,
            filename: filePath.split("/").last)
      });
      FormData formData = FormData.fromMap(data);
      final response = await dio.post(url,
          data: formData,
          onSendProgress: onSendProgress,
          options: Options(headers: {
            'Content-type': 'multipart/form-data',
            'Accept': 'application/json',
          }));
      return response.data;
    } catch (e) {
      print(e.toString());
      return {
        'success': false,
        'message': "Can't connect server.\n\r Please check your connection!"
      };
    }
  }

  static Future<Map<String, dynamic>> uploadPODImage(
      Map<String, dynamic> data, String filePath,
      {Function(int, int)? onSendProgress}) async {
    try {
      //
      String _url = await getDataInLocal(
              key: AppLocalKeys.API_URL, type: StorableDataType.String) ??
          '';
      String _suffix = await getDataInLocal(
              key: AppLocalKeys.API_SUFFIX, type: StorableDataType.String) ??
          '';
      String uploadURL = "UploadPODImage";
      final dio = Dio();
      // final url = "${Constant.app_base_url}UploadPODImage.ds";
      final url = _url + uploadURL + _suffix;

      data.addAll({
        "PODImage1": await MultipartFile.fromFile(
          filePath,
          filename: filePath.split("/").last,
          contentType: MediaType("image", "jpeg"), //important
        )
      });
      FormData formData = FormData.fromMap(data);
      final response = await dio.post(url,
          data: formData,
          options: Options(
            headers: {
              'Content-type': 'multipart/form-data',
              'Accept': 'application/json',
            },
          ),
          onSendProgress: onSendProgress);

      return response.data;
    } catch (e) {
      return {
        'success': false,
        'message': "Can't connect server.\n\r Please check your connection!"
      };
    }
  }

  static Future<void> saveSettings(Map<String, dynamic> body) async {
    return Network().postData(
      body,
      'settings_save',
    );
  }

  static Future<List<MessageModel>> getLastMessage(String driverId) async {
    final response = await Network()
        .getData("GetLast100Messages", params: {'driverID': '${driverId}'});
    final body = response.statusCode == 200 ? json.decode(response.body) : [];

    return (body as List).map((e) => MessageModel.fromJson(e)).toList();
  }

  static Future<void> sendMessage(Map<String, dynamic> body) async {
    await Network().postData(body, "receive_sms");
  }

  static Future<List<CompanyContact>> getListCompanyContact() async {
    final response = await Network().getData("GetCompanyContacts");
    final body = json.decode(response.body);

    return (body as List).map((e) => CompanyContact.fromJson(e)).toList();
  }

  static Future<List<dynamic>> getTimeCard(
      String driverId, String startDate) async {
    final response = await Network().getData("my_timecard",
        params: {"driverID": driverId, "start_date": startDate});
    final body = json.decode(response.body);

    print(body);

    return body;
  }

  static Future<dynamic> getClosedTripsByDriver(
      String driverId, int timeStamp) async {
    final response = await Network().getData("GetClosedTripsByDriver",
        params: {"driverID": driverId, "timestamp": timeStamp});
    final body = json.decode(response.body);

    return body;
  }

  static Future<List<Document>> getCorporateImagesList(String truckID) async {
    final response = await Network()
        .getData("GetCorporateImagesList", params: {"truckID": truckID});
    final body = json.decode(response.body);
    return (body as List).map((e) => Document.fromJson(e)).toList();
  }

  static Future<List<Document>> getTruckImagesList(String truckID) async {
    Logger().i(truckID);
    final response = await Network()
        .getData("GetTruckImagesList", params: {"truckID": truckID});
    final body = json.decode(response.body);
    return (body as List).map((e) => Document.fromJson(e)).toList();
  }

  static Future<List<Document>> getTrailerImagesList(String trailerId) async {
    //
    final response = await Network()
        .getData("GetTrailerImagesList", params: {"trailerID": trailerId});
    final body = json.decode(response.body);
    return (body as List).map((e) => Document.fromJson(e)).toList();
  }

  static Future<List<Repair>> getTruckRepairs(String truckID) async {
    final response = await Network()
        .getData("GetTruckRepairs", params: {"truckID": truckID});

    print('response');
    // Logger().i(response.body);
    final body = json.decode(response.body);
    // Logger().i(body);

    if (body is Map) {
      throw Exception(body['Error']);
    }
    return (body as List).map((e) => Repair.fromJson(e)).toList();
  }

  static Future<Map<String, dynamic>> uploadRepairImage(
      {required Map<String, dynamic> data,
      required String filePath,
      Function(int, int)? onSendProgress}) async {
    try {
      ///============================
      /// Fix Upload Part For New API
      /// ===========================

      String _url = await getDataInLocal(
              key: AppLocalKeys.API_URL, type: StorableDataType.String) ??
          '';

      String _suffix = await getDataInLocal(
              key: AppLocalKeys.API_SUFFIX, type: StorableDataType.String) ??
          '';
      String uploadURL = "UploadRepairImage";
      final dio = Dio();
      // final url = "${Constant.app_base_url}UploadRepairImage.ds";
      final url = _url + uploadURL + _suffix;
      data.addAll({
        "RepairImage": await MultipartFile.fromFile(
          filePath,
          filename: filePath.split("/").last,
          contentType: MediaType("image", "jpeg"), //important
        )
      });

      FormData formData = FormData.fromMap(data);
      final response = await dio.post(url,
          data: formData,
          options: Options(
            headers: {
              'Content-type': 'multipart/form-data',
              'Accept': 'application/json',
            },
          ),
          onSendProgress: onSendProgress);

      if (response.statusCode == 200) {
        return {'success': true, 'message': "Uploaded successfully!"};
      } else {
        return {'success': false, 'message': "Some error occured!"};
      }
    } catch (e) {
      print(e);
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<dynamic> getRepairImage(String erimgid) async {
    final response =
        await Network().getData("GetRepairImage", params: {"erimgid": erimgid});

    return response.bodyBytes;
  }

  /// "driverID": "51",
  /// "latitude": 10.04234,
  /// "longitude": 105.7755125,
  /// "timestamp": 1652888168
  static Future<dynamic> checkIn(Map<String, dynamic> data) async {
    var res = await Network().postData(
      data,
      'checkIn',
    );
    var body = json.decode(res.body);
    return body;
  }

  /// "driverID": "51",
  /// "latitude": 10.04234,
  /// "longitude": 105.7755125,
  /// "timestamp": 1652888168
  static Future<dynamic> checkOut(Map<String, dynamic> data) async {
    var res = await Network().postData(
      data,
      'checkOut',
    );
    var body = json.decode(res.body);
    return body;
  }

  static Future<dynamic> getCorpImagebyID(String imageID) async {
    final response =
        await Network().getData("GetCorpImagebyID", params: {"imgID": imageID});
    return response.bodyBytes;
  }

  static Future<dynamic> getEquipImagebyID(String imageID) async {
    final response = await Network()
        .getData("GetEquipImagebyID", params: {"imgID": imageID});
    return response.bodyBytes;
  }

  static Future<List<MyTruck>> getMyTruck(String driverId) async {
    final response =
        await Network().getData("GetMyTruck", params: {"driverID": driverId});
    final body = json.decode(response.body);
    return (body as List).map((e) => MyTruck.fromJson(e)).toList();
  }

  ///
  ///name: 12
  ///
  static Future<List<Equipment>> findEquipment(
      Map<String, dynamic> data) async {
    final response = await Network().getData("findEquipment", params: data);
    final body = json.decode(response.body);
    return (body as List).map((e) => Equipment.fromJson(e)).toList();
  }

  static Future<List<ShipmentModel>> findShipment(
      Map<String, dynamic> data) async {
    final response = await Network().getData("findShipment", params: data);
    final body = json.decode(response.body);
    return (body as List).map((e) => ShipmentModel.fromJson(e)).toList();
  }

  static Future<MyTruck?> getTrailer(int trailerId) async {
    final response = await Network().getData("GetTrailer", params: {
      "trailerID": trailerId,
    });
    final body = json.decode(response.body);
    print(body);
    if (body != null) {
      return (body as List).map((e) => MyTruck.fromJson(e)).toList().first;
    } else {
      return null;
    }
  }

  static Future<List<Plan>> getInboundPlans(Map<String, dynamic> params) async {
    final response = await Network().getData("GetInboundPlans", params: params);
    final body = json.decode(response.body);
    return (body as List).map((e) => Plan.fromJson(e)).toList();
  }

  static Future<List<PlanDetails>> getPlanDetails(String plainId) async {
    final response =
        await Network().getData("GetPlanDetails", params: {"planID": plainId});
    final body = json.decode(response.body);

    return (body as List).map((e) => PlanDetails.fromJson(e)).toList();
  }

  static Future<List<Document>> getProPictures(String pro) async {
    final response =
        await Network().getData("GetProPictures", params: {"pro": pro});
    final body = json.decode(response.body);

    return (body as List).map((e) => Document.fromJson(e)).toList();
  }

  static Future<List<RepairType>> getRepairTypes() async {
    final response = await Network().getData("GetRepairTypes");

    final body = json.decode(response.body);
    return (body as List).map((e) => RepairType.fromJson(e)).toList();
  }

  ///dueDate: "2022-05-21"
  ///repairTypeID: "2"
  ///task: "test"
  ///truckID: "39"
  ///user: "forkop"
  static Future<Map<String, dynamic>> createRepairTask(Map data) async {
    try {
      var res = await Network().postData(
        data,
        'CreateRepairTask',
      );

      var body = json.decode(res.body);

      if (res.statusCode == 200 && body['result'] == true) {
        return {'success': true, 'data': body};
      } else {
        return {'success': false, 'message': body["message"]};
      }
    } catch (e) {
      print(e.toString());

      return {
        'success': false,
        'message': "Can't connect server.\n\r Please check your connection!"
      };
    }
  }

  static Future<Map<String, dynamic>> updateODO(
      Map<String, dynamic> data) async {
    try {
      final response = await Network().postData(data, 'UpdateOdometer');
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['error'] != '' && body['error'] != null) {
          return {"success": false, "message": body['error']};
        } else {
          return {"success": true, "message": "Updated successfully!"};
        }
      } else {
        return {
          "success": false,
          "message": "Server Error! Please contact administrator"
        };
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  static Future<Map<String, dynamic>> confirmTrip(
      Map<String, dynamic> data) async {
    try {
      final response = await Network().postData(data, 'confirmtrip');
      if (response.statusCode == 200) {
        return {"success": true, "message": "Confirmed successfully!"};
      } else {
        return {
          "success": false,
          "message": "Server Error! Please contact administrator"
        };
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  /**********************************
   * @Auth: geniusdev0813@gmail.com
   * @Date: 2023.9.18
   * @Desc: Get Latest X Shipment
   */
  static Future<Map<String, dynamic>> getLastXShipments(int records) async {
    try {
      var res = await Network().getData(
        'getLastXShipments',
        params: {
          "records": records,
        },
      );

      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        // Logger().i(body);
        return {'success': true, 'data': body};
      } else {
        return {'success': false, 'message': "Some error occured"};
      }
    } catch (e) {
      Logger().e(e.toString());
      print(e.toString());
      return {
        'success': false,
        'message': "Can't connect server.\n\r Please check your connection!"
      };
    }
  }

  /**********************************
   * @Auth: geniusdev0813@gmail.com
   * @Date: 2023.9.18
   * @Desc: Get ShipmentID
   */
  static Future<Map<String, dynamic>> getShipmentID(int shipmentID) async {
    try {
      var res = await Network().getData(
        'GetShipmentID',
        params: {
          "shipmentID": shipmentID,
        },
      );

      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        // Logger().i(body);
        return {'success': true, 'data': body};
      } else {
        return {'success': false, 'message': "Some error occured"};
      }
    } catch (e) {
      Logger().e(e.toString());
      print(e.toString());
      return {
        'success': false,
        'message': "Can't connect server.\n\r Please check your connection!"
      };
    }
  }

  static Future<void> deleteAccount(int userId) async {
    try {
      var res = await Network().deleteData('user/$userId');
    } catch (e) {
      Logger().e(e.toString());
      print(e.toString());
    }
  }
}
