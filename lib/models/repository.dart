class Repository {
  final String name;
  final String description;
  final String branchesUrl;
  final String languagesUrl;

  Repository(this.name, this.description, this.branchesUrl, this.languagesUrl);

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'branchesUrl': branchesUrl,
        'languagesUrl': languagesUrl
      };

  Repository.fromJson(Map json)
      : name = json['name'],
        description = json['description'] ?? "Sem descrição",
        branchesUrl = json['branches_url'],
        languagesUrl = json['languages_url'];
}
