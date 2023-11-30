enum AsdcListFilterType {
  text,
  date,
  select,
  multiselect,
}

class AsdcListFilter {
  final String name;
  final String label;
  final AsdcListFilterType type;
  final dynamic value;
  final dynamic formValue;
  final Future<Map<String, String>> Function()? asyncOptions;

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
    Future<Map<String, String>> Function()? asyncOptions,
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
