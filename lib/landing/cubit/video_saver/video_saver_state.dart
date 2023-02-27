part of 'video_saver_cubit.dart';

class VideoSaverState extends Equatable {
  const VideoSaverState({this.loadingCircular = false});

  final bool loadingCircular;

  VideoSaverState copyWith({bool? loadingCircular}) =>
      VideoSaverState(loadingCircular: loadingCircular ?? this.loadingCircular);

  @override
  List<Object> get props => [loadingCircular];
}
