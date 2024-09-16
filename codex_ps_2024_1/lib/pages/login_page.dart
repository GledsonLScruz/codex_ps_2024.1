import 'package:codex_ps_2024_1/pages/home_page.dart';
import 'package:codex_ps_2024_1/pages/sing_up_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Login Page"),
      ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          child: Text("Login")),
      ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SingUpPage()),
            );
          },
          child: Text("Cadastro"))
    ]);
  }
}