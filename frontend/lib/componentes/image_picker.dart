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
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                TextFormField(
                  controller: widget.controller,
                  readOnly: true,
                  onTap: _pickImage,
                  decoration: InputDecoration(
                    labelText: widget.labelText,
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: const Color.fromRGBO(150, 150, 150, 0.5),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(150, 150, 150, 1),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(50, 190, 100, 1),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white70,
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
                      color: Color.fromRGBO(79, 79, 79, 0.8),
                      size: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}