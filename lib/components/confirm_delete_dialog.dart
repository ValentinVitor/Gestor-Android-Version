import 'package:flutter/material.dart';
import 'package:gestor_app_android/services/cadastroCatProd_service.dart'; // Importa o serviço de API

class ConfirmDeleteDialog extends StatelessWidget {
  final int produtoId;
  final BuildContext context; // Contexto para mostrar mensagens
  final Future<void> Function() onDeleteSuccess; // Função de callback para atualizar a tabela

  ConfirmDeleteDialog({
    required this.produtoId,
    required this.context,
    required this.onDeleteSuccess, // Recebe a função de callback
  });

  // Função para excluir o produto
  Future<void> _deletarProduto(int produtoId) async {
    final ApiService apiService = ApiService();
    try {
      await apiService.deletarProduto(produtoId); // Chama o método de deletar
      Navigator.of(context).pop(); // Fecha o diálogo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produto excluído com sucesso!')),
      );
      onDeleteSuccess(); // Chama a função de callback para atualizar a tabela
    } catch (e) {
      Navigator.of(context).pop(); // Fecha o diálogo em caso de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir o produto: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirmação de Exclusão'),
      content: Text('Tem certeza de que deseja excluir este produto?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fecha o diálogo sem fazer nada
          },
          child: Text('Não'),
        ),
        TextButton(
          onPressed: () async {
            await _deletarProduto(produtoId); // Chama a função para excluir
          },
          child: Text('Sim'),
        ),
      ],
    );
  }
}
