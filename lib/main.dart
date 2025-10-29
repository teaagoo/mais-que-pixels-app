import 'package:flutter/material.dart';
import 'package:meu_primeiro_app/telas/boas_vindas.dart';
import 'package:meu_primeiro_app/telas/tela_principal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mais que pixels',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5E5),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
          backgroundColor: const Color(0xFFF5F5E5),
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontFamily: 'MochiyPopPOne',
            fontSize: 32,
            color: Colors.black,
          ),
          displayMedium: const TextStyle(
            fontFamily: 'MochiyPopPOne',
            fontSize: 24,
            color: Colors.black,
          ),
          bodyLarge: const TextStyle(
            fontFamily: 'Lato',
            fontSize: 16,
            color: Colors.black87,
          ),
          bodyMedium: const TextStyle(
            fontFamily: 'Lato',
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4CAF50),
          titleTextStyle: TextStyle(
            fontFamily: 'MochiyPopPOne',
            fontSize: 20,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        useMaterial3: false,
      ),
      home: const WelcomeScreen(),
      routes: {
        '/inicio': (context) => const TelaPrincipal(),
      },
    );
  }
}