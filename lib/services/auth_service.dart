import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> register(String login, String password) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(login)) {
      return false;
    }

    final hashed = hashPassword(password);
    await prefs.setString(login, hashed);
    return true;
  }

  Future<bool> login(String login, String password) async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(login)) {
      return false;
    }

    final savedHash = prefs.getString(login);
    final inputHash = hashPassword(password);

    return savedHash == inputHash;
  }
}