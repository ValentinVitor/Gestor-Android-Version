import 'package:flutter/material.dart';
import '../services/tarefa_service.dart';

class TarefaComponente extends StatefulWidget {
  @override
  _TarefaComponenteState createState() => _TarefaComponenteState();
}

class _TarefaComponenteState extends State<TarefaComponente> {
  final TarefaService _tarefaService = TarefaService();
  final TextEditingController _controller = TextEditingController();
  List<dynamic> tarefas = [];

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  void _carregarTarefas() async {
    final lista = await _tarefaService.obterTarefas();
    setState(() {
      tarefas = lista;
    });
  }

  void _adicionarTarefa() async {
    if (_controller.text.isNotEmpty) {
      await _tarefaService.criarTarefa(_controller.text);
      _controller.clear();
      _carregarTarefas();
    }
  }

  void _atualizarTarefa(int id, bool concluida, String descricao) async {
    await _tarefaService.atualizarTarefa(id, concluida, descricao);
    _carregarTarefas();
  }

  void _excluirTarefa(int id) async {
    await _tarefaService.excluirTarefa(id);
    _carregarTarefas();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...tarefas.map((tarefa) {
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
                Checkbox(
                  value: tarefa['concluida'] == 1,
                  onChanged: (bool? value) async {
                    // Chama o serviço para atualizar a tarefa
                    await _tarefaService.atualizarTarefa(
                      tarefa['id'],               // Passando o ID da tarefa
                      value ?? false,             // Novo estado de concluída
                      tarefa['descricao'],        // Passando a descrição da tarefa
                    );
                    _carregarTarefas();           // Recarregar as tarefas para refletir a alteração
                  },
                ),
                Expanded(
                  child: Text(
                    tarefa['descricao'],
                    style: TextStyle(
                      fontSize: 16,
                      decoration: (tarefa['concluida'] == 1)
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: (tarefa['concluida'] == 1)
                          ? Colors.grey
                          : Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _excluirTarefa(tarefa['id']),
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
                  hintText: 'Adicione uma tarefa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: _adicionarTarefa,
              child: Text('Adicionar'),
            ),
          ],
        ),
      ],
    );
  }
}
