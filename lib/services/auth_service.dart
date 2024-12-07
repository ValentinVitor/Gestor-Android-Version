import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://seuipv4:3000'; // Substitua pelo URL do seu backend.

  Future<Map<String, String>?> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "senha": senha}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'token': data['token'], // Token JWT
          'nome': data['nome'],   // Nome do usuário
        };
      } else {
        return null; // Login falhou
      }
    } catch (e) {
      print("Erro durante o login: $e");
      return null; // Trate o erro e retorne null em caso de exceção.
    }
  }
}
