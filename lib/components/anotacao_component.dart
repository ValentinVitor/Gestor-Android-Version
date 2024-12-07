import 'package:flutter/material.dart';
import '../services/anotacao_service.dart'; // Serviço para gerenciar anotações

class AnotacaoComponente extends StatefulWidget {
  @override
  _AnotacaoComponenteState createState() => _AnotacaoComponenteState();
}

class _AnotacaoComponenteState extends State<AnotacaoComponente> {
  final AnotacaoService _anotacaoService = AnotacaoService();
  final TextEditingController _controller = TextEditingController();
  List<dynamic> anotacoes = [];

  @override
  void initState() {
    super.initState();
    _carregarAnotacoes();
  }

  void _carregarAnotacoes() async {
    final lista = await _anotacaoService.obterAnotacoes();
    setState(() {
      anotacoes = lista;
    });
  }

  void _adicionarAnotacao() async {
    if (_controller.text.isNotEmpty) {
      await _anotacaoService.criarAnotacao(_controller.text);
      _controller.clear();
      _carregarAnotacoes();
    }
  }

  void _excluirAnotacao(int id) async {
    await _anotacaoService.excluirAnotacao(id);
    _carregarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...anotacoes.map((anotacao) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(anotacao['conteudo'], style: TextStyle(fontSize: 16)),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _excluirAnotacao(anotacao['id']),
                ),
              ],
            ),
          );
        }).toList(),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Adicione uma anotação',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: _adicionarAnotacao,
              child: Text('Adicionar'),
            ),
          ],
        ),
      ],
    );
  }
}
