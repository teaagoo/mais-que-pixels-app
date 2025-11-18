// lib/services/stats_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StatsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =====================================================
  // ====   1. TOTAL DE MISSÕES CONCLUÍDAS  ==============
  // =====================================================
  Future<int> getTotalMissoes(String uid) async {
    final historicoRef =
        _firestore.collection('usuarios').doc(uid).collection('historico');

    final snapshot = await historicoRef.get();

    return snapshot.docs.length;
  }

  // =====================================================
  // ====   2. PONTUAÇÃO TOTAL DO USUÁRIO  ================
  // =====================================================
  Future<int> getTotalPontos(String uid) async {
    final userDoc =
        await _firestore.collection('usuarios').doc(uid).get();

    if (!userDoc.exists) return 0;

    final data = userDoc.data() as Map<String, dynamic>;
    return data['pontos'] ?? 0;
  }

  // =====================================================
  // ====   3. PERCENTUAL POR CATEGORIA  ==================
  // =====================================================
  Future<Map<String, double>> getPercentualPorCategoria(
    String uid,
    List<String> categorias,
  ) async {
    final historicoRef =
        _firestore.collection('usuarios').doc(uid).collection('historico');

    final snapshot = await historicoRef.get();

    if (snapshot.docs.isEmpty) {
      return {for (var c in categorias) c: 0.0};
    }

    Map<String, int> contagem = {
      for (var c in categorias) c: 0,
    };

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final categoria = data['categoria'] ?? '';

      if (contagem.containsKey(categoria)) {
        contagem[categoria] = contagem[categoria]! + 1;
      }
    }

    final total = snapshot.docs.length.toDouble();

    return {
      for (var c in categorias)
        c: total > 0 ? (contagem[c]! / total) * 100 : 0.0,
    };
  }

  // =====================================================
  // ====   4. DIAS SEGUIDOS (STREAK)  ====================
  // =====================================================
  Future<int> getStreak(String uid) async {
    final historicoRef =
        _firestore.collection('usuarios').doc(uid).collection('historico');

    final snapshot = await historicoRef.get();

    if (snapshot.docs.isEmpty) return 0;

    List<DateTime> datas = snapshot.docs.map((d) {
      Timestamp t = d['data'];
      return DateTime(t.toDate().year, t.toDate().month, t.toDate().day);
    }).toList();

    datas = datas.toSet().toList();
    datas.sort((a, b) => b.compareTo(a));

    DateTime hoje = DateTime.now();
    DateTime ontem = hoje.subtract(const Duration(days: 1));

    if (!(datas.contains(hoje) || datas.contains(ontem))) {
      return 0;
    }

    DateTime diaAtual = datas.first;
    int streak = 1;

    for (int i = 1; i < datas.length; i++) {
      final proximoDia = datas[i];

      if (diaAtual.difference(proximoDia).inDays == 1) {
        streak++;
        diaAtual = proximoDia;
      } else {
        break;
      }
    }

    return streak;
  }

  // =====================================================
  // ====   5. RECORDE DE PONTOS EM UM ÚNICO DIA  =========
  // =====================================================
  Future<int> getRecordePontosDia(String uid) async {
    final historicoRef =
        _firestore.collection('usuarios').doc(uid).collection('historico');

    final snapshot = await historicoRef.get();

    if (snapshot.docs.isEmpty) return 0;

    Map<String, int> pontosPorDia = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final dynamic pontos = data['pontosGanhos'] ?? 0;

      // Garante que sempre vira int
      final int pontosInt = (pontos is num) ? pontos.toInt() : 0;

      final ts = (data['data'] as Timestamp).toDate();
      final String dia = DateFormat('yyyy-MM-dd').format(ts);

      pontosPorDia[dia] = (pontosPorDia[dia] ?? 0) + pontosInt;
    }

    return pontosPorDia.values.isEmpty
        ? 0
        : pontosPorDia.values.reduce((a, b) => a > b ? a : b);
  }

  // =====================================================
  // ====   6. CONQUISTAS DESBLOQUEADAS  ==================
  // =====================================================
  Future<List<Map<String, dynamic>>> getConquistas(String uid) async {
    final conquistasRef = _firestore
        .collection('usuarios')
        .doc(uid)
        .collection('conquistas');

    final snapshot = await conquistasRef.get();

    return snapshot.docs
        .map((d) => {
              'id': d.id,
              ...d.data(),
            })
        .toList();
  }
}
