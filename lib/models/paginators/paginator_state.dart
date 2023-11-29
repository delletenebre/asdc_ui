class PaginatorState {
  final String cursor;
  final int page;
  final int perPage;
  final String sortBy;
  final String sortDirection;
  final Map<String, dynamic> filters;

  const PaginatorState({
    this.cursor = '',
    this.page = 1,
    this.perPage = 10,
    this.sortBy = 'created_at',
    this.sortDirection = 'desc',
    this.filters = const {},
  });

  PaginatorState fromJson(Map<String, dynamic> json) => PaginatorState(
        cursor: json['cursor'] ?? '',
        page: int.tryParse(json['page']) ?? 1,
        perPage: int.tryParse(json['per_page']) ?? 10,
        sortBy: json['sort_by'] ?? '',
        sortDirection: json['sort_direction'] ?? '',
        filters: json['filters'] as Map<String, dynamic>? ?? const {},
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'cursor': cursor,
        'page': page,
        'per_page': perPage,
        'sort_by': sortBy,
        'sort_direction': sortDirection,
        'filters': filters,
      };

  Map<String, dynamic> toFormData() {
    final data = toJson();
    data.remove('filters');
    data.addAll(filters);
    return data;
  }
}
