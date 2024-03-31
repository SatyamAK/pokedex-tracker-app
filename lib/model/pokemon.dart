class Pokemon {
  late String id;
  late String name;
  late List<String> types;

  Pokemon.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    types = map['types'].cast<String>();
  }
}