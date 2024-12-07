import 'package:flutter/material.dart';
import 'package:gestor_app_android/services/comentario_service.dart';

class ComentariosWidget extends StatefulWidget {
  @override
  _ComentariosWidgetState createState() => _ComentariosWidgetState();
}

class _ComentariosWidgetState extends State<ComentariosWidget> {
  // Instancia o serviço para realizar as ações de comentários
  final ComentarioService comentarioService = ComentarioService();

  // Variáveis de controle
  List<dynamic> comentarios = [];
  TextEditingController comentarioController = TextEditingController();

  // Função para carregar os comentários da API
  Future<void> _loadComentarios() async {
    try {
      List<dynamic> comentariosObtidos = await comentarioService.obterComentarios();
      setState(() {
        comentarios = comentariosObtidos;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Falha ao carregar comentários')));
    }
  }

  // Função para adicionar um comentário
  Future<void> _adicionarComentario() async {
    String comentarioTexto = comentarioController.text;
    if (comentarioTexto.isNotEmpty) {
      try {
        await comentarioService.criarComentario(comentarioTexto);
        _loadComentarios(); // Recarrega os comentários após adicionar
        comentarioController.clear(); // Limpa o campo de texto
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Falha ao adicionar comentário')));
      }
    }
  }

  // Função para excluir um comentário
  Future<void> _excluirComentario(int id) async {
    try {
      await comentarioService.excluirComentario(id);
      _loadComentarios(); // Recarrega os comentários após excluir
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Falha ao excluir comentário')));
    }
  }

  // Função que cria o card para cada comentário
  Widget _buildCommentCard(dynamic comentario) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            // Ícone de alerta à esquerda
            Icon(Icons.warning),
            SizedBox(width: 10),
            // Texto do comentário
            Expanded(
              child: Text(
                comentario['comentario'],
                style: TextStyle(fontSize: 16),
              ),
            ),
            // Ícone de exclusão à direita
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _excluirComentario(comentario['id']);
              },
            ),
          ],
        ),
      ),
    );
  }

  // A construção da seção de comentários com o campo de texto e o botão
  Widget _buildCommentsSection() {
    return Column(
      children: [
        // Exibe todos os comentários carregados
        ...comentarios.map((comentario) => _buildCommentCard(comentario)).toList(),
        SizedBox(height: 10),
        TextField(
          controller: comentarioController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Adicione um comentário/alerta',
          ),
          maxLines: 3,
        ),
        SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: _adicionarComentario,
            child: Text('Adicionar'),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _loadComentarios(); // Carrega os comentários ao iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        _buildCommentsSection(),
      ],
    );
  }
}
