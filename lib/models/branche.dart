class Branche {
  final String name;

  Branche(this.name);

  Map<String, dynamic> toJson() => {'name': name};

  Branche.fromJson(Map json) : name = json['name'];
}
