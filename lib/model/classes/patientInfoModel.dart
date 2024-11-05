class Patient {
  String name = "";
  String age = "";
  String bloodType = "";
  String id = "";

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'bloodType': bloodType,
      'id': id,
    };
  }

  fromMap(Map<String, dynamic> map) {
    name = map['name'] ?? "";
    age = map['age'] ?? "";
    id = map['id'] ?? "";
    bloodType = map['bloodType'] ?? "";
  }
}
