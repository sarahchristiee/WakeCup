import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakecup/services/services.carrinho.dart';


class TelaCarrinho extends StatefulWidget {
  const TelaCarrinho({super.key});

  @override
  State<TelaCarrinho> createState() => _TelaCarrinhoState();
}

class _TelaCarrinhoState extends State<TelaCarrinho> {
  List<dynamic> itensCarrinho = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _atualizarCarrinho();
  }

  Future<void> _atualizarCarrinho() async {
    final itens = await CarrinhoService.carregarCarrinho();
    setState(() {
      itensCarrinho = itens;
      carregando = false;
    });
  }

  double _calcularTotal() {
    double total = 0.0;
    for (var item in itensCarrinho) {
      String precoLimpo = item['preco']
          .toString()
          .replaceAll('R\$', '')
          .replaceAll('.', '')
          .replaceAll(',', '.')
          .trim();
      double preco = double.tryParse(precoLimpo) ?? 0.0;
      int qtd = item['quantidade'] ?? 1;
      total += (preco * qtd);
    }
    return total;
  }

  void _alterarQuantidade(int index, int mudanca) async {
    setState(() {
      itensCarrinho[index]['quantidade'] = (itensCarrinho[index]['quantidade'] ?? 1) + mudanca;
      if (itensCarrinho[index]['quantidade'] <= 0) {
        itensCarrinho.removeAt(index);
      }
    });
    await CarrinhoService.salvarCarrinho(itensCarrinho);
  }

  void _removerItem(int index) async {
    setState(() {
      itensCarrinho.removeAt(index);
    });
    await CarrinhoService.salvarCarrinho(itensCarrinho);
  }

  @override
  Widget build(BuildContext context) {
    String totalFormatado = _calcularTotal().toStringAsFixed(2).replaceAll('.', ',');

    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      bottomNavigationBar: Container(
        height: 75,
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.home_rounded, size: 34, color: Colors.black54),
            ),
            const Icon(Icons.favorite_border_rounded, size: 32, color: Colors.black54),
            const Icon(Icons.shopping_cart_rounded, size: 32, color: Color(0xffA8CF45)),
          ],
        ),
      ),
      body: SafeArea(
        child: carregando
            ? const Center(child: CircularProgressIndicator(color: Color(0xffA8CF45)))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // TOPO / LOGO
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SvgPicture.asset(
                      "assets/img/logo.svg",
                      height: 38,
                    ),
                  ),
                  const SizedBox(height: 25),

  
                  const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Carrinho",
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),


                  Expanded(
                    child: itensCarrinho.isEmpty
                        ? const Center(child: Text("Seu carrinho está vazio ☕"))
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: itensCarrinho.length,
                            itemBuilder: (context, index) {
                              final item = itensCarrinho[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Row(
                                  children: [
                                    
                                    Container(
                                      width: 85,
                                      height: 85,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffA8CF45),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Image.asset(
                                        item['imagem'] ?? '',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                  

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['nome'] ?? 'Produto',
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item['preco'] ?? 'R\$ 0,00',
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          

                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () => _alterarQuantidade(index, 1),
                                                child: const Text("+ ", style: TextStyle(fontSize: 18, color: Colors.black54)),
                                              ),
                                              Text(
                                                "${item['quantidade'] ?? 1}",
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                              GestureDetector(
                                                onTap: () => _alterarQuantidade(index, -1),
                                                child: const Text(" -", style: TextStyle(fontSize: 22, color: Colors.black54)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    


                                    GestureDetector(
                                      onTap: () => _removerItem(index),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("X", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w300)),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                 

                 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total: R\$$totalFormatado",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff8FCB1F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              "Finalizar Compra",
                              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}