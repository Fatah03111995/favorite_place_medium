import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final void Function(File) onPickImage;
  const ImageInput({super.key, required this.onPickImage});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: _selectedImage != null
              ? DecorationImage(
                  image: FileImage(_selectedImage!), fit: BoxFit.cover)
              : null,
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: TextButton.icon(
        onPressed: _takePicture,
        label: const Text('Take Picture'),
        icon: const Icon(Icons.photo_camera),
      ),
    );
  }
}
