import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  static const apiKey = 'AIzaSyDyuZslfeB9M5RB1pKOosvaYHIrdWdchcI';

  Future<void> _authenticate(String email, String password) async {}

  Future<void> signup(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey");

    final response = await http.post(
      url,
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );

    print(jsonDecode(response.body));
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey");

    final response = await http.post(
      url,
      body: jsonEncode(
        {
          'email': email,
          'passwors': password,
          'returnSecureToken': true,
        },
      ),
    );
  }
}
