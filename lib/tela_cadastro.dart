import 'package:flutter/material.dart';
import 'tela_home.dart';
import 'tela_cadastro_opcoes.dart'; // Importe o arquivo criado
import '/services/cadastroCatProd_service.dart'; // Certifique-se de importar o seu ApiService
import 'package:gestor_app_android/components/confirm_delete_dialog.dart';
import 'package:gestor_app_android/components/comentario_component.dart'; // Importa o componente de comentários

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaCadastro(),
    );
  }
}

class TelaCadastro extends StatefulWidget {
  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  bool _isSidebarVisible =
      false; // Estado para controlar a visibilidade da barra lateral

  void _toggleSidebar() {
    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
    });
  }

  Future<void> atualizarTabela() async {
    setState(() {
      ApiService().obterProdutos(); // Recarrega os produtos
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.grey[200],
          elevation: 0,
          title: Text(
            'Gestor',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.add,
                  color: Colors.black), // Ícone com o sinal de '+'
              onPressed: _toggleSidebar, // Abre ou fecha a barra lateral
            ),
          ]),
      body: Stack(
        children: [
          // Conteúdo principal
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIconButton(
                        context,
                        Icons.home_filled,
                        'INÍCIO',
                        TelaHome(usuarioNome: '',),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Cadastro',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildDataTable(),
                  SizedBox(height: 10),
                  SizedBox(height: 20),
                  Text(
                    'Comentários:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildCommentsSection(), // Aqui você chama o ComentariosWidget
                  SizedBox(height: 20),
                  _buildSupportSection(),
                ],
              ),
            ),
          ),

          // Barra lateral
          if (_isSidebarVisible)
            GestureDetector(
              onTap: _toggleSidebar, // Fecha ao clicar fora da barra lateral
              child: Container(
                color: Colors.black54, // Fundo semitransparente
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    elevation: 4,
                    color: Colors.white,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TelaCadastroOpcoes(), // Mostra o widget lateral
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
      BuildContext context, IconData icon, String label, Widget targetPage) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: 30),
          onPressed: () {
            // Navega para a página especificada
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetPage),
            );
          },
        ),
        SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildCommentsSection() {
    return ComentariosWidget(); // Chama o widget de comentários
  }

  Widget _buildDataTable() {
    final ApiService apiService = ApiService();

    return FutureBuilder<List<Map<String, dynamic>>>(
      // Recarrega os produtos da API
      future: apiService.obterProdutos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Erro ao carregar produtos: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Nenhum produto encontrado.'));
        }

        // Dados recebidos do backend
        final produtos = snapshot.data!;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Permite rolagem horizontal
          child: DataTable(
            columns: [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Nome')),
              DataColumn(label: Text('Marca')),
              DataColumn(label: Text('Quantidade')),
              DataColumn(label: Text('Preço')),
              DataColumn(label: Text('Validade')),
              DataColumn(label: Text('Apagar')),
            ],
            rows: produtos.map((produto) {
              return DataRow(
                cells: [
                  DataCell(Text(produto['id'].toString())),
                  DataCell(Text(produto['nome'])),
                  DataCell(Text(produto['marca'])),
                  DataCell(Text(produto['quantidade'].toString())),
                  DataCell(Text(produto['preco'].toString())),
                  DataCell(Text(produto['validade'])),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Exibe o dialog de confirmação antes de excluir
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmDeleteDialog(
                              produtoId: produto['id'],
                              context: context, // Passa o contexto
                              onDeleteSuccess:
                                  atualizarTabela, // Passa a função de atualização
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildSupportSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.help_outline, size: 48),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Algum Problema?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('Entre em contato conosco sobre qualquer dúvida:'),
                Text(
                  'gestor@suporte.com',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
