import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api_services.dart';

class ImageModerationScreen extends StatefulWidget {
  @override
  _ImageModerationScreenState createState() => _ImageModerationScreenState();
}

class _ImageModerationScreenState extends State<ImageModerationScreen> {
  File? _image;
  String _extractedText = "No text extracted yet";
  String _moderationResult = "Upload an image to analyze";

  final ApiService _apiService = ApiService();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      _extractTextFromImage(File(pickedFile.path));
    }
  }

  Future<void> _extractTextFromImage(File imageFile) async {
    String extractedText = await _apiService.extractTextFromImage(imageFile);
    setState(() {
      _extractedText = extractedText;
    });

    _analyzeText(extractedText);
  }

  Future<void> _analyzeText(String text) async {
    try {
      final response = await _apiService.moderateText(text);
      setState(() {
        _moderationResult = response.toString();
      });
    } catch (e) {
      setState(() {
        _moderationResult = "Error: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Text Moderation")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _image == null ? Text("No image selected") : Image.file(_image!, height: 200),

            SizedBox(height: 10),
            ElevatedButton(onPressed: _pickImage, child: Text("Pick Image")),

            SizedBox(height: 10),
            Text("Extracted Text: $_extractedText", textAlign: TextAlign.center),

            SizedBox(height: 10),
            Text("Moderation Result: $_moderationResult", textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
