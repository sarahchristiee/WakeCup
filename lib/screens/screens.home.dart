import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakecup/screens/screens.editar.dart';
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

  // Abre o formulário tanto para Adicionar quanto para Editar
  Future<void> _abrirFormulario({Map<String, dynamic>? cafe, int? index}) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TelaEditarProduto(cafe: cafe),
      ),
    );

    if (resultado != null) {
      setState(() {
        if (index == null) {
          // Lógica de Adicionar Novo Item
          resultado['id'] = cafes.isEmpty ? 1 : cafes.last['id'] + 1;
          cafes.add(resultado);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Novo produto adicionado com sucesso!")),
          );
        } else {
          // Lógica de Editar Item Existente
          cafes[index] = resultado;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Produto atualizado com sucesso!")),
          );
        }
      });
    }
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
                    Row(
                      children: [
                        SvgPicture.asset("assets/img/logo.svg", height: 38),
                        const SizedBox(width: 8),
                        // Botão de Adicionar Novo Produto na Nav
                        IconButton(
                          onPressed: () => _abrirFormulario(),
                          icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xffA8CF45), size: 30),
                          tooltip: "Adicionar café",
                        ),
                      ],
                    ),
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
                    childAspectRatio: 0.68, // Ajustado ligeiramente para acomodar o menu
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
                            // Linha do menu de 3 pontos no topo do card
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: PopupMenuButton<String>(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.more_vert, color: Colors.black54, size: 20),
                                    onSelected: (value) {
                                      if (value == 'editar') {
                                        _abrirFormulario(cafe: Map<String, dynamic>.from(cafe), index: index);
                                      } else if (value == 'excluir') {
                                        setState(() {
                                          cafes.removeAt(index);
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Produto excluído!")),
                                        );
                                      }
                                    },
                                    itemBuilder: (BuildContext context) => [
                                      const PopupMenuItem(
                                        value: 'editar',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, size: 18, color: Colors.black54),
                                            SizedBox(width: 8),
                                            Text('Editar'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'excluir',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete, size: 18, color: Colors.red),
                                            SizedBox(width: 8),
                                            Text('Excluir', style: TextStyle(color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Center(
                                child: Image.asset(
                                  cafe["imagem"], 
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.local_cafe,
                                    size: 50, 
                                    color: Colors.grey,
                                  ),
                                )
                              ),
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