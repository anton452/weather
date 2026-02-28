import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = AuthService();

  void login() async {
    bool success = await auth.login(
        loginController.text,
        passwordController.text);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Неверный логин или пароль")));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Вход")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: loginController, decoration: const InputDecoration(labelText: "Логин")),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Пароль"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("Войти")),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()));
              },
              child: const Text("Регистрация"),
            )
          ],
        ),
      ),
    );
  }
}