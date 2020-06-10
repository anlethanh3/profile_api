import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_info_app/common/routes.dart';
import 'package:flutter_info_app/common/storage.dart';
import 'package:flutter_info_app/common/style.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final style = Injector.getInjector().get<Style>();
  final router = Injector.getInjector().get<Router>();
  final storage = Injector.getInjector().get<Storage>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration(seconds: 2)).then((value) async {
      await storage.load();
      if ((storage.token?.auth ?? false) == true) {
        return true;
      }
      return false;
    }).then((value) => router.navigateTo(
        context, !value ? Routes.login : Routes.home,
        replace: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          style.logoImage,
          width: 300,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
