import 'dart:convert';

enum AiResponseFormat {
  url("url"),
  b64Json("b64_json");

  final String value;

  const AiResponseFormat(this.value);
}

enum AiImageSize {
  x256x256("256x256"),
  x512x512("512x512"),
  x1024x1024("1024x1024"),
  x1024x1792("1024x1792"),
  x1792x1024("1792x1024");

  final String value;

  const AiImageSize(this.value);

  bool get isDallE2 => this == x256x256 || this == x512x512;

  bool get isDallE3 => this == x1024x1792 || this == x1792x1024;

  String get dallE2 => isDallE2 ? value : x1024x1024.value;

  String get dallE3 => isDallE3 ? value : x1024x1024.value;
}

enum AiImageStyle {
  vivid("vivid"),
  natural("natural");

  final String value;

  const AiImageStyle(this.value);
}

enum AiImageQuality {
  standard("standard"),
  hd("hd");

  final String value;

  const AiImageQuality(this.value);
}

class AiRequest<T extends Object?> {
  final String prompt;
  final int n;
  final AiResponseFormat? responseFormat;
  final AiImageSize size;
  final AiImageQuality? quality;
  final AiImageStyle? style;
  final String? user;

  const AiRequest(
    this.prompt, {
    this.n = 1,
    this.quality,
    this.responseFormat,
    this.size = AiImageSize.x1024x1024,
    this.style,
    this.user,
  }) : assert(prompt.length <= 4000);

  Map<String, dynamic> get data {
    final isDallE3 = (n == 1) && (size.isDallE3 || prompt.length > 1000);
    return {
      "prompt": prompt,
      "n": n,
      "model": isDallE3 ? "dall-e-3" : "dall-e-2",
      "size": isDallE3 ? size.dallE3 : size.dallE2,
      if (quality != null) "quality": quality?.value,
      if (responseFormat != null)"response_format": responseFormat?.value,
      if (style != null) "style": style?.value,
    };
  }

  String get body => jsonEncode(data);
}
