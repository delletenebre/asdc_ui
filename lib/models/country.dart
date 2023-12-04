class Country {
  final String id;
  final String nameEn;
  final String officialEn;
  final String nameRu;
  final String officialRu;
  final String flag;

  Country({
    this.id = '',
    this.nameEn = '',
    this.officialEn = '',
    this.nameRu = '',
    this.officialRu = '',
    this.flag = '',
  });

  factory Country.fromJson(Map<String, Object?> json) => Country(
        id: json['id'] as String? ?? '',
        nameEn: json['name_en'] as String? ?? '',
        officialEn: json['official_en'] as String? ?? '',
        nameRu: json['name_ru'] as String? ?? '',
        officialRu: json['official_ru'] as String? ?? '',
        flag: json['flag'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name_en': nameEn,
        'official_en': officialEn,
        'name_ru': nameRu,
        'official_ru': officialRu,
        'flag': flag,
      };
}
