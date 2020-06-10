import 'package:flutter_info_app/common/api_provider.dart';
import 'package:flutter_info_app/model/profile.dart';
import 'package:flutter_info_app/model/token.dart';

class ProfileRepository {
  final ApiProvider apiProvider;

  ProfileRepository(this.apiProvider);

  Future<Profile> getProfile() {
    return apiProvider.getProfile();
  }
}
