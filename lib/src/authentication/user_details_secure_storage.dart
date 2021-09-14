import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/authentication/user_details_storage.dart';

class UserDetailsSecureStorage extends UserDetailsStorage {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void>? _ready;

  Future<T> _whenReady<T>(Future<T> future) async {
    if (_ready != null) {
      await _ready;
    }

    _ready = future;

    return await future;
  }

  @override
  Future<void> deleteUserDetails() async {
    await _whenReady(secureStorage.delete(key: kUserDetailsKey));

    controller.add(UserDetails.kInvalid);
  }

  @override
  Future<UserDetails> getUserDetails() async {
    final userDetails =
        await _whenReady(secureStorage.read(key: kUserDetailsKey));
    if (userDetails == null) {
      return UserDetails.kInvalid;
    }

    final map = json.decode(userDetails);
    return UserDetails.fromJson(map);
  }

  @override
  Future<void> saveUserDetails(UserDetails userDetails) async {
    final value = json.encode(userDetails);

    await _whenReady(secureStorage.write(key: kUserDetailsKey, value: value));

    controller.add(userDetails);
  }
}
