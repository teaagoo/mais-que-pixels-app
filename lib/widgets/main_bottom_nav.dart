import 'package:flutter/material.dart';

// TELAS
import 'package:meu_primeiro_app/telas/tela_principal.dart';
import 'package:meu_primeiro_app/telas/tela_estatisticas.dart';
import 'package:meu_primeiro_app/telas/tela_historico.dart';
import 'package:meu_primeiro_app/telas/modo_foco_config.dart';

class MainBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const MainBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TelaPrincipal()),
      );
      return;
    }

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TelaEstatisticas()),
      );
      return;
    }

    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TelaHistorico()),
      );
      return;
    }

    if (index == 3) {
      // Tela Conexões ainda não criada
      return;
    }

    if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ModoFocoConfigTela()),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) => _onItemTapped(context, i),
      selectedItemColor: const Color(0xFF3A6A4D),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Estatísticas"),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "Histórico"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "Conexões"),
        BottomNavigationBarItem(icon: Icon(Icons.nights_stay), label: "Foco"),
      ],
    );
  }
}
