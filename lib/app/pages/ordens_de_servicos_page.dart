import 'package:flutter/material.dart';
import 'package:tcc/app/widgets/ordens_list.dart';
import '../data/models/ordens_de_servicos.dart';
import '../data/repositories/ordens_repository.dart';

class OrdensDeServicosPage extends StatefulWidget {
  const OrdensDeServicosPage({super.key});

  @override
  _OrdensDeServicosPageState createState() => _OrdensDeServicosPageState();
}

class _OrdensDeServicosPageState extends State<OrdensDeServicosPage> {
  late Future<List<OrdemDeServico>> _futureOrdens;

  @override
  void initState() {
    super.initState();
    _futureOrdens = listarChamados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _headerAppBar(),
      body: _registrosOrdens(),
    );
  }

  AppBar _headerAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text('Ordens De Serviço'),
    );
  }

  Widget _registrosOrdens() {
    return FutureBuilder<List<OrdemDeServico>>(
      future: listarChamados(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar os chamados'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum chamado encontrado'));
        } else {
          final ordens = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: ordens.length,
            itemBuilder: (context, index) {
              return OrdemList(
                ordem: ordens[index],
                onTap: () => _abrirDetalhes(ordens[index]),
              );
            },
          );
        }
      },
    );
  }
}

void _abrirDetalhes(OrdemDeServico ordem) {
  print("Clicou na ordem de ${ordem.clientName}");
}