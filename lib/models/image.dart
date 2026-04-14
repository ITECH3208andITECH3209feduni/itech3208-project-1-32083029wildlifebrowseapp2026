import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aws_client/s3_2006_03_01.dart';

class S3ImageManager {
  final String region;
  final String bucketName;
  
  S3ImageManager({required this.region, required this.bucketName});
  
  // Current putS3Image implementation does not handle authentication - bucket must be accessible by a anonymous user 
  Future<void> putS3Image(String img) async {
    final api = S3(region: region);
    try {
      await api.createBucket(bucket: bucketName);
      await api.putObject(
        bucket: bucketName,
        key: img,
        body: File(img).readAsBytesSync()
      );
    } finally {
      api.close();
    }
  }
  
  // Current getS3Image implementation does not handle authentication - bucket must be accessible by a anonymous user 
  Future<void> getS3Image(String key) async {
    final api = S3(region: region);
    try {
      await api.getObject(
        bucket: bucketName,
        key: key,
      );
    } finally {
      api.close();
    }
  }
}

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();
  
  static Future<File?> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    return pickedFile != null ? File(pickedFile.path) : null;
  }
  
  static Future<Map<String, dynamic>?> pickImageWithDetails(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    
    if (pickedFile == null) return null;
    
    final File file = File(pickedFile.path);
    
    return {
      'file': file,
      'filename': pickedFile.name,
      'path': pickedFile.path,
    };
  }
  
}

class ImagePickerWidget extends StatefulWidget {
  final Function(File?) onImageSelected;
  final S3ImageManager? s3Manager;
  
  const ImagePickerWidget({
    super.key,
    required this.onImageSelected,
    this.s3Manager,
  });
  
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _galleryFile;
  final ImagePicker _picker = ImagePicker();
  
  void _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  _getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  Future<void> _getImage(ImageSource source) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final XFile? pickedFile = await _picker.pickImage(source: source);
    
    setState(() async {
      if (pickedFile != null) {
        _galleryFile = File(pickedFile.path);
        
        // Save to shared preferences
        await prefs.setString('profilePic', pickedFile.name);
        
        // Notify parent widget
        widget.onImageSelected(_galleryFile);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nothing is selected'))
        );
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showPicker,
      child: Container(
        child: _galleryFile != null 
            ? Image.file(_galleryFile!)
            : Icon(Icons.add_a_photo, size: 50),
      ),
    );
  }
}