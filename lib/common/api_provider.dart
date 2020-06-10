import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_info_app/common/helper.dart';
import 'package:flutter_info_app/common/storage.dart';
import 'package:flutter_info_app/model/login.dart';
import 'package:flutter_info_app/model/profile.dart';
import 'package:flutter_info_app/model/token.dart';

class ApiProvider {
  final Helper helper;
  final Storage storage;
  final _dio = Dio();

  ApiProvider(this.helper, this.storage) {
    BaseOptions options = new BaseOptions(
      baseUrl: "https://radiant-dusk-57430.herokuapp.com/api",
      connectTimeout: 30000,
      receiveTimeout: 30000,
    );
    _dio.options = options;
    _dio.options.contentType = "application/json";
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (Options options) async {
      // If no token, request token firstly and lock this interceptor
      // to prevent other request enter this interceptor.
//      _dio.interceptors.requestLock.lock();
//      print("*******");
//      print("Method: ${options.method}");
//      _dio.interceptors.requestLock.unlock();
      return options; //continue
    }, onResponse: (response) async {
//      print("url: ${response.realUri}");
      print("");
    }, onError: (error) {
      print(error);
    }));
  }

  Future<Token> register(Profile model) async {
    final response = await _dio.post(
        "/auth/register",
        data: model.toJson());
    if (response.statusCode == 200) {
      return Token.fromJson(response.data);
    } else {
      throw Exception('ERR_REGISTER');
    }
  }

  Future<Token> login(Login model) async {
    final response = await _dio.post(
        "/auth/login",
        data: model.toJson());
    if (response.statusCode == 200) {
      return Token.fromJson(response.data);
    } else {
      throw Exception('ERR_LOGIN');
    }
  }

  Future<Profile> getProfile() async {
    final response = await _dio.get(
        "/auth/me",
        options: Options(
            headers: {"x-access-token": storage.token?.accessToken() ?? ""},
            contentType: "application/json"));
    if (response.statusCode == 200) {
      return Profile.fromJson(response.data);
    } else {
      throw Exception('ERR_PROFILE');
    }
  }
}
