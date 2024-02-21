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

  factory CursorPaginator.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      CursorPaginator(
        perPage: int.tryParse(json['per_page'].toString()) ?? 10,
        nextCursor: json['next_cursor'] ?? '',
        prevCursor: json['prev_cursor'] ?? '',
        data: (json['data'] as List<dynamic>?)?.map(fromJsonT).toList() ??
            const [],
      );

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      <String, dynamic>{
        'per_page': perPage,
        'next_cursor': nextCursor,
        'prev_cursor': prevCursor,
        'data': data.map(toJsonT).toList(),
      };

  bool get isEmpty => data.isEmpty;
  bool get isNotEmpty => !isEmpty;
  int get count => data.length;

  bool get hasNextPage => nextCursor.isNotEmpty;
  bool get hasPreviousPage => prevCursor.isNotEmpty;
}
