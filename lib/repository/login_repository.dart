import 'package:flutter_info_app/common/api_provider.dart';
import 'package:flutter_info_app/model/login.dart';
import 'package:flutter_info_app/model/token.dart';

class LoginRepository {
  final ApiProvider apiProvider;

  LoginRepository(this.apiProvider);

  Future<Token> login(Login model) {
    return apiProvider.login(model);
  }
}
