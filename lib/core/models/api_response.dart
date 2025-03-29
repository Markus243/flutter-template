class ApiResponse<T> {
  final String version;
  final int statusCode;
  final bool isError;
  final String message;
  final ApiError? responseException;
  final T? result;

  ApiResponse({
    required this.version,
    required this.statusCode,
    required this.isError,
    required this.message,
    this.responseException,
    this.result,
  });

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => {
        'version': version,
        'statusCode': statusCode,
        'isError': isError,
        'message': message,
        'responseException': responseException?.toJson(),
        'result': result != null ? toJsonT(result as T) : null,
      };

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      ApiResponse<T>(
        version: json['version'] as String,
        statusCode: json['statusCode'] as int,
        isError: json['isError'] as bool,
        message: json['message'] as String,
        responseException: json['responseException'] != null
            ? ApiError.fromJson(
                json['responseException'] as Map<String, dynamic>)
            : null,
        result: json['result'] != null ? fromJsonT(json['result']) : null,
      );
}

class ApiError {
  final String exceptionMessage;
  final String? details;
  final String? referenceErrorCode;
  final String? validationErrors;

  ApiError({
    required this.exceptionMessage,
    this.details,
    this.referenceErrorCode,
    this.validationErrors,
  });

  Map<String, dynamic> toJson() => {
        'exceptionMessage': exceptionMessage,
        'details': details,
        'referenceErrorCode': referenceErrorCode,
        'validationErrors': validationErrors,
      };

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
        exceptionMessage: json['exceptionMessage'] as String,
        details: json['details'] as String?,
        referenceErrorCode: json['referenceErrorCode'] as String?,
        validationErrors: json['validationErrors'] as String?,
      );
}
