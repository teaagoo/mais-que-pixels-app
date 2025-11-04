// main.dart

import 'package:flutter/material.dart';
import 'package:meu_primeiro_app/telas/boas_vindas.dart'; // Mantido como tela inicial
import 'package:meu_primeiro_app/telas/tela_principal.dart'; 
import 'package:meu_primeiro_app/services/auth_services.dart'; 
import 'package:provider/provider.dart'; 
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mais que Pixels',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        fontFamily: 'Lato',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3A6A4D)),
        useMaterial3: true,
      ),
      // Tela inicial é a WelcomeScreen
      home: const WelcomeScreen(), 
      
      routes: {
        // ROTA CORRETA DEFINIDA AQUI: '/principal'
        '/principal': (context) => const TelaPrincipal(),
      },
    );
  }
}