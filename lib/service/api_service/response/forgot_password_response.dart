class ForgotPasswordResponse {
  ForgotPasswordResponse({required this.json});
  final Map<String,dynamic> json;

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json){
    return ForgotPasswordResponse(
        json: json
    );
  }

  Map<String, dynamic> toJson() => {
  };

  @override
  String toString(){
    return "";
  }
}
