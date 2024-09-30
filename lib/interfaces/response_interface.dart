class Response<T> {
  T? data;
  String? errorMessage;

  Response({this.data, this.errorMessage});

  bool get isSuccess => errorMessage == null;
}
