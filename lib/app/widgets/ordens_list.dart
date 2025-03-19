import 'package:flutter/material.dart';

import '../data/models/ordens_de_servicos.dart';

class OrdemList extends StatelessWidget {
  final OrdemDeServico ordem;
  final VoidCallback onTap;

  const OrdemList({Key? key, required this.ordem, required this.onTap,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8), // Espaço entre os itens
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), // Bordas arredondadas
          color: Colors.yellow, // Fundo amarelo
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16), // Espaçamento interno
        child: Row(
          children: [
            Text('${ordem.clientName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
