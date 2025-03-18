import 'package:flutter/material.dart';
import 'app/data/models/ordens_de_servicos.dart';
import 'app/data/repositories/ordens_repository.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Chamados',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const OrdemServicoPage(),
    );
  }
}

class OrdemServicoPage extends StatefulWidget {
  const OrdemServicoPage({super.key});

  @override
  State<OrdemServicoPage> createState() => _OrdemServicoPageState();
}

class _OrdemServicoPageState extends State<OrdemServicoPage> {
  late Future<List<OrdemDeServico>> _futureOrdens;

  @override
  void initState() {
    super.initState();
    _futureOrdens = listarChamados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ordens de Serviço')),
      body: FutureBuilder<List<OrdemDeServico>>(
        future: listarChamados(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Erro ao carregar os chamados');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('Nenhum chamado encontrado');
          } else {
            final ordens = snapshot.data!;
            return ListView.builder(
              itemCount: ordens.length,
              itemBuilder: (context, index) {
                final ordem = ordens[index];
                return ListTile(
                  title: Text('Chamado #${ordem.id}'),
                  subtitle: Text('Cliente: ${ordem.clientName}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
