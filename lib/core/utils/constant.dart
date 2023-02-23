import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

class Constants {
  Constants._();
  var uuid = const Uuid().v4();

  static const String basePath = '/storage/emulated/0/Download/';

  static const String imagePath = '${basePath}Images.png';
  static const String videoPath = '${basePath}Video1.mp4';
  static const String videoPath2 = '${basePath}Video2.mp4';
  static const String gitPath = '${basePath}giphy.gif';
  static const String audioPath = '${basePath}audio.mp3';
  static String outputPath = "$basePath${DateTime.now().millisecondsSinceEpoch}.mp4";

  //color constants

  static const Color grey800 = Color(0xff424242);
  static const Color grey900 = Color(0xff212121);
  static const Color primaryColor = Color(0xffFFAB40);
  static const Color blue500 = Color(0xff2196F3);
}