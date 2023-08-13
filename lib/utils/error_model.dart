class ErrorModel {
  String? message;
  final dynamic data;

  ErrorModel({this.message, this.data});

  //Copy with function
  ErrorModel copyWith({String? message, dynamic data}) {
    return ErrorModel(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
