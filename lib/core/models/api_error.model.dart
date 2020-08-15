class ApiError {
  ApiError({
    this.code,
    this.message,
  });

  final int code;
  final String message;

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "message": message == null ? null : message,
      };
}
