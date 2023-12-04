class LaravelError {
  final String message;
  final Map<String, String> errors;

  const LaravelError({
    this.message = '',
    this.errors = const {},
  });

  factory LaravelError.fromJson(Map<String, dynamic> json) => LaravelError(
        message: json['message'] as String? ?? '',
        errors: json['errors'] as Map<String, String>? ?? {},
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'message': message,
        'errors': errors,
      };
}
