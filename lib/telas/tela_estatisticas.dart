// lib/telas/tela_estatisticas.dart
// VERSÃO REVISADA COMPLETA – header conectado, ícones alinhados à TelaPrincipal,
// título "Estatísticas" acima dos cards, animações e painter inclusos.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:meu_primeiro_app/services/stats_service.dart';
import 'package:meu_primeiro_app/services/auth_services.dart';
import 'package:meu_primeiro_app/services/user_data_service.dart';
import 'package:meu_primeiro_app/models/usuarios.dart';
import 'tela_principal.dart';

class TelaEstatisticas extends StatefulWidget {
  const TelaEstatisticas({Key? key}) : super(key: key);

  @override
  State<TelaEstatisticas> createState() => _TelaEstatisticasState();
}

class _TelaEstatisticasState extends State<TelaEstatisticas>
    with SingleTickerProviderStateMixin {
  final StatsService _statsService = StatsService();

  Map<String, double> percentuais = {};
  int totalMissoes = 0;
  int streak = 0;
  int recorde = 0;
  List<Map<String, dynamic>> conquistas = [];

  bool carregando = true;

  // categorias
  final List<String> keys = ["zen", "coragem", "gentileza", "criatividade"];
  final List<String> nomes = ["Zen", "Coragem", "Gentileza", "Criatividade"];

  // cores das fatias (harmonia com TelaPrincipal)
  final List<Color> cores = [
    const Color(0xFF8AAE8A), // zen
    const Color(0xFFFF8A65), // coragem (tons usados no app)
    const Color(0xFFACD6A5), // gentileza
    const Color(0xFFBA68C8), // criatividade
  ];

  late AnimationController _ctrl;
  late Animation<double> _donutReveal;
  late Animation<double> _rotateAnim;
  late List<Animation<double>> _legendFadeAnims;
  late Animation<double> _cardsAnim;
  late List<Animation<double>> _conquistaAnims;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _donutReveal = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    );

    _rotateAnim = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.45, curve: Curves.easeOut)),
    );

    _cardsAnim = CurvedAnimation(parent: _ctrl, curve: const Interval(0.65, 1.0, curve: Curves.easeOut));

    _legendFadeAnims = List.generate(keys.length, (i) {
      final start = 0.35 + i * 0.06;
      final end = start + 0.18;
      return CurvedAnimation(parent: _ctrl, curve: Interval(start, end, curve: Curves.easeOut));
    });

    _conquistaAnims = List.generate(4, (i) {
      final start = 0.6 + i * 0.05;
      final end = start + 0.25;
      return CurvedAnimation(parent: _ctrl, curve: Interval(start, end, curve: Curves.easeOut));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarDados();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    setState(() => carregando = true);

    final auth = Provider.of<AuthService>(context, listen: false);
    final uid = auth.usuario?.uid;

    if (uid == null) {
      setState(() {
        percentuais = {for (var k in keys) k: 0.0};
        totalMissoes = 0;
        streak = 0;
        recorde = 0;
        conquistas = [];
        carregando = false;
      });
      _ctrl.reset();
      return;
    }

    try {
      final p = await _stats_serviceSafeGetPercent(uid);
      final t = await _statsService.getTotalMissoes(uid);
      final s = await _statsService.getStreak(uid);
      final r = await _statsService.getRecordePontosDia(uid);
      final c = await _statsService.getConquistas(uid);

      setState(() {
        percentuais = {for (var k in keys) k: (p[k] ?? 0).toDouble()};
        totalMissoes = t;
        streak = s;
        recorde = r;
        conquistas = List<Map<String, dynamic>>.from(c ?? []);
        carregando = false;
      });

      _ctrl.reset();
      await Future.delayed(const Duration(milliseconds: 40));
      _ctrl.forward();
    } catch (e) {
      // ignore: avoid_print
      print('Erro carregando estatísticas: $e');
      setState(() {
        percentuais = {for (var k in keys) k: 0.0};
        totalMissoes = 0;
        streak = 0;
        recorde = 0;
        conquistas = [];
        carregando = false;
      });
      _ctrl.reset();
    }
  }

  Future<Map<String, double>> _stats_serviceSafeGetPercent(String uid) async {
    try {
      return await _statsService.getPercentualPorCategoria(uid, keys);
    } catch (_) {
      return {for (var k in keys) k: 0.0};
    }
  }

  double _somaPercentuais() {
    double s = 0;
    for (var k in keys) s += (percentuais[k] ?? 0.0);
    return s;
  }

  // Ícones alinhados aos usados na TelaPrincipal
  IconData _iconPorCategoria(String key) {
    switch (key) {
      case 'zen':
        return Icons.spa; // small tweak to match look
      case 'coragem':
        return Icons.flash_on;
      case 'gentileza':
        return Icons.favorite;
      case 'criatividade':
        return Icons.brush;
      default:
        return Icons.flag;
    }
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFE5EDE4);
    const accent = Color(0xFF3A6A4D);

    final auth = Provider.of<AuthService>(context);
    final uid = auth.usuario?.uid;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: accent,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(radius: 18, backgroundImage: AssetImage('assets/perfil_analu.png')),
            const SizedBox(width: 12),

            // Nome e subtítulo
            Expanded(
              child: Consumer<UserDataService>(
                builder: (context, userData, child) {
                  if (uid == null) {
                    return const Text('Olá!', style: TextStyle(color: Colors.white));
                  }

                  return StreamBuilder<Usuario?>(
                    stream: userData.getUserStream(uid),
                    builder: (context, snap) {
                      String nome = 'Olá!';
                      if (snap.hasData) nome = 'Olá, ${snap.data!.nome.split(' ').first}!';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nome, style: const TextStyle(color: Colors.white, fontSize: 14)),
                          const SizedBox(height: 2),
                          const Text('Suas Estatísticas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            // Badge de pontos (stream)
            Consumer2<AuthService, UserDataService>(
              builder: (context, authS, userData, child) {
                if (uid == null) return _badgePontos('0');
                return StreamBuilder<Usuario?>(
                  stream: userData.getUserStream(uid),
                  builder: (context, snap) {
                    String pontos = snap.hasData ? snap.data!.pontos.toString() : '0';
                    return _badgePontos(pontos);
                  },
                );
              },
            ),
          ],
        ),
      ),

      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _carregarDados,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),

                    // TÍTULO PRINCIPAL
                    const Text(
                      'Seu Progresso',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF3A6A4D)),
                    ),

                    const SizedBox(height: 20),

                    // DONUT
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 220,
                            height: 220,
                            child: AnimatedBuilder(
                              animation: _ctrl,
                              builder: (context, child) {
                                final revealFactor = _donutReveal.value.clamp(0.0, 1.0);
                                final rotation = _rotateAnim.value;
                                final animatedMap = <String, double>{};
                                final total = _somaPercentuais();
                                if (total <= 0.0001) {
                                  for (var k in keys) animatedMap[k] = 0.0;
                                } else {
                                  for (var k in keys) {
                                    animatedMap[k] = (percentuais[k] ?? 0.0) * revealFactor;
                                  }
                                }

                                return Transform.rotate(
                                  angle: rotation,
                                  child: CustomPaint(
                                    painter: _DonutPainter(percentuais: animatedMap, colors: cores, keys: keys),
                                    child: Center(
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: background,
                                          shape: BoxShape.circle,
                                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.spa, size: 36, color: Color(0xFF3A6A4D)),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 12),

                          Wrap(
                            spacing: 12,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            children: List.generate(keys.length, (i) {
                              final k = keys[i];
                              final pct = (percentuais[k] ?? 0).toDouble();
                              final filled = _somaPercentuais() > 0;
                              final color = filled ? cores[i] : Colors.grey.shade400;

                              return FadeTransition(
                                opacity: _legendFadeAnims[i],
                                child: SlideTransition(
                                  position: Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(_legendFadeAnims[i]),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          radius: 14,
                                          backgroundColor: color,
                                          child: Icon(_iconPorCategoria(k), size: 16, color: Colors.white),
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(nomes[i], style: const TextStyle(fontWeight: FontWeight.bold)),
                                            TweenAnimationBuilder<double>(
                                              tween: Tween<double>(begin: 0, end: pct),
                                              duration: const Duration(milliseconds: 700),
                                              builder: (context, val, child) {
                                                return Text("${val.toStringAsFixed(0)}%", style: const TextStyle(fontSize: 12, color: Colors.black54));
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // CONQUISTAS
                    const Text('Suas Conquistas', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF3A6A4D))),
                    const SizedBox(height: 12),
                    _buildConquistasRowAnimated(),

                    const SizedBox(height: 26),

                    FadeTransition(
                      opacity: _cardsAnim,
                      child: SlideTransition(
                        position: Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(_cardsAnim),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título "Estatísticas" acima dos cards (solicitado)
                            const Padding(
                              padding: EdgeInsets.only(left: 4, bottom: 8),
                              child: Text('Estatísticas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3A6A4D))),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildCardWithIcon('Missões completas', '$totalMissoes', Icons.check_circle_outline),
                                _buildCardWithIcon('Ofensiva', '${streak} dias', Icons.whatshot),
                                _buildCardWithIcon('Recorde', '$recorde pts', Icons.emoji_events),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _badgePontos(String pontos) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: Color(0xFFF5D76E), size: 18),
          const SizedBox(width: 6),
          Text('$pontos pts', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildConquistasRowAnimated() {
    final items = conquistas.isEmpty ? _defaultConquistasPlaceholders() : conquistas;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Row(
        children: List.generate(items.length, (i) {
          final c = items[i];
          final titulo = c['titulo'] ?? 'Conquista';
          final desc = c['descricao'] ?? '';
          final ganhou = c['conquistado'] == true || c['unlocked'] == true;
          final bgColor = ganhou ? const Color(0xFFDFF6E9) : Colors.grey.shade200;
          final iconColor = ganhou ? const Color(0xFF3A6A4D) : Colors.grey;
          final borderColor = ganhou ? const Color(0xFF3A6A4D) : Colors.grey.shade300;

          return FadeTransition(
            opacity: _conquistaAnims[i % _conquistaAnims.length],
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0.06, 0), end: Offset.zero).animate(_conquistaAnims[i % _conquistaAnims.length]),
              child: Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(radius: 18, backgroundColor: iconColor, child: const Icon(Icons.emoji_events, color: Colors.white)),
                    const SizedBox(height: 10),
                    Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  List<Map<String, dynamic>> _defaultConquistasPlaceholders() {
    return [
      {'titulo': 'Semeador de Gentileza', 'descricao': 'Complete missões gentileza', 'conquistado': false},
      {'titulo': 'Explorador da Coragem', 'descricao': 'Complete missões coragem', 'conquistado': false},
      {'titulo': 'Guru da Criatividade', 'descricao': 'Complete missões criativas', 'conquistado': false},
      {'titulo': 'Mestre do Zen', 'descricao': 'Complete missões zen', 'conquistado': false},
    ];
  }

  Widget _buildCardWithIcon(String titulo, String valor, IconData icon) {
    return Container(
      width: (MediaQuery.of(context).size.width - 60) / 3,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFF3A6A4D)),
              const SizedBox(width: 8),
              Text(titulo, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(valor, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 1,
      onTap: (index) {
        if (index == 1) return;
        if (index == 4) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const TelaPrincipal(initialIndex: 4)));
          return;
        }
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TelaPrincipal(initialIndex: index)));
      },
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


/// Custom painter para o donut/pizza.
class _DonutPainter extends CustomPainter {
  final Map<String, double> percentuais;
  final List<Color> colors;
  final List<String> keys;

  _DonutPainter({required this.percentuais, required this.colors, required this.keys});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = size.width / 2;
    final ringWidth = radius * 0.34;

    final paintBg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth
      ..color = Colors.grey.shade300;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth
      ..strokeCap = StrokeCap.butt;

    final total = keys.fold<double>(0, (s, k) => s + (percentuais[k] ?? 0.0));

    if (total <= 0.0001) {
      canvas.drawCircle(center, radius - ringWidth / 2, paintBg);
      final innerPaint = Paint()..color = Colors.white;
      canvas.drawCircle(center, radius - ringWidth - 6, innerPaint);
      return;
    }

    double startRadian = -pi / 2;
    for (int i = 0; i < keys.length; i++) {
      final k = keys[i];
      final value = (percentuais[k] ?? 0.0).clamp(0.0, 100.0);
      final sweep = (value / total) * 2 * pi;
      paint.color = colors[i % colors.length];
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius - ringWidth / 2), startRadian, sweep, false, paint);
      startRadian += sweep;
    }

    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius - ringWidth - 6, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.percentuais != percentuais;
  }
}
