class DataModel{

  int? id;
  String name;
  String dob;
  String age;
  String domain;
  String imagePath;

  DataModel({
    this.id,
    required this.name,
    required this.dob,
    required this.age,
    required this.domain,
    required this.imagePath
  });

  factory DataModel.fromMap(Map<String, dynamic>map) =>
      DataModel(id: map['id'], name: map["name"], dob: map["dob"], age: map["age"], domain: map["domain"], imagePath:map["imagePath"]);

  Map<String,dynamic> toMap()=> {
    "id": id,
    "name":name,
    "dob":dob,
    "age":age,
    "domain":domain,
    "imagePath":imagePath

  };




}