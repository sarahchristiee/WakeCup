import 'package:flutter/material.dart';
import 'package:wakecup/componentes/cardProduto.dart';
import 'package:wakecup/services/services.carrinho.dart';
import 'package:wakecup/services/services.favoritos.dart';
import 'screens.carrinho.dart';


class TelaProduto extends StatefulWidget {
  final Map cafe;

  const TelaProduto({
    super.key,
    required this.cafe,
  });

  @override
  State<TelaProduto> createState() => _TelaProdutoState();
}

class _TelaProdutoState extends State<TelaProduto> {
  bool favorito = false;

  @override
  void initState() {
    super.initState();
    _verificarFavoritoInicial();
  }

  Future<void> _verificarFavoritoInicial() async {
    bool resultado = await FavoritosService.eFavorito(widget.cafe["nome"]);
    setState(() {
      favorito = resultado;
    });
  }

  void _comprarItem() async {
    await CarrinhoService.adicionarProduto(Map<String, dynamic>.from(widget.cafe));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TelaCarrinho()),
    );
  }

  void _alternarEstadoFavorito() async {
    bool novoEstado = await FavoritosService.alternarFavorito(Map<String, dynamic>.from(widget.cafe));
    setState(() {
      favorito = novoEstado;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ingredientes = (widget.cafe["ingredientes"] as List).join(", ");

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // COMPONENTE ISOLADO AQUI
            CardProduto(
              cafe: widget.cafe,
              favorito: favorito,
              onFavoritoPressed: _alternarEstadoFavorito,
            ),
            
            // CONTEUDO
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text("Desc", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    widget.cafe["descricao"],
                    style: const TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                  const SizedBox(height: 30),
                  const Text("Ingredientes", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    ingredientes,
                    style: const TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Row(
          children: [
            GestureDetector(
              onTap: _comprarItem,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
                child: const Icon(Icons.shopping_cart, size: 30),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: GestureDetector(
                onTap: _comprarItem,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xff8FCB1F),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Center(
                    child: Text(
                      "Comprar Agora",
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}