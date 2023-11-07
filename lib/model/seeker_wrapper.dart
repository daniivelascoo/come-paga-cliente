class SeekerWrapper<T> {
  String? value;
  Future<List<T>?> Function(Map<String, dynamic>?, String?) operation;
  Future<List<T>>? result;
  Map<String, dynamic>? filter;
  String? endpoint;

  SeekerWrapper(
      {this.value,
      required this.operation,
      this.result,
      this.endpoint,
      this.filter});
}
