// lib/telas/tela_estatisticas.dart

import 'package:flutter/material.dart';
import 'package:meu_primeiro_app/services/stats_service.dart';
import 'package:meu_primeiro_app/services/auth_services.dart';
import 'package:provider/provider.dart';

class TelaEstatisticas extends StatefulWidget {
  const TelaEstatisticas({Key? key}) : super(key: key);

  @override
  State<TelaEstatisticas> createState() => _TelaEstatisticasState();
}

class _TelaEstatisticasState extends State<TelaEstatisticas> {
  final StatsService _statsService = StatsService();

  Map<String, double> percentuais = {};
  int totalMissoes = 0;
  int streak = 0;
  int recorde = 0;
  List<Map<String, dynamic>> conquistas = [];

  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final uid = auth.usuario?.uid;

    if (uid == null) return;

    const categorias = [
      "zen",
      "coragem",
      "criatividade",
      "mentalidade"
    ];

    final p = await _statsService.getPercentualPorCategoria(uid, categorias);
    final t = await _statsService.getTotalMissoes(uid);
    final s = await _statsService.getStreak(uid);
    final r = await _statsService.getRecordePontosDia(uid);
    final c = await _statsService.getConquistas(uid);

    setState(() {
      percentuais = p;
      totalMissoes = t;
      streak = s;
      recorde = r;
      conquistas = c;
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFE5EDE4);
    const verde = Color(0xFF3A6A4D);

    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        title: const Text("Estatísticas", style: TextStyle(color: Colors.white)),
        backgroundColor: verde,
        elevation: 0,
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Seu Progresso",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: verde),
                  ),
                  const SizedBox(height: 20),

                  // ==================== GRÁFICO SIMPLES ====================
                  _buildCategoriasGrafico(),

                  const SizedBox(height: 30),

                  // ==================== CONQUISTAS ==========================
                  const Text(
                    "Conquistas",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: verde),
                  ),
                  const SizedBox(height: 10),
                  _buildConquistasLista(),

                  const SizedBox(height: 30),

                  // ==================== CARDS ESTATÍSTICAS ==================
                  _buildInfoCards(),
                ],
              ),
            ),
    );
  }

  // ==================== GRÁFICO SIMPLES ====================
  Widget _buildCategoriasGrafico() {
    const cores = [
      Color(0xFF8FBF8F),
      Color(0xFF7CAF7C),
      Color(0xFF6B9D6B),
      Color(0xFF5A8C5A),
    ];

    final nomes = ["Zen", "Coragem", "Criatividade", "Mentalidade"];
    final keys = ["zen", "coragem", "criatividade", "mentalidade"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(4, (i) {
        final pct = percentuais[keys[i]] ?? 0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${nomes[i]} - ${pct.toStringAsFixed(1)}%",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: pct / 100,
                  minHeight: 12,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(cores[i]),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ==================== CONQUISTAS ====================
  Widget _buildConquistasLista() {
    if (conquistas.isEmpty) {
      return const Text(
        "Nenhuma conquista desbloqueada ainda.",
        style: TextStyle(color: Colors.black54),
      );
    }

    return Column(
      children: conquistas.map((c) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 6),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  c['titulo'] ?? 'Conquista',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ==================== INFO CARDS ====================
  Widget _buildInfoCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCard("Missões", "$totalMissoes"),
        _buildCard("Ofensiva", "$streak dias"),
        _buildCard("Recorde", "$recorde pts"),
      ],
    );
  }

  Widget _buildCard(String titulo, String valor) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            valor,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
