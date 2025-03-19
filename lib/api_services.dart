import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://10.0.2.2:5000";

  Future<List<dynamic>> moderateText(String text) async {
    final url = Uri.parse("$baseUrl/moderate-text");

    final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode({"text": text}));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to analyze text: ${response.body}");
    }
  }

  Future<String> extractTextFromImage(File imageFile) async {
    final String googleVisionApiKey = "AIzaSyAWcwCmXhGjoTmQeXUFdDluhjk91tAMi9Q";
    final url = Uri.parse("https://vision.googleapis.com/v1/images:annotate?key=$googleVisionApiKey");

    // Convert image to base64
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    final body = jsonEncode({
      "requests": [
        {
          "image": {"content": base64Image},
          "features": [
            {"type": "TEXT_DETECTION"},
          ],
        },
      ],
    });

    final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse["responses"][0].containsKey("textAnnotations")) {
        return jsonResponse["responses"][0]["textAnnotations"][0]["description"];
      } else {
        return "No text found in image";
      }
    } else {
      throw Exception("Failed to extract text from image: ${response.body}");
    }
  }
}
