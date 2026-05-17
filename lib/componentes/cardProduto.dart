import 'package:flutter/material.dart';

class CardProduto extends StatelessWidget {
  final Map cafe;
  final bool favorito;
  final VoidCallback onFavoritoPressed;

  const CardProduto({
    super.key,
    required this.cafe,
    required this.favorito,
    required this.onFavoritoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 330,
      decoration: const BoxDecoration(
        color: Color(0xffA8CF45),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Image.asset("assets/img/detalhe.png", width: 120),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
                ),
              ),
              Positioned(
                top: 55,
                left: 0,
                child: SizedBox(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cafe["nome"],
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        cafe["preco"],
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 25),
                      GestureDetector(
                        onTap: onFavoritoPressed,
                        child: Icon(
                          favorito ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: -10,
                right: -5,
                child: Image.asset(
                  cafe["imagem"],
                  height: 240,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}