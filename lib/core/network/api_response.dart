/// Default network response wrapper.
class ApiResponse<T> {
  final int? statusCode;
  final String? message;
  final T? data;

  const ApiResponse({this.statusCode, this.message, this.data});

  bool get isSuccess => statusCode != null && statusCode! >= 200 && statusCode! < 300;
}
