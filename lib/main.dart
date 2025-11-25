// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/rendering.dart'; // <-- necessário para debugPaintSizeEnabled

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
import 'package:meu_primeiro_app/telas/tela_historico.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // REMOVE O AVISO AMARELO E PRETO (debug overflow)
  debugPaintSizeEnabled = false;

  // Necessário para formatar datas em pt_BR (resolve erro do histórico)
  await initializeDateFormatting('pt_BR', null);

  // Firebase
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => UserDataService()),
        Provider(create: (_) => MissionService()),
        Provider(create: (_) => StatsService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: AuthCheck(),

      routes: {
        '/principal': (context) => const TelaPrincipal(),
        '/foco-config': (context) => const ModoFocoConfigTela(),
        '/foco-progresso': (context) => const ModoFocoEmAndamentoTela(
              durationMinutes: 30,
            ),
        '/historico': (context) => const TelaHistorico(),
      },
    );
  }
}
