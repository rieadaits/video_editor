
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_editor/landing/cubit/file_picker/file_picker_cubit.dart';
import 'package:video_editor/landing/cubit/video_saver/video_saver_cubit.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilePickerCubit, FilePickerState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Center(
            child: BlocBuilder<VideoSaverCubit, VideoSaverState>(
              builder: (context, videoSaverState) {
                return Column(mainAxisSize: MainAxisSize.min, children: [
                  videoSaverState.loadingCircular
                      ? _buildLoadingWidget()
                      : const SizedBox.shrink(),
                  Text(
                    state.videoFileName,
                    style: const TextStyle(color: Colors.black),
                  ),
                  ElevatedButton(
                    child: const Text(
                      "Pick a Video",
                    ),
                    onPressed: () => _onPickVideo(),
                  ),
                  ElevatedButton(
                    child: const Text("get video duration"),
                    onPressed: () =>
                        _onGetVideoDuration(state.videoFilePath),
                  ),
                  Text(
                    state.audioFileName,
                    style: const TextStyle(color: Colors.black),
                  ),
                  ElevatedButton(
                    child: const Text("Pick a Audio"),
                    onPressed: () => _onPickAudio(),
                  ),
                  ElevatedButton(
                    child: const Text(
                      "Merge Audio and Video",
                    ),
                    onPressed: () =>
                        _onMergeVideoAndAudio(
                          state.videoFilePath,
                          state.audioFilePath,
                        ),
                  ),
                ]);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingWidget() {
    return const CircularProgressIndicator();
  }

  void _onPickAudio() {
    final filePickerCubit = context.read<FilePickerCubit>();
    filePickerCubit.getAudioFile();
  }

  void _onPickVideo()  {
    final filePickerCubit = context.read<FilePickerCubit>();
    filePickerCubit.getVideoFile();
  }

  void _onGetVideoDuration(String videoFilePath) {
    final videoSaverCubit = context.read<VideoSaverCubit>();
    videoSaverCubit.getVideoDuration(videoFilePath);
  }

  void _onMergeVideoAndAudio(String videoFilePath, String audioFilePath) {
    final videoSaverCubit = context.read<VideoSaverCubit>();
    videoSaverCubit.mergeVideoAndAudio(
      videoPath: videoFilePath,
      audioPath: audioFilePath,
    );
  }
}
