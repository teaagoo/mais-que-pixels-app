import 'package:flutter/material.dart';
import 'package:meu_primeiro_app/telas/boas_vindas.dart'; 

void main() {
  // Inicia o aplicativo, executando o widget raiz MyApp
  runApp(const MyApp());
}

// -----------------------------------------------------
// 1. WIDGET RAIZ DO APLICATIVO (Permanece aqui)
// -----------------------------------------------------

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mais que pixels',
      theme: ThemeData(
        // Tema visual do aplicativo
        primarySwatch: Colors.green,
        // Cor de fundo do Scaffold padrão
        scaffoldBackgroundColor: const Color(0xFFF5F5E5), 
      ),
      // O 'home' aponta para o widget que foi importado do arquivo 'boas_vindas.dart'
      home: const WelcomeScreen(), // Assume que a classe dentro do arquivo é WelcomeScreen
    );
  }
}
