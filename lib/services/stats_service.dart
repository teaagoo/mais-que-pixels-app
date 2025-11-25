import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StatsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =====================================================
  // 1) TOTAL DE MISSÕES CONCLUÍDAS
  // =====================================================
  Future<int> getTotalMissoes(String uid) async {
    final historicoRef =
        _firestore.collection('usuarios').doc(uid).collection('historico');

    final snap = await historicoRef.get();
    return snap.docs.length;
  }

  // =====================================================
  // 2) PONTUAÇÃO TOTAL DO USUÁRIO
  // =====================================================
  Future<int> getTotalPontos(String uid) async {
    final doc = await _firestore.collection('usuarios').doc(uid).get();
    if (!doc.exists) return 0;

    final data = doc.data() as Map<String, dynamic>;
    final pontos = data['pontos'];

    if (pontos is num) return pontos.toInt();

    return int.tryParse(pontos.toString()) ?? 0;
  }

  // =====================================================
  // 3) PERCENTUAL POR CATEGORIA (CORRIGIDO + ROBUSTO)
  // =====================================================
  Future<Map<String, double>> getPercentualPorCategoria(
      String uid, List<String> categorias) async {
    final historicoRef =
        _firestore.collection('usuarios').doc(uid).collection('historico');

    final snap = await historicoRef.get();

    if (snap.docs.isEmpty) {
      return {for (var c in categorias) c: 0.0};
    }

    // contador
    Map<String, int> contagem = {for (var c in categorias) c: 0};
    int registrosValidos = 0;

    for (var doc in snap.docs) {
      final data = doc.data();

      // -----------------------------
      // CAPTURA DA CATEGORIA
      // -----------------------------
      String raw = "";

      if (data['categoria'] != null && data['categoria'].toString().trim().isNotEmpty) {
        raw = data['categoria'].toString();
      } else if (data['categoriaId'] != null) {
        raw = data['categoriaId'].toString();
      } else if (data['categoryId'] != null) {
        raw = data['categoryId'].toString();
      } else if (data['categoryTitle'] != null) {
        raw = data['categoryTitle'].toString();
      }

      raw = raw.trim().toLowerCase();

      // -----------------------------
      // IGNORA REGISTROS ANTIGOS INVÁLIDOS
      // -----------------------------
      if (raw.isEmpty) {
        continue;
      }

      final categoriaNorm = _normalize(raw);

      for (var cat in categorias) {
        if (_normalize(cat) == categoriaNorm) {
          contagem[cat] = contagem[cat]! + 1;
          registrosValidos++;
          break;
        }
      }
    }

    if (registrosValidos == 0) {
      return {for (var c in categorias) c: 0.0};
    }

    return {
      for (var c in categorias)
        c: (contagem[c]! / registrosValidos) * 100
    };
  }

  String _normalize(String s) {
    final t = s.trim().toLowerCase();

    return t
        .replaceAll("á", "a")
        .replaceAll("à", "a")
        .replaceAll("ã", "a")
        .replaceAll("â", "a")
        .replaceAll("é", "e")
        .replaceAll("ê", "e")
        .replaceAll("í", "i")
        .replaceAll("ó", "o")
        .replaceAll("ô", "o")
        .replaceAll("õ", "o")
        .replaceAll("ú", "u")
        .replaceAll("ç", "c");
  }

  // =====================================================
  // 4) DIAS SEGUIDOS (STREAK)
  // =====================================================
  Future<int> getStreak(String uid) async {
    final historicoRef =
        _firestore.collection('usuarios').doc(uid).collection('historico');

    final snap = await historicoRef.get();

    if (snap.docs.isEmpty) return 0;

    Set<DateTime> datas = {};

    for (var doc in snap.docs) {
      final data = doc.data();
      if (data['data'] == null) continue;

      try {
        final ts = data['data'] as Timestamp;
        final dt = ts.toDate();
        datas.add(DateTime(dt.year, dt.month, dt.day));
      } catch (_) {}
    }

    if (datas.isEmpty) return 0;

    final list = datas.toList()..sort((a, b) => b.compareTo(a));

    final now = DateTime.now();
    final hoje = DateTime(now.year, now.month, now.day);
    final ontem = hoje.subtract(const Duration(days: 1));

    if (!(datas.contains(hoje) || datas.contains(ontem))) return 0;

    int streak = 1;
    DateTime diaAtual = list.first;

    for (int i = 1; i < list.length; i++) {
      if (diaAtual.difference(list[i]).inDays == 1) {
        streak++;
        diaAtual = list[i];
      } else {
        break;
      }
    }

    return streak;
  }

  // =====================================================
  // 5) RECORDE DE PONTOS EM UM ÚNICO DIA
  // =====================================================
  Future<int> getRecordePontosDia(String uid) async {
    final historicoRef =
        _firestore.collection('usuarios').doc(uid).collection('historico');

    final snap = await historicoRef.get();
    if (snap.docs.isEmpty) return 0;

    Map<String, int> pontosPorDia = {};

    for (var doc in snap.docs) {
      final d = doc.data();
      if (d['data'] == null) continue;

      final ts = (d['data'] as Timestamp).toDate();
      final dia = DateFormat('yyyy-MM-dd').format(ts);

      final pontos = d['pontosGanhos'];
      final p = (pontos is num) ? pontos.toInt() : int.tryParse("$pontos") ?? 0;

      pontosPorDia[dia] = (pontosPorDia[dia] ?? 0) + p;
    }

    if (pontosPorDia.isEmpty) return 0;

    return pontosPorDia.values.reduce((a, b) => a > b ? a : b);
  }

  // =====================================================
  // 6) CONQUISTAS
  // =====================================================
  Future<List<Map<String, dynamic>>> getConquistas(String uid) async {
    final ref = _firestore
        .collection('usuarios')
        .doc(uid)
        .collection('conquistas');

    final snap = await ref.get();

    return snap.docs.map((d) => {"id": d.id, ...d.data()}).toList();
  }
}
