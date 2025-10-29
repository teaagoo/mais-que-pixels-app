import 'package:flutter/material.dart';
import 'package:meu_primeiro_app/telas/boas_vindas.dart'; // Importa a tela de boas-vindas correta
import 'package:meu_primeiro_app/telas/tela_principal.dart'; // Importa a tela principal
import 'package:meu_primeiro_app/controles/bd.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SqfliteController().initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mais que Pixels',
      debugShowCheckedModeBanner: false, // Remove o banner de "Debug"
      theme: ThemeData(
        // Você pode definir um tema base para o seu app aqui
        // Por exemplo, as fontes padrão
        fontFamily: 'Lato',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3A6A4D)),
        useMaterial3: true,
      ),
      // Define a tela inicial do aplicativo
      home: const WelcomeScreen(),
      
      // Define as "rotas" ou "caminhos" nomeados para outras telas
      // Isso permite que você navegue usando nomes, como '/inicio'
      routes: {
        '/inicio': (context) => const TelaPrincipal(),
      },
    );
  }
}