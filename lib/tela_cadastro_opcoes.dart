import 'package:flutter/material.dart';
import '/services/cadastroCatProd_service.dart'; // Certifique-se de importar o seu ApiService
import '/models/produtosModel.dart'; // Certifique-se de importar o modelo de Produto
import '/models/categoriasModel.dart'; // Certifique-se de importar o modelo de Categoria

class TelaCadastroOpcoes extends StatefulWidget {
  const TelaCadastroOpcoes({Key? key}) : super(key: key);

  @override
  _TelaCadastroOpcoesState createState() => _TelaCadastroOpcoesState();
}

class _TelaCadastroOpcoesState extends State<TelaCadastroOpcoes> {
  final ApiService apiService = ApiService();

  // Controladores dos campos de texto
  final TextEditingController nomeCategoriaController = TextEditingController();
  final TextEditingController nomeProdutoController = TextEditingController();
  final TextEditingController marcaProdutoController = TextEditingController();
  final TextEditingController quantidadeProdutoController = TextEditingController();
  final TextEditingController precoProdutoController = TextEditingController();
  final TextEditingController validadeProdutoController = TextEditingController();

  // Variáveis para categorias e seleção
  List<CategoriaBuscar> categorias = [];
  int? categoriaSelecionadaId;

  // Função para buscar categorias do backend
  Future<void> _fetchCategorias() async {
    try {
      final fetchedCategorias = await apiService.obterCategorias(); // Chama o metodo da API para buscar categorias
      setState(() {
        categorias = fetchedCategorias;
      });
    } catch (e) {
      print('Erro ao buscar categorias: $e');
    }
  }

  // Função para criar categoria
  void _criarCategoria() async {
    final categoria = Categoria(nome: nomeCategoriaController.text);
    await apiService.criarCategoria(categoria);
    await _fetchCategorias(); // Atualiza a lista de categorias após criar uma nova
  }

  // Função para criar produto
  void _criarProduto() async {
    if (categoriaSelecionadaId != null) {
      final produto = Produto(
        nome: nomeProdutoController.text,
        marca: marcaProdutoController.text,
        quantidade: int.parse(quantidadeProdutoController.text),
        preco: double.parse(precoProdutoController.text),
        validade: validadeProdutoController.text,
        categoriaId: categoriaSelecionadaId!,
      );
      await apiService.criarProduto(produto);
    } else {
      print('Selecione uma categoria');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategorias(); // Busca categorias ao iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        elevation: 4,
        color: Colors.white,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: double.infinity,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cadastrar',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Formulário para a Categoria
              TextField(
                controller: nomeCategoriaController,
                decoration: InputDecoration(
                  labelText: 'Nome da Categoria',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _criarCategoria,
                child: Text('Salvar Categoria'),
              ),
              Divider(),

              // Formulário para o Produto
              TextField(
                controller: nomeProdutoController,
                decoration: InputDecoration(
                  labelText: 'Nome do Produto',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: marcaProdutoController,
                decoration: InputDecoration(
                  labelText: 'Marca',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: quantidadeProdutoController,
                decoration: InputDecoration(
                  labelText: 'Quantidade',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: precoProdutoController,
                decoration: InputDecoration(
                  labelText: 'Preço',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 10),
              TextField(
                controller: validadeProdutoController,
                decoration: InputDecoration(
                  labelText: 'Validade',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              // Selecione a categoria
              DropdownButton<int>(
                value: categoriaSelecionadaId,
                hint: Text('Selecione a Categoria'),
                onChanged: (int? newValue) {
                  setState(() {
                    categoriaSelecionadaId = newValue;
                  });
                },
                items: categorias.map((categoria) {
                  return DropdownMenuItem<int>(
                    value: categoria.id,
                    child: Text(categoria.nome),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),

              ElevatedButton(
                onPressed: _criarProduto,
                child: Text('Salvar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
