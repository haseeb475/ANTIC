import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  var picPath = ''.obs;

  changeImage(context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 100);
      if (img == null) return;

      picPath.value = img.path;
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  changeImageCamera(context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 100);
      if (img == null) return;

      picPath.value = img.path;
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }
}
