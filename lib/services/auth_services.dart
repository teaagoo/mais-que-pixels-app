// lib/services/auth_services.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Classe de exceção personalizada para lidar com erros de autenticação.
class AuthException implements Exception{
  String message;
  AuthException (this.message);
}

// Serviço principal de Autenticação e Notificação de Mudanças
class AuthService extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario; 
  bool isloading = true;

  AuthService(){
    _authCheck();
  }

  // Monitora o estado de autenticação (login/logout) do Firebase
  _authCheck(){
    _auth.authStateChanges().listen((User? user){
      usuario = (user == null) ? null: user;
      isloading = false;
      notifyListeners();
    });
  }

  // Atualiza a variável local 'usuario' com o usuário logado
  _getUser(){
    usuario = _auth.currentUser;
    notifyListeners();
  }

  // --- REGISTRO DE NOVO USUÁRIO ---
  Future<void> registrar(String nome, String email, String senha) async {
    try {
      // 1. Cria o usuário no Firebase Authentication
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // 2. Salva os dados adicionais no Firestore (Usando o UID como ID do documento)
      await FirebaseFirestore.instance.collection('usuarios').doc(cred.user!.uid).set({
        // O campo 'id' não é estritamente necessário se o UID for usado como chave,
        // mas mantemos para consistência.
        'id': cred.user!.uid, 
        'nome': nome,
        'email': email,
        'pontos': 0, // Dados iniciais de progresso!
        'missoesConcluidas': 0, // Dados iniciais de progresso!
        'criado_em': DateTime.now(),
      });
      _getUser(); // Atualiza o estado do usuário após o registro
    } on FirebaseAuthException catch (e) {
      // Trata erros comuns do Firebase Auth
      throw AuthException(e.message ?? 'Erro ao registrar');
    }
  }

  // --- LOGIN DE USUÁRIO ---
  login(String email, String senha) async {
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser(); // Atualiza o estado após o login

    }on FirebaseAuthException catch (e){
        if(e.code =='user-not-found'){
          throw AuthException('Email não encontrado. Cadastre-se');
        }else if(e.code == 'wrong-password'){
            throw AuthException('Senha Incorreta. Tente Novamente');
        }
        // Se for outro erro, lança uma exceção genérica
        throw AuthException(e.message ?? 'Erro ao fazer login');
    }
  }

  // --- LOGOUT DE USUÁRIO ---
  logout() async{
    await _auth.signOut();
    _getUser();
  }
}