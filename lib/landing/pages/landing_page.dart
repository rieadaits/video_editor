import 'dart:async';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_editor/core/helpers/file_picker_helper.dart';
import 'package:video_editor/core/utils/constant.dart';
import 'package:video_editor/landing/cubit/file_picker/file_picker_cubit.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final navigatorKey = GlobalKey<NavigatorState>();
  late XFile _video;
  bool loading = false;
  static const EventChannel _channel = EventChannel('video_editor_progress');
  late StreamSubscription _streamSubscription;
  int processPercentage = 0;
  dynamic limit = 10;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> mergeIntoVideo() async {
    final FFmpegKit _flutterFFmpeg = FFmpegKit();
    loading = true;
    String timeLimit = '00:00:';
    setState(() {});

    if (await Permission.storage.request().isGranted) {
      if (limit.toInt() < 10) {
        timeLimit = '${timeLimit}0$limit';
      } else {
        timeLimit = timeLimit + limit.toString();
      }

      /// To combine audio with video
      ///
      /// Merging video and audio, with audio re-encoding
      /// -c:v copy -c:a aac
      ///
      /// Copying the audio without re-encoding
      /// -c copy
      ///
      /// Replacing audio stream
      /// -c:v copy -c:a aac -map 0:v:0 -map 1:a:0
      // String commandToExecute =
      //     '-r 15 -f mp4 -i ${Constants.VIDEO_PATH} -f mp3 -i ${Constants.AUDIO_PATH} -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -t $timeLimit -y ${Constants.OUTPUT_PATH}';

      //String commandToExecute = '-i ${Constants.VIDEO_PATH} -i ${Constants.VIDEO_PATH2} -filter complex amerge ${Constants.OUTPUT_PATH}';
      String commandToExecute =
          '-i ${Constants.videoPath} -i ${Constants.videoPath2} -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1 [v] [a]" -map "[v]" -map "[a]" ${Constants.outputPath}';

      // var arguments = ["-i", "${Constants.VIDEO_PATH}", "-c:v", "mpeg4", "-vf", "drawtext=text='My text starting at 640x360':x=640:y=360:fontsize=24:fontcolor=white", "-c:a", "copy", "${Constants.OUTPUT_PATH}"];
      var arguments = [
        "-i",
        "/storage/emulated/0/Download/Video1.mp4",
        "-vf",
        "drawtext=text=",
        "Krishna:x=640:y=360:fontsize=24:fontcolor=white",
        "-c:a",
        "copy",
        "/storage/emulated/0/Download/output.mp4"
      ];

      /// // To combine audio with image
      // String commandToExecute =
      //     '-r 15 -f mp3 -i ${Constants.AUDIO_PATH} -f image2 -i ${Constants.IMAGE_PATH} -pix_fmt yuv420p -t $timeLimit -y ${Constants.OUTPUT_PATH}';

      /// To combine audio with gif
      // String commandToExecute = '-r 15 -f mp3 -i ${Constants
      //     .AUDIO_PATH} -f gif -re -stream_loop 5 -i ${Constants.GIF_PATH} -y ${Constants
      //     .OUTPUT_PATH}';

      /// To combine audio with sequence of images
      // String commandToExecute = '-r 30 -pattern_type sequence -start_number 01 -f image2 -i ${Constants
      //     .IMAGES_PATH} -f mp3 -i ${Constants.AUDIO_PATH} -y ${Constants
      //     .OUTPUT_PATH}';

      await FFmpegKit.execute(commandToExecute).then((rc) {
        loading = false;
        setState(() {});
        print('FFmpeg process exited with rc: $rc');
        // controller = VideoPlayerController.asset(Constants.OUTPUT_PATH)
        //   ..initialize().then((_) {
        //     notifyListeners();
        //   });
      });
    } else if (await Permission.storage.isPermanentlyDenied) {
      loading = false;
      setState(() {});
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilePickerCubit, FilePickerState>(
  builder: (context, state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min,
            children: [
              loading ? _buildLoadingWidget() : const SizedBox.shrink(),
              Text(state.videoFileName,style: const TextStyle(color: Colors.black),),
              ElevatedButton(
                child: const Text("Pick a Video",),
                onPressed: () async => _onPickVideo(),
              ),
              Text(state.audioFileName,style: const TextStyle(color: Colors.black),),
              ElevatedButton(
                child: const Text("Pick a Audio"),
                onPressed: () async => _onPickAudio(),
              ),
            ]),
      ),
    );
  },
);
  }

  Widget _buildLoadingWidget() {
    return Column(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 10),
        Text(
          "$processPercentage%",
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
  Future<void> _onPickAudio() async {
    final filePickerCubit = context.read<FilePickerCubit>();
    filePickerCubit.getAudioFile();
  }
  Future<void> _onPickVideo() async {
    final filePickerCubit = context.read<FilePickerCubit>();
    filePickerCubit.getVideoFile();
  }
}