class AiResponse {
  final int? created;
  final Iterable<AiResponseData>? data;
  final AiResponseError? error;

  const AiResponse({
    this.created,
    this.data,
    this.error,
  });

  factory AiResponse.from(Object? root) {
    final source = root is Map ? root : {};
    final created = source["created"];
    final data = source["data"];
    final error = source["error"];
    final result = data is List ? data.map(AiResponseData.from) : null;
    return AiResponse(
      created: created is int ? created : null,
      data: result,
      error: error is Map ? AiResponseError.from(error) : null,
    );
  }

  factory AiResponse.failure(String? error, [int? statusCode]) {
    return AiResponse(
      error: AiResponseError(
        code: "$statusCode",
        message: error,
      ),
    );
  }

  Map<String, dynamic> get source {
    return {
      "created": created,
      "data": data?.map((e) => e.source),
      "error": error?.source,
    };
  }

  @override
  String toString() {
    return "AiResponse(${source.toString().replaceAll("{", "").replaceAll(",}", "").replaceAll("}", "")})";
  }
}

class AiResponseData {
  final String? revisedPrompt;
  final String? url;
  final dynamic bytes;

  const AiResponseData({
    this.revisedPrompt,
    this.url,
    this.bytes,
  });

  factory AiResponseData.from(Object? source) {
    final data = source is Map ? source : {};
    final revisedPrompt = data["revised_prompt"];
    final url = data["url"];
    final bytes = data["b64_json"] ?? data["data"] ?? data["bytes"];
    return AiResponseData(
      revisedPrompt: revisedPrompt is String ? revisedPrompt : null,
      url: url is String ? url : null,
      bytes: bytes,
    );
  }

  Map<String, dynamic> get source {
    return {
      "revised_prompt": revisedPrompt,
      "url": url,
      "bytes": bytes,
    };
  }

  @override
  String toString() {
    return "$AiResponseData(${source.toString().replaceAll("{", "").replaceAll(",}", "").replaceAll("}", "")})";
  }
}

class AiResponseError {
  final String? code;
  final String? message;
  final String? param;
  final String? type;

  const AiResponseError({
    this.code,
    this.message,
    this.param,
    this.type,
  });

  factory AiResponseError.from(Object? source) {
    final data = source is Map ? source : {};
    final code = data["code"];
    final message = data["message"];
    final param = data["param"];
    final type = data["type"];
    return AiResponseError(
      code: code is String ? code : null,
      message: message is String ? message : null,
      param: param is String ? param : null,
      type: type is String ? type : null,
    );
  }

  Map<String, dynamic> get source {
    return {
      "code": code,
      "message": message,
      "param": param,
      "type": type,
    };
  }

  @override
  String toString() {
    return "$AiResponseError(${source.toString().replaceAll("{", "").replaceAll(",}", "").replaceAll("}", "")})";
  }
}
