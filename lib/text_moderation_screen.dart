import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'api_services.dart';

class TextModerationScreen extends StatefulWidget {
  const TextModerationScreen({super.key});

  @override
  _TextModerationScreenState createState() => _TextModerationScreenState();
}

class _TextModerationScreenState extends State<TextModerationScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  String _result = "Enter text to analyze";

  void _analyzeText() async {
    String text = _controller.text.trim();
    if (text.isEmpty) return;

    try {
      final response = await _apiService.moderateText(text);
      setState(() {
        _result = response.toString();
      });
    } catch (e) {
      setState(() {
        _result = "Error: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Text Moderation")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _controller, decoration: InputDecoration(labelText: "Enter text")),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _analyzeText, child: Text("Analyze")),
            SizedBox(height: 20),
            Text("Result: $_result"),
          ],
        ),
      ),
    );
  }
}
