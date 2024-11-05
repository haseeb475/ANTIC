class UserProfile {
  String name = "";
  String role = "";
  String email = "";
  String imageUrl = "";
  String uid = "";
  num status = 0;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'email': email,
      'imageurl': imageUrl,
      'id': uid,
      'status': status,
    };
  }
}
