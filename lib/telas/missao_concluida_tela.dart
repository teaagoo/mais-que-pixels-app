// lib/telas/missao_concluida_tela.dart

import 'package:flutter/material.dart';
import 'package:meu_primeiro_app/models/categorias.dart'; 
import 'package:meu_primeiro_app/services/auth_services.dart'; 
import 'package:meu_primeiro_app/services/user_data_service.dart'; 
import 'package:meu_primeiro_app/models/usuarios.dart'; 
import 'package:provider/provider.dart';

class MissaoConcluidaTela extends StatelessWidget {
  // REMOVIDO o 'const' do construtor
  final DetailedMissionModel missao; 
  final UserDataService _userDataService = UserDataService();

  // Construtor Corrigido
  MissaoConcluidaTela({Key? key, required this.missao}) : super(key: key);

  // --- LÓGICA DE ATUALIZAÇÃO DO FIRESTORE ---
  void _concluirMissao(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final String? uid = authService.usuario?.uid;
    final int pontosGanhos = missao.points;

    if (uid != null) {
      try {
        // 1. CHAMA O SERVIÇO PARA INCREMENTAR PONTOS E MISSÕES CONCLUÍDAS NO FIRESTORE
        await _userDataService.updateMissionCompletion(uid, pontosGanhos);

        // 2. Feedback e navegação para a tela principal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 Missão Concluída! Você ganhou $pontosGanhos pontos!'),
            backgroundColor: const Color(0xFF3A6A4D),
            duration: const Duration(seconds: 3),
          ),
        );

        // Volta para a tela principal
        Navigator.popUntil(context, (route) => route.isFirst);

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao registrar missão no banco de dados.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  // ------------------------------------------

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFE5EDE4);
    const Color accentColor = Color(0xFF98B586);

    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Image.asset('assets/illustrations/missao_concluida.png', height: 250),
                  const SizedBox(height: 30),
                  _buildSuccessContent(context, accentColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- CABEÇALHO PADRONIZADO E DINÂMICO ---
  Widget _buildHeader(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final String? uid = authService.usuario?.uid;

    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 10),
      child: FutureBuilder<Usuario?>(
        future: uid != null ? _userDataService.getUserData(uid) : Future.value(null),
        builder: (context, snapshot) {
          final usuario = snapshot.data;
          
          String nome = 'Analu!';
          String pontos = '0 pontos';
          
          if (usuario != null) {
            nome = '${usuario.nome.split(' ').first}!';
            pontos = '${usuario.pontos} pontos';
          }
          
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage('assets/perfil_analu.png'),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Olá, $nome', 
                            style: const TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold, fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Vamos viver algo novo hoje?', 
                            style: TextStyle(fontFamily: 'Lato', color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                    const SizedBox(width: 5),
                    Text(pontos, style: const TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
  // --------------------------------------------------------------------------

  Widget _buildSuccessContent(BuildContext context, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          const Text(
            'Missão cumprida!',
            style: TextStyle(fontFamily: 'MochiyPopOne', fontSize: 32, color: Color(0xFF3A6A4D)),
          ),
          const SizedBox(height: 8),
          Text(
            'Parabéns por completar "${missao.title}"!',
            style: const TextStyle(fontFamily: 'Lato', fontSize: 18, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          
          // Card de Pontos Ganhos
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15),
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5)),
                  ]
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.emoji_events, color: Colors.amber, size: 30),
                    const SizedBox(width: 10),
                    Text(
                      '+${missao.points} pts',
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'PONTOS GANHOS',
                  style: TextStyle(color: Colors.white, fontFamily: 'Lato', fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 40),

          // Botão Finalizar - Chama a lógica de atualização no onPressed
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _concluirMissao(context), 
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Finalizar e Coletar Pontos',
                  style: TextStyle(fontSize: 18, fontFamily: 'Lato', fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}