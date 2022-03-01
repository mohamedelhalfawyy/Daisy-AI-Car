class Language {
  final int id;
  final String name;
  final String flag;
  // ignore: non_constant_identifier_names
  final String LanguageCode;
  Language(this.id, this.name, this.flag, this.LanguageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, "English", "🇺🇸", "en"),
      // Language(2, "German", "🇩🇪", "de"),
      // Language(3, "French", "🇫🇷", "fr"),
      // Language(4, "Italian", "🇮🇹", "it"),
      Language(5, "Arabic", "🇪🇬", "ar"),
    ];
  }
}