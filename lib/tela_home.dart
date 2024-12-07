import 'package:flutter/material.dart';
import 'tela_cadastro.dart';
import 'main.dart';
import 'package:gestor_app_android/components/tarefa_component.dart';
import 'package:gestor_app_android/components/anotacao_component.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaHome(
        usuarioNome: '',
      ),
    );
  }
}

class TelaHome extends StatelessWidget {
  final String usuarioNome;

  TelaHome({required this.usuarioNome}); // Exige o nome do usuário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.person, color: Colors.black),
        ),
        title: Text(
          'Gestor',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) =>
                    false, // Remove todas as rotas anteriores
              );
            },
            icon: Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Aparecer nome de usuario:
            /* Text(
              'Bem vindo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            Text(
              usuarioNome, // Exibe o nome do usuário
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ), */
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconButton(
                  context,
                  Icons.assignment,
                  'CADASTRO',
                  TelaCadastro(), // Tela de Cadastro
                ),
              ],
            ),
            SizedBox(height: 32),
            SizedBox(height: 16),
            _buildSection(
              title: 'Tarefas',
              child: TarefaComponente(), // Componente para tarefas
            ),
            SizedBox(height: 16),
            _buildSection(
              title: 'Anotações',
              child: AnotacaoComponente(), // Componente para anotações
            ),
            SizedBox(height: 16),
            _buildContactSection(),
          ],
        ),
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

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildContactSection() {
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
                Text('Entre em contato conosco sobre qualquer dúvida: '),
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
