import 'package:image_picker/image_picker.dart';

class VideoPickerHelper {
  VideoPickerHelper._();

  static final instance = VideoPickerHelper._();
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> getVideoFromGallery() async {
    return await _picker.pickVideo(source: ImageSource.gallery);
  }

  Future<XFile?> getVideoFromCamera() async {
    return await _picker.pickVideo(source: ImageSource.camera);
  }
}