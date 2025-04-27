import 'package:book_brain/service/api_service/response/base_response.dart';

class CreateFavoritesResponse extends BaseResponse{
  CreateFavoritesResponse({
    required this.message,
  });

  final String? message;

  factory CreateFavoritesResponse.fromJson(Map<String, dynamic> json){
    return CreateFavoritesResponse(
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
  };

  @override
  String toString(){
    return "$message, ";
  }
}
