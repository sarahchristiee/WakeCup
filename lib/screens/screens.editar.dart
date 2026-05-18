import 'package:flutter/material.dart';

class TelaEditarProduto extends StatefulWidget {
  final Map<String, dynamic>? cafe; // Nulo indica que é uma criação

  const TelaEditarProduto({super.key, this.cafe});

  @override
  State<TelaEditarProduto> createState() => _TelaEditarProdutoState();
}

class _TelaEditarProdutoState extends State<TelaEditarProduto> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomeCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _precoCtrl;
  late TextEditingController _imagemCtrl;
  late TextEditingController _ingredientesCtrl;

  @override
  void initState() {
    super.initState();
    // Se widget.cafe for nulo, carrega valores padrão para novo produto
    _nomeCtrl = TextEditingController(text: widget.cafe?['nome'] ?? "");
    _descCtrl = TextEditingController(text: widget.cafe?['descricao'] ?? "");
    _precoCtrl = TextEditingController(text: widget.cafe?['preco'] ?? " ");
    _imagemCtrl = TextEditingController(text: widget.cafe?['imagem'] ?? "assets/img/Espresso.png");

    // Converte a List<dynamic> em uma única String separada por vírgula para o input
    List ingredientesLista = widget.cafe?['ingredientes'] ?? [];
    _ingredientesCtrl = TextEditingController(text: ingredientesLista.join(", "));
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _descCtrl.dispose();
    _precoCtrl.dispose();
    _imagemCtrl.dispose();
    _ingredientesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.cafe != null;

    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        title: Text(
          isEditing ? "Editar Produto" : "Adicionar Produto",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildField(_nomeCtrl, "Nome do Café", "Digite o nome"),
                _buildField(_descCtrl, "Descrição", "Digite a descrição", maxLines: 3),
                _buildField(_precoCtrl, "Preço", "Exemplo: 12,50"),
                _buildField(_imagemCtrl, "Caminho da Imagem", "Ex: assets/img/Espresso.png"),
                _buildField(
                  _ingredientesCtrl, 
                  "Ingredientes", 
                  "Separe por vírgulas (ex: Café espresso, Leite)",
                  maxLines: 2
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffA8CF45),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Transforma a string de ingredientes de volta em uma lista limpa
                      List<String> listaIngredientes = _ingredientesCtrl.text
                          .split(",")
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList();

                      // Monta o mapa mapeado com a estrutura exata do JSON
                      final dadosMapeados = {
                        "id": widget.cafe?['id'], // Mantém se existir
                        "nome": _nomeCtrl.text.trim(),
                        "descricao": _descCtrl.text.trim(),
                        "preco": _precoCtrl.text.trim(),
                        "imagem": _imagemCtrl.text.trim(),
                        "ingredientes": listaIngredientes,
                      };

                      // Retorna os dados prontos para a TelaInicial
                      Navigator.pop(context, dadosMapeados);
                    }
                  },
                  child: Text(
                    isEditing ? "SALVAR ALTERAÇÕES" : "CADASTRAR PRODUTO",
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Este campo é obrigatório";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}