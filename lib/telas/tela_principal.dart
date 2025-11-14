// lib/telas/tela_principal.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:meu_primeiro_app/models/categorias.dart';
import 'package:meu_primeiro_app/models/usuarios.dart'; 
import 'package:meu_primeiro_app/telas/detalhe_missao_tela.dart';
import 'package:meu_primeiro_app/services/auth_services.dart'; 
import 'package:meu_primeiro_app/services/user_data_service.dart'; 
import 'package:meu_primeiro_app/services/mission_service.dart';
import 'package:provider/provider.dart'; 
import 'package:meu_primeiro_app/telas/tela_login.dart'; 

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({Key? key}) : super(key: key);

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  DetailedMissionModel? _currentMission;
  List<DetailedMissionModel> _availableMissions = []; 
  bool _isMissionsLoading = true; 
  final _random = Random();
  
  // RESTAURADO: Variável de estado para o BottomNavigationBar
  int _selectedIndex = 0;

  // Serviços
  late UserDataService _userDataService;
  late MissionService _missionService;

  @override
  void initState() {
    super.initState();
    _currentMission = null; 
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isMissionsLoading) {
      _userDataService = Provider.of<UserDataService>(context, listen: false);
      _missionService = Provider.of<MissionService>(context, listen: false);
      _loadInitialMissions();
    }
  }

  void _loadInitialMissions() async {
    final missions = await _missionService.getMissions();
    setState(() {
      _availableMissions = missions;
      _isMissionsLoading = false;

      if (_availableMissions.isNotEmpty) {
        _currentMission = _availableMissions[_random.nextInt(_availableMissions.length)];
      } else {
        _currentMission = null;
      }
    });
  }

  void _sortearNovaMissao() {
    if (_availableMissions.isEmpty) return;

    final index = _random.nextInt(_availableMissions.length);
    setState(() {
      _currentMission = _availableMissions[index];
    });
  }

  // CORRIGIDO: Função de atualização do índice restaurada
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF3A6A4D);
    const Color lightGreenBackgroundColor = Color(0xFFE8F5E9);

    final authService = Provider.of<AuthService>(context);
    final String? uid = authService.usuario?.uid;
    
    if (_isMissionsLoading) {
      return const Scaffold(
        backgroundColor: primaryColor,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    
    if (_availableMissions.isEmpty || _currentMission == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Missões")),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              _availableMissions.isEmpty 
              ? "Nenhuma missão disponível. Verifique a coleção 'missoes' no Firestore."
              : "Erro ao sortear missão.", 
              textAlign: TextAlign.center,
              style: TextStyle(color: primaryColor, fontSize: 16)),
          ),
        ),
        backgroundColor: Colors.white,
      );
    }

    final currentMission = _currentMission!;

    return Scaffold(
      backgroundColor: primaryColor,
      
      appBar: AppBar(
        title: const Text(
          'Mais que Pixels', 
          style: TextStyle(fontFamily: 'MochiyPopOne', color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0, 
        automaticallyImplyLeading: false, 
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Sair',
            onPressed: () {
              authService.logout(); 
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Você foi desconectado.')),
              );
            },
          ),
        ],
      ),
      
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: primaryColor,
            expandedHeight: 200.0, 
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/header_tela_inicial.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: _buildHeader(uid), 
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: _buildDailyMissionCard(
                          lightGreenBackgroundColor,
                          authService, 
                          currentMission, 
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: _buildSectionTitle('Categorias'),
                      ),
                      const SizedBox(height: 15),
                      _buildCategories(),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: _buildSectionTitle('Desafios em Destaque'),
                      ),
                      const SizedBox(height: 15),
                      _buildFeaturedChallenges(authService), 
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // --- CABEÇALHO DINÂMICO COM BUSCA EM TEMPO REAL (STREAM) ---
  Widget _buildHeader(String? uid) {
    if (uid == null) {
      return _buildHeaderContent(
        greeting: 'Olá!', 
        subtitle: 'Faça login para salvar seu progresso.', 
        photoUrl: null,
      );
    }

    return StreamBuilder<Usuario?>(
      stream: _userDataService.getUserStream(uid),
      builder: (context, snapshot) {
        String greeting = 'Olá!';
        String subtitle = 'Carregando pontos...';
        String? photoUrl;

        if (snapshot.connectionState == ConnectionState.waiting) {
            subtitle = 'Carregando...';
        }
        else if (snapshot.hasData && snapshot.data != null) {
          final usuario = snapshot.data!;
          greeting = 'Olá, ${usuario.nome.split(' ').first}!';
          subtitle = 'Seus pontos: ${usuario.pontos}'; 
          photoUrl = usuario.photoUrl; 
        } else if (snapshot.hasError) {
          subtitle = 'Erro ao carregar dados.';
        }

        return _buildHeaderContent(
          greeting: greeting, 
          subtitle: subtitle, 
          photoUrl: photoUrl, 
        );
      },
    );
  }

  // Lógica de Layout do Header
  Widget _buildHeaderContent({
    required String greeting,
    required String subtitle,
    required String? photoUrl, 
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: const TextStyle(
                fontFamily: 'MochiyPopOne',
                fontSize: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        
        // CORREÇÃO: Usando o novo widget UserAvatar
      ],
    );
  }

  Widget _buildDailyMissionCard(
    Color backgroundColor,
    AuthService authService,
    DetailedMissionModel mission, 
  ) {
    return InkWell(
      onTap: () {
        if (authService.usuario == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Você precisa fazer login para iniciar esta missão!'),
              backgroundColor: Color(0xFF5E8C61),
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalheMissaoTela(missao: mission),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20.0),
      child: SizedBox(
        height: 290.0,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IgnorePointer(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC8E6C9),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              mission.categoryIcon,
                              size: 16,
                              color: Color(0xFF3A6A4D),
                            ),
                            SizedBox(width: 5),
                            Text(
                              mission.categoryTitle,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3A6A4D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Missão Diária',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mission.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD5E8D4),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        // CORREÇÃO: Usamos o ponto numérico da missão para formatar
                        '+${mission.points} pontos',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          color: Color(0xFF3A6A4D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _sortearNovaMissao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Sortear Missão',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'MochiyPopOne',
        fontSize: 24,
        color: Colors.white,
      ),
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: mockCategories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: _buildCategoryItem(category),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryItem(CategoryModel category) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: category.color,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Icon(category.icon, color: Colors.white, size: 30),
          const SizedBox(height: 8),
          Text(
            category.title,
            style: const TextStyle(
              fontFamily: 'Lato',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedChallenges(AuthService authService) {
    final featuredChallenges = _availableMissions.take(3).toList(); 

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: featuredChallenges.map((challenge) {
          final highlightModel = HighlightChallengeModel(
            title: challenge.title, 
            points: challenge.points, 
            color: Color(0xFF8AAE8A), 
          );

          return Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: _buildChallengeCard(highlightModel, authService, challenge),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChallengeCard(HighlightChallengeModel highlight, AuthService authService, DetailedMissionModel detailedMission) {
    return InkWell(
      onTap: () {
        if (authService.usuario == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Você precisa fazer login para acessar este desafio!'),
              backgroundColor: Color(0xFF5E8C61),
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
          );
          return;
        }
        
        // Navega para os detalhes usando a missão real
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalheMissaoTela(missao: detailedMission),
            ),
          );
      },
      borderRadius: BorderRadius.circular(15.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: 140.0,
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: highlight.color,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                highlight.title,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2, 
                overflow: TextOverflow.ellipsis, 
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD5E8D4),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    // Usa o getter formatado do HighlightModel
                    highlight.formattedPoints, 
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      color: Color(0xFF3A6A4D),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Estatísticas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Histórico',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Minhas Conexões',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.nights_stay),
              label: 'Modo foco',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF3A6A4D),
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Lato'),
        ),
      ),
    );
  }
}