class UserModel {
  String id;
  String email;
  String displayName;
  String photoURL;
  String? idToken;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.idToken,
  });
}
