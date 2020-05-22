class HttpException implements Exception{
  final error;
  HttpException(this.error);
  @override
  String toString() {
    return error;
  }
}