import 'dart:convert';

import '../constant/constant.dart';
import '../constant/local_key.dart';
import '../models/auth_model.dart';
import '../utils/logger.dart';

class MyLocalStorage {
  dynamic read(String key) {
    return Constant.pref?.get(key);
  }

  Future<bool> write(String key, value) async {
    Logger.println("Data Value : $value");
    return Constant.pref!.setString(key, value);
  }

  Future<bool> delete(String key) async {
    return Constant.pref!.remove(key);
  }

  Future<bool> clear() async {
    return Constant.pref!.clear();
  }

  String? getToken() {
    String token;
    token = read(LocalStorageKeys.token);
    return token;
  }

  User? getUser() {
    User? user;
    var data = read(
      LocalStorageKeys.userData,
    );
    if (data != null) {
      user = User.fromJson(jsonDecode(data));
    } else {
      user = null;
    }
    return user;
  }

  List<LeaveBalance>? getLeave() {
    List<LeaveBalance>? leave;
    var data = read(
      LocalStorageKeys.leaveData,
    );
    if (data != null) {
      leave = List<LeaveBalance>.from(jsonDecode(data).map((x) => LeaveBalance.fromJson(x)));
    } else {
      leave = null;
    }
    return leave;
  }
}
