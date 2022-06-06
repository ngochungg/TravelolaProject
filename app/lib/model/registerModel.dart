import 'dart:convert';

class RegisterModel {
  String firstname;
  String lastname;
  String username;
  String password;
  String email;
  String imageFile;
  RegisterModel(this.firstname, this.lastname, this.username, this.password,
      this.email, this.imageFile);
}
