import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:memes_app/helpers/constants.dart';
import 'package:memes_app/models/meme.dart';
import 'package:memes_app/models/response.dart';

class ApiHelper {

  static Future<Response> getMemes() async {
    var url = Uri.parse(Constants.apiUrl);
    var response = await http.get(
      url,
      headers: {
        'content-Type': 'application/json',
        'accept': 'application/json'
      }
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Meme> list = [];
    Map<String, dynamic> decodedJson = jsonDecode(body);
    if (decodedJson.isNotEmpty) {
      decodedJson.forEach((String key, dynamic value) {
        if (key == "data") {
          for (var meme in (value as List)) {
            list.add(Meme.fromJson(meme));
          }
        }
      });
    }

    return Response(isSuccess: true, result: list);
  }
}