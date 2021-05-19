class TranslatedString {
  String text;
  String language;

  TranslatedString({
    this.text,
    this.language,
  });

  factory TranslatedString.fromJson(Map<String, dynamic> json) =>
      TranslatedString(
        text: json['text'].toString(),
        language: json['language'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'language': language,
      };
}
