import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImagePickerField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final Function(XFile)? onImagePicked;

  const ImagePickerField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.onImagePicked,
  }) : super(key: key);

  @override
  _ImagePickerFieldState createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  final picker = ImagePicker();
  XFile? _pickedImage;

  Future<void> _pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final fileName = pickedImage.path.split('/').last;
      widget.controller.text = fileName;

      setState(() {
        _pickedImage = pickedImage;
      });

      final savedImagePath = await _saveImage(pickedImage);

      if (widget.onImagePicked != null) {
        widget.onImagePicked!(pickedImage);
      }
    }
  }

  Future<String> _saveImage(XFile image) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = image.path.split('/').last;
      final savedImage = File('${appDir.path}/$fileName');
      await savedImage.writeAsBytes(await image.readAsBytes());
      return savedImage.path;
    } catch (error) {
      print('Erro ao guardar a imagem localmente: $error');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.labelText,
              style: const TextStyle(color: Color.fromRGBO(79, 79, 79, 0.8)),
            ),
          ),
          Stack(
            children: [
              TextField(
                controller: widget.controller,
                readOnly: true,
                onTap: _pickImage,
                decoration: InputDecoration(
                  labelText: '',
                  filled: true,
                  fillColor: const Color.fromRGBO(0, 128, 87, 0.4),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: const TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                  fontSize: 16,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                child: IconButton(
                  onPressed: _pickImage,
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                    size: 24.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
