// lib/services/user_data_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_primeiro_app/models/usuarios.dart';

class UserDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Inicialização segura da referência da coleção
  late final CollectionReference _usersCollection =
      _firestore.collection('usuarios');

  // 1. LER DADOS EM TEMPO REAL (usado na TelaPrincipal e PerfilTela)
  Stream<Usuario?> getUserStream(String uid) {
    return _usersCollection.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }
      // Conversão do Mapa do Firestore para o objeto Usuario
      return Usuario.fromFirestore(
          snapshot.data() as Map<String, dynamic>, uid); 
    });
  }
  
  // 2. LER DADOS ÚNICA VEZ (usado no initState da PerfilTela)
  Future<Usuario?> getUserData(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return Usuario.fromFirestore(doc.data() as Map<String, dynamic>, uid); 
    }
    return null;
  }
  
  // 3. ATUALIZAR PROGRESSO DE MISSÃO (usado na MissaoConcluidaTela)
  Future<void> updateMissionCompletion(String uid, int points) async {
    await _usersCollection.doc(uid).update({
      'pontos': FieldValue.increment(points), 
      'missoesConcluídas': FieldValue.increment(1),
    });
  }

  // 4. ATUALIZAR PERFIL (usado na PerfilTela) - Para atualizar nome e outros campos
  Future<void> updateProfile(String uid, String nome, String? photoUrl) async {
    await _usersCollection.doc(uid).update({
      'nome': nome,
      // Salva null no Firestore se a string for vazia
      'photoUrl': photoUrl, 
    });
  }

  // 5. NOVO: ATUALIZAR APENAS A FOTO DE PERFIL - Usado após o upload para o Storage
  Future<void> updateProfilePhotoUrl(String uid, String photoUrl) async {
    await _usersCollection.doc(uid).update({
      'photoUrl': photoUrl, 
    });
  }
}