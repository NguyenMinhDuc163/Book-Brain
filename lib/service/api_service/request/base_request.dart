import 'dart:convert';

BaseRequest baseRequestFromJson(String str) =>
    BaseRequest.fromJson(json.decode(str));

String baseRequestToJson(BaseRequest data) =>
    json.encode(data.toJson());

class BaseRequest {
  BaseRequest();

  factory BaseRequest.fromJson(Map<String, dynamic> json) =>
      BaseRequest();

  Map<String, dynamic> toJson() => {};
}
