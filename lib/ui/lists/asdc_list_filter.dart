enum AsdcListFilterType {
  text,
  date,
  select,
  multiselect,
  country,
}

class AsdcListFilter<T> {
  final String name;
  final String label;
  final AsdcListFilterType type;
  final dynamic value;
  final dynamic formValue;

  /// Map<String, T>
  /// Future<dynamic> Function()
  final Future<dynamic> Function()? asyncOptions;

  const AsdcListFilter({
    required this.name,
    required this.label,
    this.type = AsdcListFilterType.text,
    this.value,
    this.formValue,
    this.asyncOptions,
  });

  AsdcListFilter copyWith({
    String? name,
    String? label,
    AsdcListFilterType? type,
    dynamic value,
    dynamic formValue,

    /// Map<String, T>
    Future<dynamic> Function()? asyncOptions,
  }) =>
      AsdcListFilter(
        name: name ?? this.name,
        label: label ?? this.label,
        type: type ?? this.type,
        value: value ?? this.value,
        formValue: formValue ?? this.formValue,
        asyncOptions: asyncOptions ?? this.asyncOptions,
      );
}
