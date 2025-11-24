// lib/telas/tela_categorias.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:meu_primeiro_app/models/categorias.dart';
import 'package:meu_primeiro_app/models/missao.dart';

import 'package:meu_primeiro_app/services/auth_services.dart';
import 'package:meu_primeiro_app/services/user_data_service.dart';
import 'package:meu_primeiro_app/services/mission_service.dart';

import 'package:meu_primeiro_app/telas/detalhe_missao_tela.dart';

class TelaCategorias extends StatefulWidget {
  final String? initialCategory;

  const TelaCategorias({super.key, this.initialCategory});

  @override
  State<TelaCategorias> createState() => _TelaCategoriasState();
}

class _TelaCategoriasState extends State<TelaCategorias> {
  String categoriaSelecionada = mockCategories.first.title;

  bool loading = true;
  List<Missao> missoes = [];

  late MissionService missionService;
  late AuthService authService;
  late UserDataService userDataService;

  @override
  void initState() {
    super.initState();

    if (widget.initialCategory != null) {
      categoriaSelecionada = widget.initialCategory!;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _buscarMissoes());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    missionService = Provider.of<MissionService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    userDataService = Provider.of<UserDataService>(context, listen: false);
  }

  Future<void> _buscarMissoes() async {
    setState(() => loading = true);

    final result = await missionService.getMissionsByCategory(categoriaSelecionada);

    setState(() {
      missoes = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),

            const SizedBox(height: 10),
            _buildTitle(),

            const SizedBox(height: 15),
            _buildCategorySelector(),

            const SizedBox(height: 20),

            Expanded(child: _buildMissionList()),
          ],
        ),
      ),
    );
  }

  // ========================================
  // HEADER conectado ao Firestore
  // ========================================

  Widget _buildHeader() {
    final user = authService.usuario;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/perfil_analu.png'),
            radius: 25,
          ),

          const SizedBox(width: 12),

          if (user == null)
            const Text(
              "Carregando...",
              style: TextStyle(fontFamily: "MochiyPopOne", fontSize: 20),
            )
          else
            StreamBuilder(
              stream: userDataService.getUserStream(user.uid),
              builder: (context, snapshot) {
                String nome = "Olá!";
                String pontos = "...";

                if (snapshot.hasData) {
                  final dados = snapshot.data!;
                  nome = "Olá, ${dados.nome.split(' ').first}!";
                  pontos = "${dados.pontos} pontos";
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nome,
                      style: const TextStyle(
                        fontFamily: "MochiyPopOne",
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Vamos viver algo novo hoje?",
                      style: TextStyle(fontFamily: "Lato", color: Colors.black54),
                    ),
                  ],
                );
              },
            ),

          const Spacer(),

          StreamBuilder(
            stream: user == null ? null : userDataService.getUserStream(user.uid),
            builder: (context, snapshot) {
              String pontos = snapshot.hasData ? "${snapshot.data!.pontos}" : "...";

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 3),
                    )
                  ],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      "$pontos pts",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ========================================
  // TÍTULO
  // ========================================

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "Categorias",
        style: TextStyle(
          fontFamily: "MochiyPopOne",
          fontSize: 30,
          color: Color(0xFF3A6A4D),
        ),
      ),
    );
  }

  // ========================================
  // SELETOR DE CATEGORIAS
  // ========================================

  Widget _buildCategorySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: mockCategories.map((cat) {
          final selecionada = categoriaSelecionada == cat.title;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () async {
                setState(() => categoriaSelecionada = cat.title);
                await _buscarMissoes();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 120,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: selecionada
                      ? const Color(0xFF8AAE8A)
                      : const Color(0xFFC5D9C5),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: selecionada
                      ? [
                          BoxShadow(
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                            color: Colors.black.withOpacity(0.15),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  children: [
                    Icon(cat.icon, color: Colors.white, size: 30),
                    const SizedBox(height: 6),
                    Text(
                      cat.title,
                      style: const TextStyle(
                        fontFamily: "Lato",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ========================================
  // LISTA DE MISSÕES
  // ========================================

  Widget _buildMissionList() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (missoes.isEmpty) {
      return const Center(
        child: Text(
          "Nenhuma missão nessa categoria ainda.",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: missoes.length,
      itemBuilder: (context, i) {
        final m = missoes[i];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetalheMissaoTela(missao: m)),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.title,
                  style: const TextStyle(
                    fontFamily: "Lato",
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    m.difficulty ?? "Fácil",
                    style: const TextStyle(
                      fontFamily: "Lato",
                      color: Color(0xFF3A6A4D),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "+${m.points} pontos",
                    style: const TextStyle(
                      fontFamily: "Lato",
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
