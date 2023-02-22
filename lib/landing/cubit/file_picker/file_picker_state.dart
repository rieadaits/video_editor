part of 'file_picker_cubit.dart';

class FilePickerState extends Equatable {
  const FilePickerState({
    this.audioFileName = '',
    this.audioFilePath = '',
    this.videoFileName = '',
    this.videoFilePath = '',
  });

  final String audioFileName;
  final String audioFilePath;
  final String videoFileName;
  final String videoFilePath;

  FilePickerState copyWith({
    String? audioFileName,
    String? audioFilePath,
    String? videoFileName,
    String? videoFilePath,
  }) =>
      FilePickerState(
        audioFileName: audioFileName ?? this.audioFileName,
        audioFilePath: audioFilePath ?? this.audioFilePath,
        videoFileName: videoFileName ?? this.videoFileName,
        videoFilePath: videoFilePath ?? this.videoFilePath,
      );

  @override
  List<Object?> get props => [
        audioFilePath,
        audioFileName,
        videoFilePath,
        videoFileName,
      ];

  @override
  String toString() {
    return 'FilePickerState{audioFilePath: $audioFilePath, audioFileName: $audioFileName, videoFilePath: $videoFilePath, videoFileName: $videoFileName';
  }
}
