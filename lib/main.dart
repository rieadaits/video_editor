import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import 'constant.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  late XFile _video;
  bool loading = false;
  static const EventChannel _channel =
  EventChannel('video_editor_progress');
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
    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
    loading = true;
    String timeLimit = '00:00:';
    setState(() {

    });

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
      String commandToExecute =
          '-r 15 -f mp4 -i ${Constants.VIDEO_PATH} -f mp3 -i ${Constants.AUDIO_PATH} -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -t $timeLimit -y ${Constants.OUTPUT_PATH}';

      /// To combine audio with image
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

      await _flutterFFmpeg.execute(commandToExecute).then((rc) {
        loading = false;
        setState(() {

        });
        print('FFmpeg process exited with rc: $rc');
        // controller = VideoPlayerController.asset(Constants.OUTPUT_PATH)
        //   ..initialize().then((_) {
        //     notifyListeners();
        //   });
      });
    } else if (await Permission.storage.isPermanentlyDenied) {
      loading = false;
      setState(() {

      });
      openAppSettings();
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: loading ? Column(mainAxisSize: MainAxisSize.min,children:[

              const CircularProgressIndicator(),
              const SizedBox(height: 10),
              Text("$processPercentage%", style: const TextStyle(fontSize: 20),),
            ] ) : ElevatedButton(
              child: const Text("Pick a video and Edit it"),
              onPressed: () async {
                print("clicked!");
                var tempDir = await getTemporaryDirectory();
                final path = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}result.mp4';
                await mergeIntoVideo();
              },
            )),
      ),
    );
  }
}

class VideoScreen extends StatefulWidget {
  final String path;

  const VideoScreen(this.path);

  @override
  _VideoAppState createState() => _VideoAppState(path);
}

class _VideoAppState extends State<VideoScreen> {
  final String path;

  _VideoAppState(this.path);

  late VideoPlayerController _controller;


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (!_controller.value.isPlaying &&
                _controller.value.isInitialized &&
                (_controller.value.duration == _controller.value.position)) {
              _controller.initialize();
              _controller.play();
            } else {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}