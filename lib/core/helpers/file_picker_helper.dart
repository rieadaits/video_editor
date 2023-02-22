import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FilePickerHelper {
  FilePickerHelper._();

  static final instance = FilePickerHelper._();

  Future<String?> getAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3','AAC','FLAC','ALAC'],
    );
    if (result != null) {
      File file = File(result.files.first.name.toString());
      return result.files.first.name.toString();
    } else {
      return null;
    }
  }

  Future<String?> getVideoFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['MP4','MOV','MPG','MPEG','AVI','WMV','WMV3','MKV'],
    );
    if (result != null) {
      File file = File(result.files.first.name.toString());
      return result.files.first.name.toString();
    } else {
      return null;
    }
  }
}
