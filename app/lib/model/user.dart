class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  late final String imageUrl;
  final bool active;
  final String accessToken;

  User(this.id, this.username, this.email, this.firstName, this.lastName,
      this.phone, this.imageUrl, this.active, this.accessToken);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        email = json['email'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        phone = json['phone'],
        imageUrl = json['imageUrl'],
        active = json['active'],
        accessToken = json['accessToken'];
  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'imageUrl': imageUrl,
        'active': active,
        'accessToken': accessToken,
      };
}
