import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_info_app/screen/home.dart';
import 'package:flutter_info_app/screen/login.dart';
import 'package:flutter_info_app/screen/sign_up.dart';
import 'package:flutter_info_app/screen/splash.dart';

class Routes {
  static String root = "/";
  static String login = "/login";
  static String home = "/home";
  static String profile = "/home/profile";
  static String signup = "/signup";

  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
    });
    router.define(root,
        handler: Handler(
            handlerFunc: (context, params) => Splash(),
            type: HandlerType.route));
    router.define(login,
        handler: Handler(
            handlerFunc: (context, params) => Login(),
            type: HandlerType.route));
    router.define(home,
        handler: Handler(
            handlerFunc: (context, params) => Home(false),
            type: HandlerType.route));
    router.define(profile,
        handler: Handler(
            handlerFunc: (context, params) => Home(true),
            type: HandlerType.route));
    router.define(signup,
        handler: Handler(
            handlerFunc: (context, params) => SignUp(),
            type: HandlerType.route));
  }
}
