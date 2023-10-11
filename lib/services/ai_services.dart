import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import '../models/ai_model.dart';
import '../models/ai_response.dart';
import 'apiKey/api_key.dart';

class AIService extends GetConnect implements GetxService {
  final String endPoint = "";

  static final Uri chatUri = Uri.parse('https://api.openai.com/v1/completions');

  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${apiKey}',
  };

  Future generatedText(String text) async {
    var response = await http.post(
      headers: headers,
      chatUri,
      // body: <String, dynamic>{},
      body: jsonEncode({
        "model": "text-davinci-003",
        "prompt": text,
        "temperature": 1,
        "max_tokens": 4000,
        "top_p": 1,
        "frequency_penalty": 0.0,
        "presence_penalty": 0.0,
      }),
    );

    log(response.body);
    return null;
  }

  Future<String?> generatedRequest(String prompt) async {
    try {
      ChatRequest request = ChatRequest(
        model: "text-davinci-003",
        maxTokens: 150,
        messages: [Message(role: "system", content: prompt)],
      );
      if (prompt.isEmpty) {
        return null;
      }
      http.Response response = await http.post(
        chatUri,
        headers: headers,
        body: request.toJson(),
      );
      ChatResponse chatResponse = ChatResponse.fromResponse(response);
      print("${chatResponse.choices?[0].message?.content} is the request");
      return chatResponse.choices?[0].message?.content;
    } catch (e) {
      print("error $e");
    }
    return null;
  }
}
