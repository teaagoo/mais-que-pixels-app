// lib/telas/modo_foco_config.dart
import 'package:flutter/material.dart';
import 'modo_foco_em_andamento.dart';

class ModoFocoConfigTela extends StatefulWidget {
  const ModoFocoConfigTela({Key? key}) : super(key: key);

  @override
  _ModoFocoConfigTelaState createState() => _ModoFocoConfigTelaState();
}

class _ModoFocoConfigTelaState extends State<ModoFocoConfigTela> {
  // Durations in minutes available
  final List<int> _options = [15, 30, 40, 60];
  int _selected = 30;

  // Colors (paleta solicitada)
  static const Color deepBlue = Color(0xFF0A0F1F);
  static const Color deepPurple = Color(0xFF1A1433);
  static const Color lightGray = Color(0xFFEDEDED);
  static const Color mutedGray = Color(0xFFCFCFCF);
  static const Color gold = Color(0xFFF5D76E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepBlue,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 6),
              _buildTitle(),
              const SizedBox(height: 12),
              _buildIntro(),
              const SizedBox(height: 24),
              _buildGridOptions(),
              const Spacer(),
              _buildStartButton(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: deepBlue,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      title: Row(
        children: [
          // Avatar + greeting
          const CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage('assets/perfil_analu.png'), // keep if exists
            // fallback handled by showing a default if asset missing
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Olá, Analu!', style: TextStyle(fontFamily: 'Lato', fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700)),
              SizedBox(height: 2),
              Text('Vamos viver algo novo hoje?', style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFFB9C0CE))),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 14),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: deepPurple,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: const [
              Icon(Icons.emoji_events, color: Color(0xFFF5D76E), size: 18),
              SizedBox(width: 6),
              Text('590', style: TextStyle(color: Color(0xFFF5D76E), fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTitle() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Modo Foco',
        style: TextStyle(
          fontFamily: 'MochiyPopOne',
          fontSize: 34,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Focar nem sempre é fácil. Com o Modo Foco você define sessões curtas para manter a produtividade e o bem-estar.',
          style: TextStyle(color: Color(0xFFCFCFCF), fontSize: 14, height: 1.5),
        ),
        const SizedBox(height: 10),
        Row(
          children: const [
            Text('⚠️ ', style: TextStyle(fontSize: 16)),
            Expanded(
              child: Text(
                'Atenção: se você sair do aplicativo para redes sociais, o timer será reiniciado automaticamente.',
                style: TextStyle(color: Color(0xFFEDEDED), fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGridOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.4,
        physics: const NeverScrollableScrollPhysics(),
        children: _options.map((m) => _timeOption(m)).toList(),
      ),
    );
  }

  Widget _timeOption(int minutes) {
    final bool isSelected = minutes == _selected;
    return GestureDetector(
      onTap: () => setState(() => _selected = minutes),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: isSelected ? lightGray : deepPurple,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected
              ? [
                  BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 6)),
                ]
              : null,
          border: Border.all(color: isSelected ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.03)),
        ),
        child: Center(
          child: Text(
            '$minutes min',
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 18,
              color: isSelected ? deepBlue : Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 420),
            pageBuilder: (context, a1, a2) => ModoFocoEmAndamentoTela(durationMinutes: _selected),
            transitionsBuilder: (context, a1, a2, child) {
              return FadeTransition(opacity: a1, child: child);
            },
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: lightGray,
        foregroundColor: deepBlue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 6,
      ),
      child: const Center(
        child: Text('Vamos começar!', style: TextStyle(fontFamily: 'Lato', fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: deepPurple,
      selectedItemColor: gold,
      unselectedItemColor: Colors.white54,
      currentIndex: 4, // modo foco ativo
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Estatísticas'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histórico'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Conexões'),
        BottomNavigationBarItem(icon: Icon(Icons.nights_stay), label: 'Modo Foco'),
      ],
      onTap: (index) {
        // navegação do app principal pode ser integrada aqui
      },
    );
  }
}
