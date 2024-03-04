import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrimatch_mobile/theme/theme.dart';
import 'package:permission_handler/permission_handler.dart';

Widget loadImageFromUrl(String? imageUrl, BoxFit fit,
    {double? height, double? width, double? maxHeight, double? maxWidth}) {
  try {
    if (imageUrl == null) {
      return FittedBox(
        fit: fit,
        child: Icon(
          Icons.fastfood,
          size: max(maxHeight ?? height ?? 50, maxWidth ?? width ?? 50),
          color: Colors.grey,
        ),
      );
    }
    return Image.network(
      imageUrl,
      fit: fit,
      height: getHeight(height, maxHeight),
      width: getWidth(width, maxWidth),
    );
  } catch (e) {
    return FittedBox(
      fit: fit,
      child: Icon(
        Icons.fastfood,
        size: max(maxHeight ?? height ?? 50, maxWidth ?? width ?? 50),
        color: Colors.grey,
      ),
    );
  }
}

Widget loadImageFromFile(File? imageFile, BoxFit fit,
    {double? height, double? width, double? maxHeight, double? maxWidth}) {
  try {
    if (imageFile == null) {
      return FittedBox(
        fit: fit,
        child: Icon(
          Icons.fastfood,
          size: max(maxHeight ?? height ?? 50, maxWidth ?? width ?? 50),
          color: Colors.grey,
        ),
      );
    }
    return Image.file(
      imageFile,
      fit: fit,
      height: getHeight(height, maxHeight),
      width: getWidth(width, maxWidth),
    );
  } catch (e) {
    return FittedBox(
      fit: fit,
      child: Icon(
        Icons.fastfood,
        size: max(maxHeight ?? height ?? 50, maxWidth ?? width ?? 50),
        color: Colors.grey,
      ),
    );
  }
}

showPermissionDenyDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actionsPadding: const EdgeInsets.only(
          right: 20,
          bottom: 10,
          top: 10,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              surfaceTintColor: Colors.white,
              fixedSize: const Size(80, 40),
              shadowColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              elevation: 0,
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: lightColorScheme.primary,
              surfaceTintColor: Colors.white,
              fixedSize: const Size(80, 40),
              shadowColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              elevation: 0,
            ),
            child: const Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future<XFile> imgFromGallery(BuildContext context) async {
  ImagePicker picker = ImagePicker();
  return await picker
      .pickImage(source: ImageSource.gallery, imageQuality: 50)
      .then((value) => value ?? (throw Exception('Image not selected')))
      .catchError((e) async {
    debugPrint(e.toString());
    PermissionStatus status = await Permission.photos.status;
    if ((status.isDenied || status.isPermanentlyDenied) &&
        context.mounted &&
        !e.toString().contains('Image not selected')) {
      showPermissionDenyDialog(context, 'Gallery Permission Denied',
          'Please allow access to your gallery to select a photo.');
    }
    throw Exception('Image not selected');
  });
}

Future<XFile> imgFromCamera(BuildContext context) async {
  ImagePicker picker = ImagePicker();
  return await picker
      .pickImage(source: ImageSource.camera, imageQuality: 50)
      .then((value) => value ?? (throw Exception('Image not taken')))
      .catchError((e) async {
    PermissionStatus status = await Permission.camera.status;
    if ((status.isDenied || status.isPermanentlyDenied) && context.mounted) {
      showPermissionDenyDialog(context, 'Camera Permission Denied',
          'Please allow access to your camera to take a photo.');
    }
    throw Exception('Image not taken');
  });
}

Future<XFile> cropImage(BuildContext context, XFile imgFile) async {
  const String title = 'Crop to fit your food';
  final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: title,
            toolbarColor: Colors.white,
            toolbarWidgetColor: lightColorScheme.primary,
            activeControlsWidgetColor: lightColorScheme.primary,
            dimmedLayerColor: Colors.black.withOpacity(0.5),
            backgroundColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: title,
        )
      ]);
  if (croppedFile != null) {
    imageCache.clear();
    return XFile(croppedFile.path);
  }
  throw Exception('Image not cropped');
}

double? getHeight(double? height, double? maxHeight) {
  if (height == null) {
    return null;
  } else if (maxHeight == null) {
    return height;
  } else {
    return min(height, maxHeight);
  }
}

double? getWidth(double? width, double? maxWidth) {
  if (width == null) {
    return null;
  } else if (maxWidth == null) {
    return width;
  } else {
    return min(width, maxWidth);
  }
}
