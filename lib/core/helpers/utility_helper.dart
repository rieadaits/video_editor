import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UtilityHelper {
  UtilityHelper._();

  static final instance = UtilityHelper._();

  Future<String?> getOutputVideoPath(File videoFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final newPath = '$path/${DateTime.now().millisecondsSinceEpoch}.mp4';
      log("path: $newPath");
      return newPath;
    } catch (e) {
      log("There has an error!");
      return null;
    }
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.status.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
}
