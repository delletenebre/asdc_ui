export 'cursor_paginator.dart';
export 'paginator_state.dart';

class Paginator<T> {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final int from;
  final int to;
  final List<T> data;

  const Paginator({
    this.total = 0,
    this.perPage = 10,
    this.currentPage = 1,
    this.lastPage = 1,
    this.from = 0,
    this.to = 0,
    this.data = const [],
  });

  Paginator fromJson(Map<String, dynamic> json) => Paginator(
        total: int.tryParse(json['total']) ?? 0,
        perPage: int.tryParse(json['per_page']) ?? 10,
        currentPage: int.tryParse(json['current_page']) ?? 1,
        lastPage: int.tryParse(json['last_page']) ?? 1,
        from: int.tryParse(json['from']) ?? 0,
        to: int.tryParse(json['to']) ?? 0,
        data: json['data'] as List<T>? ?? const [],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'total': total,
        'per_page': perPage,
        'current_page': currentPage,
        'last_page': lastPage,
        'from': from,
        'to': to,
        'data': data,
      };

  bool get isEmpty => data.isEmpty;
  bool get isNotEmpty => !isEmpty;
  int get count => data.length;

  bool get hasNextPage => currentPage < lastPage;
  bool get hasPreviousPage => currentPage > 1;
  bool get firstPageEnabled => hasPreviousPage && total > 1;
  bool get lastPageEnabled => currentPage != lastPage;
}
