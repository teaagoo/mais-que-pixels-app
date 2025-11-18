// lib/telas/modo_foco_em_andamento.dart
import 'dart:async';
import 'package:flutter/material.dart';

class ModoFocoEmAndamentoTela extends StatefulWidget {
  final int durationMinutes;
  const ModoFocoEmAndamentoTela({Key? key, required this.durationMinutes}) : super(key: key);

  @override
  _ModoFocoEmAndamentoTelaState createState() => _ModoFocoEmAndamentoTelaState();
}

class _ModoFocoEmAndamentoTelaState extends State<ModoFocoEmAndamentoTela> with WidgetsBindingObserver {
  late Duration _initialDuration;
  late Duration _remaining;
  Timer? _timer;
  bool _isPaused = false;

  // Palette
  static const Color deepBlue = Color(0xFF0A0F1F);
  static const Color deepPurple = Color(0xFF1A1433);
  static const Color lightGray = Color(0xFFEDEDED);
  static const Color gold = Color(0xFFF5D76E);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialDuration = Duration(minutes: widget.durationMinutes);
    _remaining = _initialDuration;
    _startTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  // Detect app lifecycle to restart timer if user leaves
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Quando o app vai para background (user saiu)
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // restart timer as requirement: timer is reset
      _timer?.cancel();
      setState(() {
        _remaining = _initialDuration;
        _isPaused = false;
      });

      // show a brief message if context mounted
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('O timer foi reiniciado porque você saiu do app.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _isPaused = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isPaused) {
        setState(() {
          if (_remaining.inSeconds > 0) {
            _remaining = _remaining - const Duration(seconds: 1);
          } else {
            _timer?.cancel();
            // Quando terminar, mostra um snackbar e volta (ou abre modal)
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sessão concluída! Bom trabalho ✨'), duration: Duration(seconds: 2)),
              );
            }
            // voltar para primeira tela
            Future.delayed(const Duration(milliseconds: 600), () {
              if (mounted) Navigator.popUntil(context, (r) => r.isFirst);
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

  void _abandonar() {
    _timer?.cancel();
    Navigator.popUntil(context, (r) => r.isFirst);
  }

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = two(d.inHours);
    final m = two(d.inMinutes.remainder(60));
    final s = two(d.inSeconds.remainder(60));
    // Se horas for "00", pode optar por mostrar só MM:SS; manter padrão HH:MM:SS aqui
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepBlue,
      appBar: AppBar(
        backgroundColor: deepBlue,
        elevation: 0,
        title: const Text('Modo Foco', style: TextStyle(fontFamily: 'MochiyPopOne', color: Colors.white)),
        centerTitle: true,
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
                Icon(Icons.emoji_events, color: gold, size: 18),
                SizedBox(width: 6),
                Text('590', style: TextStyle(color: gold, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Circular illustration
            Center(
              child: Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B2740), Color(0xFF221733)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.45), blurRadius: 18, offset: Offset(0, 8))],
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.self_improvement, size: 76, color: Color(0xFFEDEDED)),
                      SizedBox(height: 8),
                      Text('Respire • Foque', style: TextStyle(color: Color(0xFFBFC7D6), fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // TIMER DISPLAY
            Text(
              _format(_remaining),
              style: const TextStyle(
                fontFamily: 'MochiyPopOne',
                fontSize: 44,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 20),

            // CONTROLS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _togglePause,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lightGray,
                        foregroundColor: deepBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                      child: Text(_isPaused ? 'Retomar' : 'Dar uma pausa', style: const TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _abandonar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      child: const Text('Abandonar', style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // decorative leaves bottom-right (subtle)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 18.0, bottom: 18.0),
                child: Opacity(
                  opacity: 0.18,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: Icon(Icons.local_florist, size: 60, color: const Color(0xFF101428)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: deepPurple,
        selectedItemColor: gold,
        unselectedItemColor: Colors.white54,
        currentIndex: 4,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Estatísticas'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histórico'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Conexões'),
          BottomNavigationBarItem(icon: Icon(Icons.nights_stay), label: 'Modo Foco'),
        ],
        onTap: (i) {},
      ),
    );
  }
}
