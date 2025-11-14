// lib/services/mission_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_primeiro_app/models/categorias.dart';

class MissionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Referência à coleção de missões
  // Certifique-se de que 'missoes' está escrito EXATAMENTE como no seu Firestore
  late final CollectionReference _missionCollection = 
      _firestore.collection('missoes');

  // Método para buscar todas as missões dinâmicas do Firestore
  Future<List<DetailedMissionModel>> getMissions() async {
    try {
      final snapshot = await _missionCollection.get();
      
      if (snapshot.docs.isEmpty) {
        print("INFO: Nenhum documento encontrado na coleção 'missoes'.");
        return [];
      }

      List<DetailedMissionModel> loadedMissions = [];

      // Iteramos sobre cada documento e usamos try-catch individual
      for (var doc in snapshot.docs) {
        try {
          final mission = DetailedMissionModel.fromFirestore(
            doc.data() as Map<String, dynamic>,
          );
          loadedMissions.add(mission);
        } catch (e) {
          // 💥 LOG CRÍTICO 💥
          // Se um documento falhar na conversão, logamos o erro e o pulamos.
          print("-----------------------------------------------------");
          print("ERRO CRÍTICO de Conversão (DetailedMissionModel.fromFirestore):");
          print("Documento ID que falhou: ${doc.id}");
          print("Erro: $e");
          print("DADOS BRUTOS do Documento (Verifique os tipos e chaves): ${doc.data()}"); 
          print("-----------------------------------------------------");
        }
      }

      // Retorna APENAS as missões que foram carregadas com sucesso
      print("INFO: ${loadedMissions.length} missões carregadas com sucesso.");
      return loadedMissions;
      
    } catch (e) {
      // Este catch só será ativado se a conexão com o Firestore falhar (rede, permissões de leitura).
      print("Erro FATAL (Conexão ou Permissão) ao buscar o snapshot da coleção 'missoes': $e");
      return []; 
    }
  }

  // Você pode adicionar um método para salvar missões aqui, se necessário.
}