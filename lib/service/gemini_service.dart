import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  

  static final String? _apiKey = dotenv.env['GEMINI_API_KEY'];

  static String get _apiUrl =>
      "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$_apiKey";


      static Future<String> getFunnyAnswer(String question) async {
        final body = {
          'contents' : [
            {
              "parts": [
                {
                  "text" : "Give sarcastic and hilariously bad advice to this question:$question"
                }
              ]
            }
          ]
        };

        final response = await http.post(Uri.parse(_apiUrl),
        headers: {
          'content-type' : 'application/json'
        },
        body: json.encode(body),

        );

        if (response.statusCode == 200){
          final data = json.decode(response.body);
          return data['candidates'][0]['content']['parts'][0]['text'];
        } 

        else {
          throw Exception(
            'failed to fetch from Gemini API'
          );
        }

      }
}
