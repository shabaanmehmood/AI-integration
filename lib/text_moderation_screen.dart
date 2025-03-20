import 'package:flutter/material.dart';
import 'api_services.dart';

class ParagraphSpeechDetectionScreen extends StatefulWidget {
  const ParagraphSpeechDetectionScreen({super.key});

  @override
  _ParagraphSpeechDetectionScreenState createState() => _ParagraphSpeechDetectionScreenState();
}

class _ParagraphSpeechDetectionScreenState extends State<ParagraphSpeechDetectionScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  String _result = "Enter a paragraph to analyze";

  void _analyzeText() async {
    String text = _controller.text.trim();
    if (text.isEmpty) return;

    try {
      final response = await _apiService.moderateText(text);
      setState(() {
        _result = response.toString(); // Display the result
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
      appBar: AppBar(title: Text("Paragraph Speech Detection")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: null, // Allow multiple lines for paragraph input
              decoration: InputDecoration(labelText: "Enter paragraph"),
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _analyzeText, child: Text("Analyze")),
            SizedBox(height: 20),
            Text("Result: $_result"), // Display result here
          ],
        ),
      ),
    );
  }
}
