import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_editor/core/helpers/video_picker_helper.dart';

part 'file_picker_state.dart';

class FilePickerCubit extends Cubit<FilePickerState> {
  FilePickerCubit() : super(const FilePickerState());

  Future<void> getAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'mp3',
        'AAC',
        'FLAC',
        'ALAC',
      ],
    );
    if (result != null) {
      File file = File(result.files.first.path.toString());
      emit(
        state.copyWith(
          audioFilePath: file.path,
          audioFileName: result.files.first.name.toString(),
        ),
      );
    }
  }

  Future<void> getVideoFile() async {
    if(Platform.isIOS){
      final file = await VideoPickerHelper.instance.getVideoFromGallery();
      emit(state.copyWith(videoFilePath: file?.path, videoFileName: file?.name));
    }else{
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'MP4',
          'MOV',
          'MPG',
          'MPEG',
          'AVI',
          'WMV',
          'WMV3',
          'MKV'
        ],
      );
      if (result != null) {
        File file = File(result.files.first.path.toString());
        emit(state.copyWith(videoFilePath: file.path, videoFileName: result.files.first.name));
      }
    }

  }
}
