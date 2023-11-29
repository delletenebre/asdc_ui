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

  factory Paginator.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      Paginator<T>(
        total: json['total'] as int ?? 0,
        perPage: json['per_page'] as int ?? 10,
        currentPage: json['current_page'] as int ?? 1,
        lastPage: json['last_page'] as int ?? 1,
        from: json['from'] as int ?? 0,
        to: json['to'] as int ?? 0,
        data: (json['data'] as List<dynamic>?)?.map<T>(fromJsonT).toList() ??
            const [],
      );

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      <String, dynamic>{
        'total': total,
        'per_page': perPage,
        'current_page': currentPage,
        'last_page': lastPage,
        'from': from,
        'to': to,
        'data': data.map(toJsonT).toList(),
      };

  bool get isEmpty => data.isEmpty;
  bool get isNotEmpty => !isEmpty;
  int get count => data.length;

  bool get hasNextPage => currentPage < lastPage;
  bool get hasPreviousPage => currentPage > 1;
  bool get firstPageEnabled => hasPreviousPage && total > 1;
  bool get lastPageEnabled => currentPage != lastPage;
}
