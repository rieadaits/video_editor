import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_editor/core/helpers/utility_helper.dart';

part 'video_saver_state.dart';

class VideoSaverCubit extends Cubit<VideoSaverState> {
  VideoSaverCubit() : super(const VideoSaverState());

  Future<void> mergeVideoAndAudio({
    required String videoPath,
    required String audioPath,
  }) async {
    if (await UtilityHelper.instance.requestPermission(Permission.storage)) {
      emit(state.copyWith(loadingCircular: true));
      final outputPath =
          await UtilityHelper.instance.getOutputVideoPath(File(videoPath));
      final arguments = [
        '-i',
        videoPath,
        '-i',
        audioPath,
        '-c:v',
        'copy',
        '-c:a',
        'aac',
        '-map',
        '0:v:0',
        '-map',
        '1:a:0',
        // '-shortest',
        outputPath!
      ];
      final rc = (await FFmpegKit.executeWithArguments(arguments));
      log('video duration: ${await rc.getDuration()}');
      await GallerySaver.saveVideo(outputPath, albumName: "saver");

      emit(state.copyWith(loadingCircular: false));
    } else if (await Permission.storage.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> getVideoDuration(String videoPath) async {
    final probeResult = await FFprobeKit.getMediaInformation(videoPath);
    final videoDuration = probeResult.getMediaInformation();
    log('videoDuration: ${videoDuration?.getDuration()}');
  }
}
