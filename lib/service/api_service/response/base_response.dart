class BaseResponse<T> {
  BaseResponse({this.code, this.data, this.status, this.message, this.error});

  final int? code;
  final List<T>? data; // data là một danh sách các đối tượng T
  final String? status;
  final String? message;
  final String? error;

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    final dynamic rawData = json["data"];
    List<T> responseData = [];

    if (rawData is List) {
      responseData = List<T>.from(rawData.map((x) => fromJsonT(x)));
    } else if (rawData is Map<String, dynamic> && rawData.isNotEmpty) {
      responseData = [fromJsonT(rawData)];
    }

    return BaseResponse<T>(
      code: json["code"],
      data: responseData,
      status: json["status"],
      message: json["message"],
      error:
          json["error"] ?? json["title"] ?? json["detail"] ?? json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data != null ? data!.map((e) => e).toList() : [],
    "status": status,
    "message": message,
    "error": error,
  };
}
