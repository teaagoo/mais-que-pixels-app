// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart'; // NOVO IMPORT

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
import 'package:meu_primeiro_app/telas/boas_vindas.dart'; // CERTIFIQUE-SE QUE ESSA TELA ESTÁ IMPORTADA

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPaintSizeEnabled = false;

  await initializeDateFormatting('pt_BR', null);

  // Inicializa o Firebase
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      // A home agora é um novo widget que verifica se é a primeira abertura.
      home: CheckFirstOpen(),

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

// NOVO WIDGET: Lógica para forçar a tela de Boas-Vindas na primeira vez
class CheckFirstOpen extends StatefulWidget {
  const CheckFirstOpen({super.key});

  @override
  State<CheckFirstOpen> createState() => _CheckFirstOpenState();
}

class _CheckFirstOpenState extends State<CheckFirstOpen> {
  bool? _isFirstOpen;

  @override
  void initState() {
    super.initState();
    _checkIfFirstOpen();
  }

  void _checkIfFirstOpen() async {
    final prefs = await SharedPreferences.getInstance();
    // Verifica se a chave 'hasSeenWelcome' existe
    final hasSeenWelcome = prefs.getBool('hasSeenWelcome') ?? false;

    setState(() {
      // Se for false (o padrão se for a primeira vez), a tela inicial é Boas-Vindas.
      _isFirstOpen = !hasSeenWelcome;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstOpen == null) {
      // Exibe um loading enquanto a verificação é feita
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isFirstOpen == true) {
      // Se for a primeira vez, mostra a tela de Boas-Vindas.
      return const BoasVindasTela(); // Assumindo que a classe é BoasVindasTela
    } else {
      // Caso contrário, usa o fluxo de autenticação padrão (AuthCheck).
      return AuthCheck();
    }
  }
}