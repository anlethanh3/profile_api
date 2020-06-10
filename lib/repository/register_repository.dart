import 'package:flutter_info_app/common/api_provider.dart';
import 'package:flutter_info_app/model/profile.dart';
import 'package:flutter_info_app/model/token.dart';

class RegisterRepository {
  final ApiProvider apiProvider;

  RegisterRepository(this.apiProvider);

  Future<Token> register(Profile model) {
    return apiProvider.register(model);
  }
}
