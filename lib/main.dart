// lib/main.dart

import 'package:flutter/material.dart';
import 'package:meu_primeiro_app/telas/boas_vindas.dart'; 
import 'package:meu_primeiro_app/telas/tela_principal.dart'; 
import 'package:meu_primeiro_app/services/auth_services.dart'; 
import 'package:meu_primeiro_app/services/user_data_service.dart'; 
import 'package:meu_primeiro_app/services/mission_service.dart';
// **Imports de StorageService e ProfileProvider removidos**
import 'package:meu_primeiro_app/widgets/auth_check.dart'; 
import 'package:provider/provider.dart'; 
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
    MultiProvider(
      providers: [
        // 1. AuthService - Gerencia o estado de autenticação
        ChangeNotifierProvider(create: (context) => AuthService()),
        
        // 2. UserDataService - Acesso aos dados do usuário no Firestore
        Provider(create: (context) => UserDataService()), 
        
        // 3. MissionService - Acesso às missões do Firestore (DEVE ESTAR AQUI)
        Provider(create: (context) => MissionService()),
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
      home: AuthCheck(), 
      
      routes: {
        '/principal': (context) => const TelaPrincipal(),
      },
    );
  }
}