// lib/services/auth_services.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Classe de exceção personalizada
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? usuario;
  bool isloading = true;

  AuthService() {
    _authCheck();
  }

  // ============================================================
  // 1) Monitoramento do estado de autenticação
  // ============================================================
  void _authCheck() {
    _auth.authStateChanges().listen((User? user) async {
      usuario = user;
      isloading = false;
      notifyListeners();

      if (usuario != null) {
        await _checkUserDocument(); // 🔥 auto-logout se doc não existir
      }
    });
  }

  // Força atualização do usuário local
  void _getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
  }

  // ============================================================
  // 2) Verificar se documento no Firestore ainda existe
  // ============================================================
  Future<void> _checkUserDocument() async {
    if (usuario == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuario!.uid)
        .get();

    if (!doc.exists) {
      await logout(); // 🔥 desloga automaticamente
    }
  }

  // ============================================================
  // 3) Registrar novo usuário
  // ============================================================
  Future<void> registrar(String nome, String email, String senha) async {
    try {
      // Cria usuário no Authentication
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Cria documento no Firestore
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(cred.user!.uid)
          .set({
        'id': cred.user!.uid,
        'nome': nome,
        'email': email,
        'pontos': 0,
        'missoesConcluidas': 0,
        'criado_em': DateTime.now(),
      });

      _getUser();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Erro ao registrar');
    }
  }

  // ============================================================
  // 4) Login
  // ============================================================
  Future<void> login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      _getUser();
      await _checkUserDocument(); // 🔥 caso alguém apague o doc depois
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Email não encontrado. Cadastre-se!');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta. Tente novamente.');
      }
      throw AuthException(e.message ?? 'Erro ao fazer login');
    }
  }

  // ============================================================
  // 5) Logout
  // ============================================================
  Future<void> logout() async {
    await _auth.signOut();
    _getUser();
  }

  // ============================================================
  // 6) Reautenticação (NOVO MÉTODO PARA TELA DE PERFIL)
  // ============================================================
  // Necessário para operações sensíveis como mudar senha/email ou excluir conta.
  Future<void> reauthenticateUser(User user, String password) async {
    final AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
  }
}