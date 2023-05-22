import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCrop extends StatefulWidget {
  const ImageCrop({Key? key}) : super(key: key);

  @override
  State<ImageCrop> createState() => _ImageCropState();
}

class _ImageCropState extends State<ImageCrop> {
  XFile? _image;
  int? _width;
  int? _height;
  CroppedFile? imageCrop;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.bottom;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
             padding: const EdgeInsets.symmetric(horizontal: 20),
              constraints: BoxConstraints(
                maxWidth: 1 * screenWidth,
                maxHeight: 0.5*screenHeight,
              ),
              child: _image != null
                  ? Image.file(
                      File(_image?.path ?? ''),
                    )
                  : const Text('pls chosse file'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                _cropImage();
              },
              child: Container(
                width: 0.3 * screenWidth,
                height: 0.1 * screenWidth,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 2,
                    )),
                child: const Text(
                  'Crop Image',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            imageCrop != null
                ? Text('width : $_width x  height: $_height')
                : const SizedBox(),
            const SizedBox(height: 10),
            Container(
              constraints: BoxConstraints(
                maxWidth:  screenWidth,
                  maxHeight: 0.5*screenHeight,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: imageCrop != null
                  ? Image.file(
                      File(imageCrop?.path ?? ''),
                    )
                  : Icon(
                      Icons.camera_alt_outlined,
                      size: 0.9 * screenWidth,
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _initGallery,
            child: const Icon(Icons.image),
          ),
          const SizedBox(height: 30),
          FloatingActionButton(
            onPressed: _initCamera,
            child: const Icon(Icons.camera_alt_outlined),
          ),
        ],
      ),
    );
  }

  void _initGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var decodedImage = await decodeImageFromList(await image.readAsBytes());
      print('Image: ${decodedImage.width} - ${decodedImage.height}');
      setState(() {
        _image = image;
      });
    }
  }

  void _initCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      var decodedImage = await decodeImageFromList(await photo.readAsBytes());
      print('Image: ${decodedImage.width} - ${decodedImage.height}');
      setState(() {
        _image = photo;
      });
    }
  }

  Future<void> _cropImage() async {
    if (_image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        var decodedImage =
            await decodeImageFromList(await croppedFile.readAsBytes());
        print('Image: ${decodedImage.width} - ${decodedImage.height}');
        setState(() {
          imageCrop = croppedFile;
          _width = decodedImage.width;
          _height = decodedImage.height;
        });
      }
    }
  }
}
