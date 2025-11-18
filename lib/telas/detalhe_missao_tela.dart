// lib/telas/detalhe_missao_tela.dart

import 'package:flutter/material.dart';
import 'package:meu_primeiro_app/models/missao.dart';
import 'package:meu_primeiro_app/telas/missao_em_andamento_tela.dart';
import 'package:meu_primeiro_app/services/auth_services.dart';
import 'package:meu_primeiro_app/services/user_data_service.dart';
import 'package:meu_primeiro_app/models/usuarios.dart';
import 'package:provider/provider.dart';

class DetalheMissaoTela extends StatelessWidget {
  final Missao missao;

  const DetalheMissaoTela({Key? key, required this.missao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFE5EDE4);
    const Color accentColor = Color(0xFF98B586);

    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 125.0),
                  child: _buildMissionCard(accentColor),
                ),

                // imagem
                if (missao.imageAsset.isNotEmpty)
                  Image.asset(missao.imageAsset, height: 250)
                else
                  const SizedBox(height: 250),
              ],
            ),
            const SizedBox(height: 20),
            _buildActionButtons(context, accentColor),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // CABEÇALHO COM NOME E PONTOS DO USUÁRIO
  // ================================================================
  Widget _buildHeader(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userDataService = UserDataService();
    final String? uid = authService.usuario?.uid;

    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 10),
      child: FutureBuilder<Usuario?>(
        future: uid != null ? userDataService.getUserData(uid) : Future.value(null),
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

  // ================================================================
  // BOTÕES
  // ================================================================
  Widget _buildActionButtons(BuildContext context, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MissaoEmAndamentoTela(missao: missao),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Aceitar Missão',
                style: TextStyle(fontSize: 18, fontFamily: 'Lato', fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.grey[700],
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
            ),
            child: const Text(
              'Pular Missão',
              style: TextStyle(fontSize: 16, fontFamily: 'Lato'),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // CARD DA MISSÃO: categoria, dificuldade, título, descrição, tempo
  // ================================================================
  Widget _buildMissionCard(Color accentColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTag(_formatCategoryLabel(missao.categoryId), null, accentColor),
              _buildTag(missao.difficulty, null, accentColor),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            missao.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'MochiyPopOne', fontSize: 28, height: 1.2),
          ),
          const SizedBox(height: 15),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFD5E8D4),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                '+${missao.points} pontos',
                style: const TextStyle(fontFamily: 'Lato', color: Color(0xFF3A6A4D), fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Text(
            missao.description,
            style: const TextStyle(fontFamily: 'Lato', color: Colors.black54, fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.black54, size: 20),
              const SizedBox(width: 8),
              Text(
                missao.time,
                style: const TextStyle(fontFamily: 'Lato', color: Colors.black54, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, IconData? icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: Colors.white, size: 16),
          if (icon != null) const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontFamily: 'Lato', fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _formatCategoryLabel(String categoryId) {
    if (categoryId.isEmpty) return "";
    return categoryId[0].toUpperCase() + categoryId.substring(1);
  }
}
