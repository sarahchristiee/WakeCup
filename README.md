<p align="center">
  <img src="assets/img/logo.svg" alt="WakeCup Logo" width="200">
</p>


<p align="center">
  <strong>☕ Um aplicativo de cafeteria moderno, fluido e intuitivo desenvolvido em Flutter.</strong>
</p>

---

## 📌 Sobre o Projeto

O **WakeCup** é um aplicativo mobile focado na experiência de compra de cafés e bebidas especiais. Este projeto foi desenvolvido como parte dos requisitos avaliativos da matéria de **Desenvolvimento Mobile**.

O aplicativo conta com:
* **Tela Inicial:** Listagem de produtos (cafés) carregados dinamicamente via JSON e carrossel de destaques.
* **Detalhes do Produto:** Informações detalhadas sobre ingredientes e descrição de cada bebida.
* **Sistema de Favoritos:** Persistência local (usando `shared_preferences`) para salvar e gerenciar os cafés favoritos do usuário.
* **Carrinho de Compras:** Adição de itens, controle de quantidade e cálculo automático do valor total do pedido.

---

## 🚀 Tecnologias Utilizadas

* [Flutter](https://flutter.dev/) - Framework UI toolkit
* [Dart](https://dart.dev/) - Linguagem de programação
* `shared_preferences` - Para persistência de dados local (Favoritos/Carrinho)
* `flutter_svg` - Para renderização eficiente de elementos visuais vetoriais

---

## 🛠️ Como Executar o Projeto

Siga os passos abaixo para clonar o repositório e rodar o projeto na sua máquina.

### Pré-requisitos
Certifique-se de ter o SDK do Flutter instalado configurado no seu ambiente (`flutter doctor`).

### 1. Clonar o repositório
```bash
git clone https://github.com/sarahchristiee/WakeCup.git
cd WakeCup
```

### 2. Instalar as dependências (pub get)
Antes de rodar o app, é necessário baixar as dependências e pacotes configurados no `pubspec.yaml`:
```bash
flutter pub get
```

### 3. Executar o projeto no Google Chrome
Como o projeto possui suporte para Flutter Web, você pode inicializá-lo diretamente pelo terminal forçando a execução no navegador Chrome com o seguinte comando:
```bash
flutter run -d chrome
```
