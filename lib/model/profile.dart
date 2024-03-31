class Profile {
  int? id;
  late String name;
  late String generation;

  Profile({required this.name, required this.generation});

  Profile.fromMap(Map<String, dynamic> map) {
    id = map['ID'];
    name = map['NAME'];
    generation = map['GENERATION'];
  }

  toMap() {
    var map =  <String, dynamic>{
      'NAME': name,
      'GENERATION': generation
    };
    
    return map;
  }
}