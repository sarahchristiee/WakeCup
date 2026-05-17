import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritosService {
  static const String _key = 'favoritos_itens';

  // carrega lista do local storage
  static Future<List<dynamic>> carregarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    return jsonDecode(jsonString);
  }

  // salva lsita no local storage
  static Future<void> salvarFavoritos(List<dynamic> itens) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(itens);
    await prefs.setString(_key, jsonString);
  }

  // Alterna o estado
  static Future<bool> alternarFavorito(Map<String, dynamic> produto) async {
    List<dynamic> favoritos = await carregarFavoritos();
    int index = favoritos.indexWhere((item) => item['nome'] == produto['nome']);

    bool foiFavoritado;
    if (index != -1) {
      favoritos.removeAt(index);
      foiFavoritado = false;
    } else {
      favoritos.add(Map<String, dynamic>.from(produto));
      foiFavoritado = true;
    }

    await salvarFavoritos(favoritos);
    return foiFavoritado;
  }

  // Verifica de forma isolada se um item específico é favorito
  static Future<bool> eFavorito(String nomeProduto) async {
    List<dynamic> favoritos = await carregarFavoritos();
    return favoritos.any((item) => item['nome'] == nomeProduto);
  }
}