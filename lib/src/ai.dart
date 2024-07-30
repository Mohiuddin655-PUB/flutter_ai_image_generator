import 'dart:convert';

import 'package:http/http.dart' as http;

import 'request.dart';
import 'response.dart';

class AiGenerator {
  /// OPENAI API KEY
  final String key;

  const AiGenerator({
    /// OPENAI API KEY
    required this.key,
  });

  static AiGenerator? _i;

  static AiGenerator get i {
    if (_i != null) {
      return _i!;
    } else {
      throw UnimplementedError("AiGenerator not initialized yet!");
    }
  }

  static void init({
    /// OPENAI API KEY
    required String key,
  }) {
    _i = AiGenerator(key: key);
  }

  Future<AiResponse> generate<T>(
    String prompt, {
    AiImageSize size = AiImageSize.x1024x1024,
    int n = 1,
    AiImageQuality? quality,
    AiResponseFormat? responseFormat,
    AiImageStyle? style,
    String? user,
  }) {
    final request = AiRequest(
      prompt,
      n: n,
      quality: quality,
      responseFormat: responseFormat,
      style: style,
      size: size,
      user: user,
    );
    return http
        .post(
          Uri.parse("https://api.openai.com/v1/images/generations"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $key",
          },
          body: request.body,
        )
        .onError((_, __) => http.Response("$_", 500))
        .then((value) {
      if (value.statusCode == 200) {
        final raw = jsonDecode(value.body);
        if (raw is Map<String, dynamic>) {
          return AiResponse.from(raw);
        }
      }
      return AiResponse.failure(
        value.reasonPhrase ?? value.body,
        value.statusCode,
      );
    });
  }
}
