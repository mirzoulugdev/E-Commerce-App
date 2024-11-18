import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

enum AuthMode { Register, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final _passwordController = TextEditingController();
  var _loading = false;
  Map<String, String> _authData = {
    'email': '',
    "pasword": '',
  };
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _loading = true;
      });
      if (_authMode == AuthMode.Login) {
        //...login user
        await Provider.of<Auth>(context).login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        //.... register
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
      setState(() {
        _loading = false;
      });
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Register;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "/images/shopping.png",
                    fit: BoxFit.cover,
                    width: 250,
                    height: 250,
                    alignment: Alignment.topCenter,
                  ),
                ),
                SizedBox(height: 40),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Email manzil",
                  ),
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return "Iltimos, email manzil kiriting";
                    } else if (email.contains('@') == email.isEmpty) {
                      return "To'g'ri email kiriting";
                    }
                  },
                  onSaved: (email) {
                    _authData['email'] = email!;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Parol",
                  ),
                  controller: _passwordController,
                  obscureText: true,
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return "Iltimos, parolni kiriting";
                    } else if (password.length < 8) {
                      return 'Parol 8 ta belgidan kam bo\'lmasligi kerak';
                    }
                  },
                  onSaved: (password) {
                    _authData['password'] = password!;
                  },
                ),
                if (_authMode == AuthMode.Register)
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Parolni tasdiqlang ",
                        ),
                        validator: (confirmedPassword) {
                          if (_passwordController.text != confirmedPassword) {
                            return 'Parol mos emas!';
                          }
                        },
                        obscureText: true,
                      )
                    ],
                  ),
                SizedBox(
                  height: 50,
                ),
                _loading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          _submitForm();
                        },
                        child: Text(
                          _authMode == AuthMode.Login
                              ? "KIRISH"
                              : "Ro'yhatdan o'tish",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            backgroundColor: Colors.teal,
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            minimumSize: Size(
                              double.infinity,
                              50,
                            )),
                      ),
                const SizedBox(
                  height: 40,
                ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    _authMode == AuthMode.Login
                        ? "Ro'yxatdan o'tish"
                        : "Kirish",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
