class CursorPaginator<T> {
  final int perPage;
  final String nextCursor;
  final String prevCursor;
  final List<T> data;

  const CursorPaginator({
    this.perPage = 10,
    this.nextCursor = '',
    this.prevCursor = '',
    this.data = const [],
  });

  CursorPaginator fromJson(Map<String, dynamic> json) => CursorPaginator(
        perPage: int.tryParse(json['per_page']) ?? 10,
        nextCursor: json['next_cursor'] ?? '',
        prevCursor: json['prev_cursor'] ?? '',
        data: json['data'] as List<T>? ?? const [],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'per_page': perPage,
        'next_cursor': nextCursor,
        'prev_cursor': prevCursor,
        'data': data,
      };

  bool get isEmpty => data.isEmpty;
  bool get isNotEmpty => !isEmpty;
  int get count => data.length;

  bool get hasNextPage => nextCursor.isNotEmpty;
  bool get hasPreviousPage => prevCursor.isNotEmpty;
}
