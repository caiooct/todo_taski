class PaginatedResult<T> {
  final int totalCount;
  final T data;

  const PaginatedResult({
    required this.totalCount,
    required this.data,
  });


  bool get isNotEmpty => totalCount > 0;
}
