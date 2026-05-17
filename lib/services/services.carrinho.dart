import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakecup/services/services.carrinho.dart';

class CarrinhoService {
  static const String _key = 'carrinho_itens';

  // salva os itens no local storage
  static Future<void> salvarCarrinho(List<dynamic> itens) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(itens);
    await prefs.setString(_key, jsonString);
  }

  // carrega lista
  static Future<List<dynamic>> carregarCarrinho() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    return jsonDecode(jsonString);
  }

  // quantidade
  static Future<void> adicionarProduto(Map<String, dynamic> produto) async {
    List<dynamic> carrinho = await carregarCarrinho();
    
    int index = carrinho.indexWhere((item) => item['nome'] == produto['nome']);

    if (index != -1) {
      carrinho[index]['quantidade'] = (carrinho[index]['quantidade'] ?? 1) + 1;
    } else {
      Map<String, dynamic> novoItem = Map<String, dynamic>.from(produto);
      novoItem['quantidade'] = 1;
      carrinho.add(novoItem);
    }

    await salvarCarrinho(carrinho);
  }
}