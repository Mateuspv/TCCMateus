import 'package:flutter/material.dart';
import 'package:tcc/app/pages/ordens_de_servicos_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ordens De Serviço',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: OrdensDeServicosPage(),
    );
  }
}



