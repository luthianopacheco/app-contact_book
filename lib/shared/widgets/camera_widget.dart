import 'package:contact_list/controller/contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart';

class Camera extends GetView<ContactController> {
  const Camera({super.key});

  cropImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.white,
            activeControlsWidgetColor: const Color.fromARGB(255, 0, 156, 89),
            toolbarWidgetColor: const Color.fromARGB(255, 0, 156, 89),
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      await GallerySaver.saveImage(croppedFile.path);
      controller.imagePath.value = croppedFile.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          leading: const FaIcon(
            FontAwesomeIcons.cameraRetro,
            color: Color.fromARGB(255, 0, 156, 89),
          ),
          title: const Text('Camera'),
          onTap: () async {
            Get.back();
            final ImagePicker picker = ImagePicker();
            final XFile? photo =
                await picker.pickImage(source: ImageSource.camera);

            if (photo != null) {
              String path =
                  (await path_provider.getApplicationDocumentsDirectory()).path;
              String name = basename(photo.path);
              await photo.saveTo("$path/$name");
              cropImage(photo);
            }
          },
        ),
        ListTile(
          leading: const FaIcon(
            FontAwesomeIcons.solidImages,
            color: Color.fromARGB(255, 0, 156, 89),
          ),
          title: const Text('Galeria'),
          onTap: () async {
            Get.back();
            ImagePicker picker = ImagePicker();
            XFile? photo = await picker.pickImage(source: ImageSource.gallery);
            controller.imagePath.value = photo?.path ?? '';
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.close,
            color: Color.fromARGB(255, 0, 156, 89),
          ),
          title: const Text('Remover imagem'),
          onTap: () async {
            Get.back();
            controller.imagePath.value = '';
          },
        ),
      ],
    );
  }
}
