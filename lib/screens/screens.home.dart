import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakecup/screens/screens.produto.dart';
import 'package:wakecup/services/services.carrinho.dart';
import 'package:wakecup/services/services.favoritos.dart';
import 'screens.carrinho.dart';
import 'screens.favoritos.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  List cafes = [];

  void buscarCafes() async {
    final String resposta =
        await DefaultAssetBundle.of(context).loadString('assets/db.json');
    final dados = jsonDecode(resposta);
    setState(() {
      cafes = dados["produtos"];
    });
  }

  @override
  void initState() {
    super.initState();
    buscarCafes();
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
            const Icon(Icons.home_rounded, size: 34, color: Color(0xffA8CF45)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TelaFavoritos()),
                );
              },
              child: const Icon(Icons.favorite_border_rounded, size: 32, color: Colors.black54),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset("assets/img/logo.svg", height: 38),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(color: Color(0xffA8CF45), shape: BoxShape.circle),
                      child: const Icon(Icons.person_outline_rounded, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text("Boa Tarde, Usuário!", style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text("É hora de uma pausa para o café", style: TextStyle(fontSize: 16, color: Colors.black54)),
                const SizedBox(height: 32),
                const Text("Mais Comprados", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 18),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _cardCarrossel("assets/img/card1.png"),
                      _cardCarrossel("assets/img/card2.png"),
                      _cardCarrossel("assets/img/card3.png"),
                      _cardCarrossel("assets/img/card4.png"),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cafes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    final cafe = cafes[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => TelaProduto(cafe: cafe)),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Center(child: Image.asset(cafe["imagem"], fit: BoxFit.contain)),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              cafe["nome"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(cafe["preco"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                GestureDetector(
                                  onTap: () async {
                                    await CarrinhoService.adicionarProduto(Map<String, dynamic>.from(cafe));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("${cafe['nome']} adicionado ao carrinho!"),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: const BoxDecoration(color: Color(0xffA8CF45), shape: BoxShape.circle),
                                    child: const Icon(Icons.add, color: Colors.white, size: 18),
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
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardCarrossel(String imagem) {
    return Container(
      width: 145,
      height: 170,
      margin: const EdgeInsets.only(right: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset(
          imagem,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade300,
              child: const Center(child: Icon(Icons.image)),
            );
          },
        ),
      ),
    );
  }
}