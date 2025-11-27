// lib/telas/modo_foco_em_andamento.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_services.dart';
import 'tela_principal.dart';

// ⭐ MENU GLOBAL PADRONIZADO
import 'package:meu_primeiro_app/widgets/main_bottom_nav.dart';
import 'package:meu_primeiro_app/widgets/profile_button.dart'; // NOVO: Import do ProfileButton

class ModoFocoEmAndamentoTela extends StatefulWidget {
  final int durationMinutes;
  const ModoFocoEmAndamentoTela({Key? key, required this.durationMinutes})
      : super(key: key);

  @override
  State<ModoFocoEmAndamentoTela> createState() =>
      _ModoFocoEmAndamentoTelaState();
}

class _ModoFocoEmAndamentoTelaState extends State<ModoFocoEmAndamentoTela>
    with WidgetsBindingObserver {
  late Duration _initialDuration;
  late Duration _remaining;
  Timer? _timer;
  bool _isPaused = false;

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _timer?.cancel();
      setState(() {
        _remaining = _initialDuration;
        _isPaused = false;
      });

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
            _remaining -= const Duration(seconds: 1);
          } else {
            _timer?.cancel();

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Sessão concluída! Parabéns ✨"),
                  duration: Duration(seconds: 2),
                ),
              );
            }

            Future.delayed(const Duration(milliseconds: 700), () {
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TelaPrincipal(initialIndex: 4),
                  ),
                );
              }
            });
          }
        });
      }
    });
  }

  void _togglePause() {
    setState(() => _isPaused = !_isPaused);
  }

  void _abandonar() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TelaPrincipal(initialIndex: 4)),
    );
  }

  String _format(Duration d) {
    String two(n) => n.toString().padLeft(2, '0');
    return "${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}";
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF273C75),
            Color(0xFF4C5C99),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(auth),
        body: _buildBody(),

        // ⭐ MENU GLOBAL PADRONIZADO
        bottomNavigationBar: const MainBottomNavBar(currentIndex: 4),
      ),
    );
  }

  // ============================================================
  // APPBAR
  // ============================================================

  PreferredSizeWidget _buildAppBar(AuthService auth) {
    if (auth.usuario == null) {
      return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("Modo Foco",
            style: TextStyle(
                color: Colors.white, fontFamily: 'MochiyPopOne')),
      );
    }

    final doc = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(auth.usuario!.uid);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        "Modo Foco",
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'MochiyPopOne',
            fontSize: 22),
      ),
      leading: const ProfileButton(), // ⭐ ALTERAÇÃO: ProfileButton como leading

      actions: [
        StreamBuilder<DocumentSnapshot>(
          stream: doc.snapshots(),
          builder: (context, snapshot) {
            int pontos = 0;

            if (snapshot.hasData) {
              final data = snapshot.data!.data() as Map?;
              pontos = data?["pontos"] ?? 0;
            }

            return Container(
              margin: const EdgeInsets.only(right: 14),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events,
                      color: Colors.amber, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    "$pontos",
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }

  // ============================================================
  // CORPO — layout intacto
  // ============================================================

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 24),

          Center(
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF314B8A),
                    Color(0xFF232F52)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.self_improvement,
                        size: 70, color: Colors.white),
                    SizedBox(height: 8),
                    Text(
                      "Respire • Foque",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          Text(
            _format(_remaining),
            style: const TextStyle(
              fontFamily: 'MochiyPopOne',
              fontSize: 48,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _togglePause,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      _isPaused ? "Retomar" : "Dar uma pausa",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _abandonar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.25),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text(
                      "Abandonar",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          Opacity(
            opacity: 0.18,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 18, bottom: 18),
                child: Transform.rotate(
                  angle: -0.2,
                  child: const Icon(
                    Icons.local_florist,
                    size: 60,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}