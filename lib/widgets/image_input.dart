import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as systemPath;

class ImageInput extends StatefulWidget {
  static const String CAMERA = 'CAMERA';
  static const String GALLARY = 'GALLARY';
  Function selectImage;
  ImageInput(this.selectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;
  final picker = ImagePicker();

  Future _pickImage(String methode) async {
    var pickedImage;
    if (methode == ImageInput.CAMERA) {
      pickedImage = await picker.getImage(source: ImageSource.camera);
    } else {
      if (methode == ImageInput.GALLARY) {
        pickedImage = await picker.getImage(source: ImageSource.gallery);
      }
    }
    setState(() {
      if (pickedImage != null) _imageFile = File(pickedImage.path);
    });
    if (_imageFile == null) return;
    final appDir = await systemPath.getApplicationDocumentsDirectory();
    final fileName = path.basename(_imageFile.path);
    final savedImage = await _imageFile.copy('${appDir.path}/$fileName');
    widget.selectImage(savedImage);
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: [
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Photo Library'),
                    onTap: () {
                      _pickImage(ImageInput.GALLARY);
                      Navigator.of(ctx).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('Camera'),
                    onTap: () {
                      _pickImage(ImageInput.CAMERA);
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black38),
            ),
            height: 300,
            width: 200,
            // alignment: Alignment.center, // will give error, never use it with FittedBox()
            child: _imageFile == null
                ? Center(
                    child: Text(
                      'No Image Selected',
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                : FittedBox(fit: BoxFit.cover, child: Image.file(_imageFile)),
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton(
            onPressed: () {
              _showPicker(context);
            },
            child: Text(
              'Pick a picture',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.orange,
          )
        ],
      ),
    );
  }
}
