import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import '../constant/config.dart';
import '../constant/enum.dart';
import '../model/req_error.dart';

const String errEmoji = '❌';

// http requests are handled with Dio package
// base configuration of the dio package
// for testing purpose timeout is longer than usual
Dio dio = Dio(BaseOptions(
  baseUrl: baseUrl,
  connectTimeout: const Duration(seconds: 360),
  receiveTimeout: const Duration(seconds: 360),
  headers: {HttpHeaders.userAgentHeader: 'dio', 'api': '1.0.0'},
  contentType: Headers.jsonContentType,
));

// Send request method : Other api classes will use the method
Future<Map<String, dynamic>> sendRequest(String route,
    {ReqType? method = ReqType.get,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
    bool handler = true}) async {
  // api route used with baseurl
  String uri = route;
  // helper emoji to print with colors
  String emoji = setEmoji(method: method);
  Response? res;

  debugPrint(
      '$emoji ${method.toString()} - $route - Request : queryParams: $queryParams, body : $body, $emoji');

  try {
    // sending request with the help of private function
    res = await _sendHTTPReq(uri, method: method, queryParams: queryParams, body: body);
    // depending on the type of the response, the variable could be error :
    dynamic result = reqErrHandler(res);

    // If the error should be shown to the user, show with snackbar :
    if (result.runtimeType == HttpError && handler == true) {
      debugPrint("$errEmoji Error.message = > ${result.message} $errEmoji");

      Get.showSnackbar(GetSnackBar(
          duration: const Duration(seconds: 2),
          isDismissible: true,
          backgroundColor: Colors.redAccent,
          message: result.message));

      return {"result": []};
    }

    return {"result": result};
  } catch (ex) {
    debugPrint('$errEmoji Error occured in http request dio error : $errEmoji');
    debugPrint(ex.toString());

    // Errors that should be handled outside try method, ends here :
    Get.showSnackbar(const GetSnackBar(
        duration: Duration(seconds: 2),
        isDismissible: true,
        backgroundColor: Colors.redAccent,
        message: 'Unknown error occured, please try again later :('));
    return {"result": []};
  }
}

// http request type helper with enums
Future<Response> _sendHTTPReq(String uri,
    {ReqType? method,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams}) async {
  Response res;
  switch (method) {
    case ReqType.get:
      res = await dio.get(uri, data: body, queryParameters: queryParams);
      break;
    case ReqType.post:
      res = await dio.post(uri, data: body, queryParameters: queryParams);
      break;
    case ReqType.put:
      res = await dio.put(uri, data: body, queryParameters: queryParams);
      break;
    case ReqType.delete:
      res = await dio.delete(uri, data: body, queryParameters: queryParams);
      break;
    default:
      res = await dio.get(uri, data: body, queryParameters: queryParams);
      break;
  }

  return res;
}

// Request types can be printed with respective color emoji
String setEmoji({ReqType? method}) {
  String emoji = '';
  switch (method) {
    case ReqType.get:
      emoji = '🟢';
      break;
    case ReqType.post:
      emoji = '🟠';
      break;
    case ReqType.put:
      emoji = '🔵';
      break;
    case ReqType.delete:
      emoji = '🔴';
      break;
    default:
      emoji = '🟢';
      break;
  }
  return emoji;
}

// If the res code is not success, return helper class with error
dynamic reqErrHandler(Response? res) {
  if (res?.statusCode != null) {
    List<int> successCodes = [200, 201, 304];
    int code = res?.statusCode ?? 401;
    bool reqSuccess = successCodes.contains(code);

    if (!reqSuccess) {
      HttpError error = HttpError(
          response: res,
          statusCode: code,
          code: res?.data['code'],
          message: res?.data['message']);
      return error;
    }
  }
  return res?.data;
}
