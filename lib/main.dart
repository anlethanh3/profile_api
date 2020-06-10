import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_info_app/common/storage.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

import 'common/api_provider.dart';
import 'common/helper.dart';
import 'common/routes.dart';
import 'common/style.dart';

void main() {
  final injector = Injector.getInjector();
  final router = Router();
  final helper = Helper();
  final storage = Storage();
  Routes.configureRoutes(router);
  injector.map((injector) => helper, isSingleton: true);
  injector.map((injector) => ApiProvider(helper, storage), isSingleton: true);
  injector.map((injector) => Style(), isSingleton: true);
  injector.map((injector) => storage, isSingleton: true);
  injector.map((injector) => router, isSingleton: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final router = Injector.getInjector().get<Router>();
  final style = Injector.getInjector().get<Style>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JAMSTACK',
      theme: ThemeData(
        primarySwatch: style.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: router.generator,
    );
  }
}
