class Language {
  final String name;

  Language(this.name);

  static List<Language> fromJson(Map<String, dynamic> json) {
    List<Language> languages = [];
    for (var key in json.keys) {
      languages.add(Language(key));
    }
    
    return languages;
  }
}
