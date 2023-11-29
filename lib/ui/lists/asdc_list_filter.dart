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
}
