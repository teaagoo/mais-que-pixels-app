// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// SERVICES
import 'package:meu_primeiro_app/services/auth_services.dart';
import 'package:meu_primeiro_app/services/user_data_service.dart';
import 'package:meu_primeiro_app/services/mission_service.dart';
import 'package:meu_primeiro_app/services/stats_service.dart';

// TELAS
import 'package:meu_primeiro_app/widgets/auth_check.dart';
import 'package:meu_primeiro_app/telas/tela_principal.dart';
import 'package:meu_primeiro_app/telas/modo_foco_config.dart';
import 'package:meu_primeiro_app/telas/modo_foco_em_andamento.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => UserDataService()),
        Provider(create: (_) => MissionService()),
        Provider(create: (_) => StatsService()),
      ],
      child: MyApp(),   // ❌ REMOVIDO const
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});  // ❌ REMOVIDO const

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: AuthCheck(),   // ❌ REMOVIDO const

      routes: {
        '/principal': (context) => const TelaPrincipal(),
        '/foco-config': (context) => ModoFocoConfigTela(),
        '/foco-progresso': (context) => ModoFocoEmAndamentoTela(
              durationMinutes: 30,
            ),
      },
    );
  }
}
