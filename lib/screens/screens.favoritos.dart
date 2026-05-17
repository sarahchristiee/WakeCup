import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakecup/screens/screens.produto.dart';
import 'package:wakecup/services/services.favoritos.dart';
import 'screens.carrinho.dart';

class TelaFavoritos extends StatefulWidget {
  const TelaFavoritos({super.key});

  @override
  State<TelaFavoritos> createState() => _TelaFavoritosState();
}

class _TelaFavoritosState extends State<TelaFavoritos> {
  List<dynamic> itensFavoritos = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _atualizarFavoritos();
  }

  Future<void> _atualizarFavoritos() async {
    final itens = await FavoritosService.carregarFavoritos();
    setState(() {
      itensFavoritos = itens;
      carregando = false;
    });
  }

  void _removerFavorito(Map<String, dynamic> produto) async {
    await FavoritosService.alternarFavorito(produto);
    _atualizarFavoritos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      bottomNavigationBar: Container(
        height: 75,
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: const Icon(Icons.home_rounded, size: 34, color: Colors.black54),
            ),
            const Icon(Icons.favorite_rounded, size: 32, color: Color(0xffA8CF45)),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TelaCarrinho()),
                );
              },
              child: const Icon(Icons.shopping_cart_rounded, size: 32, color: Colors.black54),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: carregando
            ? const Center(child: CircularProgressIndicator(color: Color(0xffA8CF45)))
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    // TOPO / LOGO
                    SvgPicture.asset(
                      "assets/img/logo.svg",
                      height: 38,
                    ),
                    const SizedBox(height: 25),
                    // TÍTULO
                    const Text(
                      "Seus Favoritos",
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    // GRID DE FAVORITOS
                    Expanded(
                      child: itensFavoritos.isEmpty
                          ? const Center(child: Text("Nenhum café favoritado ainda ❤️"))
                          : GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: itensFavoritos.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio: 0.75,
                              ),
                              itemBuilder: (context, index) {
                                final cafe = itensFavoritos[index];

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TelaProduto(cafe: cafe),
                                      ),
                                    ).then((_) => _atualizarFavoritos());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Imagem do Produto centralizada
                                        Expanded(
                                          child: Center(
                                            child: Image.asset(
                                              cafe["imagem"] ?? '',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Nome do Produto
                                        Text(
                                          cafe["nome"] ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                        ),
                                        // Preço e Ícone de Favorito Ativo
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              cafe["preco"] ?? '',
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                            ),
                                            GestureDetector(
                                              onTap: () => _removerFavorito(Map<String, dynamic>.from(cafe)),
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xffA8CF45),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.favorite,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}