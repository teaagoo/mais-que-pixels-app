import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meu_primeiro_app/models/categorias.dart';
import 'package:meu_primeiro_app/telas/missao_concluida_tela.dart';

class MissaoEmAndamentoTela extends StatefulWidget {
  final DetailedMissionModel missao;

  const MissaoEmAndamentoTela({Key? key, required this.missao}) : super(key: key);

  @override
  _MissaoEmAndamentoTelaState createState() => _MissaoEmAndamentoTelaState();
}

class _MissaoEmAndamentoTelaState extends State<MissaoEmAndamentoTela> {
  late Timer _timer;
  late Duration _remainingTime;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _remainingTime = _parseDuration(widget.missao.time);
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Duration _parseDuration(String timeString) {
    if (timeString.contains("1 minuto")) {
      return const Duration(minutes: 1); // Corrigido para 1 minuto real
    }
    if (timeString.contains("1 hora")) {
      return const Duration(hours: 1);
    }
    // Valor padrão caso não encontre (você pode ajustar)
    return const Duration(minutes: 1);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && mounted) {
        setState(() {
          if (_remainingTime.inSeconds > 0) {
            _remainingTime = _remainingTime - const Duration(seconds: 1);
          } else {
            _timer.cancel();
            // Evita erro de navegação durante o build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MissaoConcluidaTela(
                    pontosGanhos: widget.missao.points,
                  ),
                ),
              );
            });
          }
        });
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFE5EDE4);
    const Color accentColor = Color(0xFF98B586);
    const Color darkColor = Color(0xFF3A6A4D);

    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 125.0),
                  child: _buildMissionCard(accentColor),
                ),
                Image.asset(widget.missao.imageAsset, height: 250),
              ],
            ),
            const SizedBox(height: 30),
            _buildTimerDisplay(accentColor),
            const SizedBox(height: 20),
            _buildTimerControls(darkColor),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- MÉTODOS DE BUILD CORRIGIDOS ---

  Widget _buildTimerDisplay(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _formatDuration(_remainingTime),
        style: const TextStyle(
          fontFamily: 'MochiyPopOne',
          fontSize: 40,
          color: Color(0xFF3A6A4D),
        ),
      ),
    );
  }

  Widget _buildTimerControls(Color darkColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _togglePause,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: darkColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
              ),
              child: Text(
                _isPaused ? 'Retomar' : 'Dar uma pausa',
                style: const TextStyle(fontSize: 18, fontFamily: 'Lato', fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: darkColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
            ),
            child: const Text(
              'Abandonar',
              style: TextStyle(fontSize: 16, fontFamily: 'Lato'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
  return Padding(
    padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center, // Adicionado para melhor alinhamento vertical
      children: [
        // O Expanded vai aqui, envolvendo a Row interna para que ela seja flexível
        Expanded(
          child: Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage('assets/perfil_analu.png'),
              ),
              const SizedBox(width: 15),
              // E outro Expanded aqui dentro, para que a coluna de texto
              // ocupe todo o espaço restante disponível nesta Row interna
              Expanded(
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá, Analu!', 
                      style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold, fontSize: 20),
                      overflow: TextOverflow.ellipsis, // Evita que o nome quebre a linha
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Vamos viver algo novo hoje?', 
                      style: TextStyle(fontFamily: 'Lato', color: Colors.black54),
                      overflow: TextOverflow.ellipsis, // Adiciona "..." se o texto for muito grande
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // O Container dos pontos fica fora do Expanded, 
        // pois ele tem um tamanho fixo e queremos que ele fique à direita.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
            ],
          ),
          child: const Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber, size: 20),
              SizedBox(width: 5),
              Text('590 pontos', style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    ),
  );
}
  Widget _buildMissionCard(Color accentColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTag(widget.missao.categoryTitle, widget.missao.categoryIcon, accentColor),
              _buildTag(widget.missao.difficultyAsString, null, accentColor),
            ],
          ),
          const SizedBox(height: 20),
          // Removido o 'const' pois 'widget.missao.title' não é constante
          Text(
            widget.missao.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'MochiyPopOne', fontSize: 28, height: 1.2),
          ),
          const SizedBox(height: 15),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFD5E8D4),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                '+${widget.missao.points} pontos',
                style: const TextStyle(fontFamily: 'Lato', color: Color(0xFF3A6A4D), fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Text(
            widget.missao.description,
            style: const TextStyle(fontFamily: 'Lato', color: Colors.black54, fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.black54, size: 20),
              const SizedBox(width: 8),
              Text(
                widget.missao.time,
                style: const TextStyle(fontFamily: 'Lato', color: Colors.black54, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, IconData? icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: Colors.white, size: 16),
          if (icon != null) const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontFamily: 'Lato', fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}