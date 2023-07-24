import 'package:dio/dio.dart';

class HttpError {
  int? statusCode;
  String? message;
  int? code;
  Response? response;

  HttpError({this.statusCode, this.message, this.code, this.response});
}
