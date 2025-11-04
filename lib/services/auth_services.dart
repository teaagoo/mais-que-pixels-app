import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthException implements Exception{
  String message;
  AuthException (this.message);
}

class AuthService extends ChangeNotifier{
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario; 
  bool isloading = true;

  AuthService(){
    _authCheck();
  }

  _authCheck(){
    _auth.authStateChanges().listen((User? user){
      usuario = (user == null) ? null: user;
      isloading = false;
      notifyListeners();
    });
  }

  _getUser(){
    usuario = _auth.currentUser;
    notifyListeners();
  }

 Future<void> registrar(String nome, String email, String senha) async {
  try {
    // cria o usuário no Firebase Authentication
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );

    // gera o ID automaticamente e salva dados adicionais no Firestore
    await FirebaseFirestore.instance.collection('usuarios').doc(cred.user!.uid).set({
      'id': cred.user!.uid,
      'nome': nome,
      'email': email,
      'criado_em': DateTime.now(),
    });
  } on FirebaseAuthException catch (e) {
    throw AuthException(e.message ?? 'Erro ao registrar');
  }
}


  login(String email, String senha) async {
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();

    }on FirebaseAuthException catch (e){
        if(e.code =='user-not-found'){
          throw AuthException('Email não encontrado. Cadastre-se');
        }else if(e.code == 'wrong-password'){
            throw AuthException('Senha Incorreta. Tente Novamente');
        }
    }
  }


  logout() async{
    await _auth.signOut();
    _getUser();
  }
}