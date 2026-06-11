import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/local_key.dart';
import '../../models/auth_model.dart';
import '../../utils/logger.dart';

class PreferenceManagerRepository {
  User? user;
  List<LeaveBalance>? leave;

  PreferenceManagerRepository() {
    var prefStream = SharedPreferences.getInstance().asStream();
    prefStream.listen((preference) {
      Logger.println(
          "PreferenceManagerRepository: event: ${preference.containsKey(LocalStorageKeys.userData)}");
      if (preference.containsKey(LocalStorageKeys.userData)) {
        user = User.fromJson(
            jsonDecode(preference.getString(LocalStorageKeys.userData)!));
      }
      if (preference.containsKey(LocalStorageKeys.leaveData)) {
        leave = List<LeaveBalance>.from(jsonDecode(preference.getString(LocalStorageKeys.leaveData)!).map((x) => LeaveBalance.fromJson(x)));
      }
    });
  }

  clearPreferences() {
    user = null;
    leave = null;
  }
}
