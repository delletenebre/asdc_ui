import 'package:flutter/material.dart';

import '../../../models/country.dart';
import '../asdc_forms.dart';

class AsdcCountryField extends StatelessWidget {
  final String name;
  final Future<List<Country>> asyncCountries;
  final List<String> pinnedIds;
  final String? labelText;
  final bool enabled;
  final void Function(String?)? onChanged;
  final bool showFlag;

  const AsdcCountryField({
    super.key,
    required this.name,
    required this.asyncCountries,
    this.pinnedIds = const [],
    this.labelText,
    this.enabled = true,
    this.onChanged,
    this.showFlag = false,
  });

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    return KrsSelectField<String, Country>(
      name: name,
      labelText: labelText,
      enabled: enabled,
      selectedOptionToString: (country) => showFlag
          ? '${country.flag}\t${country.officialRu}'
          : country.officialRu,
      pinnedIds: pinnedIds,
      optionBuilder: (country) => Row(
        children: [
          SizedBox(
            width: 24.0,
            child: Text(country.flag),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(country.nameRu),
                Text(
                  country.officialRu,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      filterEnabled: true,
      filter: (searchQuery, options) {
        return Map.fromEntries(options.entries.where((item) {
          return item.value.nameEn.toLowerCase().contains(searchQuery) ||
              item.value.officialEn.toLowerCase().contains(searchQuery) ||
              item.value.nameRu.toLowerCase().contains(searchQuery) ||
              item.value.officialRu.toLowerCase().contains(searchQuery);
        }));
      },
      asyncOptions: () async {
        final data = await asyncCountries;
        return {for (final item in data) item.id: item};
      },
      onChanged: onChanged,
    );
  }
}
