import 'dart:convert';

SampleRequest sampleRequestFromJson(String str) =>
    SampleRequest.fromJson(json.decode(str));

String sampleRequestToJson(SampleRequest data) =>
    json.encode(data.toJson());

class SampleRequest {
  SampleRequest({
    required this.exampleField1,
    required this.exampleField2,
  });

  final dynamic exampleField1;
  final dynamic exampleField2;

  factory SampleRequest.fromJson(Map<String, dynamic> json) => SampleRequest(
    exampleField1: json["example_field_1"],
    exampleField2: json["example_field_2"],
  );

  Map<String, dynamic> toJson() => {
    "example_field_1": exampleField1,
    "example_field_2": exampleField2,
  };
}
