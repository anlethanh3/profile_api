import 'dart:convert';

import 'package:flutter_info_app/model/profile.dart';
import 'package:flutter_info_app/model/token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  Token token;
  Profile profile;
  final _storage = new FlutterSecureStorage();
  final _KEY = "KEY_TOKEN";

  Future load() async {
    final json = await _storage.read(key: _KEY);
    if (json != null) {
      token = Token.fromJson(jsonDecode(json));
    }
    return;
  }

  Future save(Token token) async {
    this.token = token;
    await _storage.write(key: _KEY, value: jsonEncode(token.toJson()));
    return;
  }

  Future clear() async {
    this.token = null;
    this.profile = null;
    await _storage.delete(key: _KEY);
    return;
  }
}
