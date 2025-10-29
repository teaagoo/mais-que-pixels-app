import 'dart:math';
import 'package:flutter/material.dart';
import 'package:meu_primeiro_app/models/categorias.dart';

// 1. IMPORTE A TELA DE DETALHES AQUI
import 'package:meu_primeiro_app/telas/detalhe_missao_tela.dart';


class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({Key? key}) : super(key: key);

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  late MissionModel _currentMission;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _currentMission = mockMissions[0];
  }

  void _sortearNovaMissao() {
    final index = _random.nextInt(mockMissions.length);
    setState(() {
      _currentMission = mockMissions[index];
    });
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF3A6A4D);
    const Color lightGreenBackgroundColor = Color(0xFFE8F5E9);

    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset('assets/header_tela_inicial.png', fit: BoxFit.cover),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 150),
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
                        child: _buildHeader(),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: _buildDailyMissionCard(lightGreenBackgroundColor),
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
                      _buildFeaturedChallenges(),
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

  // --- MÉTODO DO CARD DE MISSÃO MODIFICADO PARA SER CLICÁVEL ---
  Widget _buildDailyMissionCard(Color backgroundColor) {
    // 2. ENVOLVEMOS O SIZEDBOX COM O WIDGET INKWELL PARA TORNÁ-LO CLICÁVEL
    return InkWell(
      // 3. ADICIONAMOS A LÓGICA DE NAVEGAÇÃO NO ONTAP
      onTap: () {
        try {
          final detailedMission = mockDetailedMissions.firstWhere(
            (m) => m.title == _currentMission.title
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalheMissaoTela(missao: detailedMission),
            ),
          );
        } catch (e) {
          print("Erro: Não foi encontrada uma missão detalhada para '${_currentMission.title}'.");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Detalhes desta missão não encontrados!')),
          );
        }
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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC8E6C9),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_currentMission.categoryIcon, size: 16, color: Color(0xFF3A6A4D)),
                            SizedBox(width: 5),
                            Text(
                              _currentMission.categoryTitle,
                              style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold, color: Color(0xFF3A6A4D)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text('Missão Diária', style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87)),
                    const SizedBox(height: 8),
                    Text(
                      _currentMission.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Lato', fontSize: 16, color: Colors.black54, height: 1.4),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFFD5E8D4), borderRadius: BorderRadius.circular(15.0)),
                      child: Text(
                        '+${_currentMission.points} pontos',
                        style: TextStyle(fontFamily: 'Lato', color: Color(0xFF3A6A4D), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _sortearNovaMissao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      elevation: 4,
                    ),
                    child: const Text('Sortear Missão', style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- O RESTO DO SEU CÓDIGO CONTINUA IGUAL ---
  Widget _buildHeader() { return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [const Column(crossAxisAlignment: CrossAxisAlignment.start,children: [Text('Olá, Analu!', style: TextStyle(fontFamily: 'MochiyPopOne', fontSize: 28, color: Colors.white)),SizedBox(height: 4),Text('Vamos fazer uma missão hoje?', style: TextStyle(fontFamily: 'Lato', fontSize: 16, color: Colors.white)),],),const CircleAvatar(radius: 28,backgroundImage: AssetImage('assets/perfil_analu.png'),),],); }
  Widget _buildSectionTitle(String title) { return Text(title, style: const TextStyle(fontFamily: 'MochiyPopOne', fontSize: 24, color: Colors.white)); }
  Widget _buildCategories() { return SingleChildScrollView(scrollDirection: Axis.horizontal,padding: const EdgeInsets.symmetric(horizontal: 20.0),child: Row(children: mockCategories.map((category) {return Padding(padding: const EdgeInsets.only(right: 15.0),child: _buildCategoryItem(category),);}).toList(),),); }
  Widget _buildCategoryItem(CategoryModel category) { return Container(width: 100,padding: const EdgeInsets.symmetric(vertical: 15),decoration: BoxDecoration(color: category.color, borderRadius: BorderRadius.circular(15.0)),child: Column(children: [Icon(category.icon, color: Colors.white, size: 30),const SizedBox(height: 8),Text(category.title, style: const TextStyle(fontFamily: 'Lato', color: Colors.white, fontWeight: FontWeight.bold)),],),); }
  Widget _buildFeaturedChallenges() { return SingleChildScrollView(scrollDirection: Axis.horizontal,padding: const EdgeInsets.symmetric(horizontal: 20.0),child: Row(children: mockChallenges.map((challenge) {return Padding(padding: const EdgeInsets.only(right: 15.0),child: _buildChallengeCard(challenge),);}).toList(),),); }
  Widget _buildChallengeCard(HighlightChallengeModel challenge) { return SizedBox(width: MediaQuery.of(context).size.width * 0.5,child: Container(padding: const EdgeInsets.all(15.0),decoration: BoxDecoration(color: challenge.color, borderRadius: BorderRadius.circular(15.0)),child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text(challenge.title, style: const TextStyle(fontFamily: 'Lato', color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),const SizedBox(height: 20),Align(alignment: Alignment.bottomRight,child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),decoration: BoxDecoration(color: const Color(0xFFD5E8D4), borderRadius: BorderRadius.circular(12.0)),child: Text(challenge.points, style: const TextStyle(fontFamily: 'Lato', color: Color(0xFF3A6A4D), fontWeight: FontWeight.bold, fontSize: 12)),),)],),),); }
  Widget _buildBottomNavigationBar() { return Container(decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 10)],),child: ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),child: BottomNavigationBar(items: const <BottomNavigationBarItem>[BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Estatísticas'),BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histórico'),BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Minhas Conexões'),BottomNavigationBarItem(icon: Icon(Icons.nights_stay), label: 'Modo foco'),],currentIndex: _selectedIndex,selectedItemColor: const Color(0xFF3A6A4D),unselectedItemColor: Colors.grey,onTap: _onItemTapped,showUnselectedLabels: true,type: BottomNavigationBarType.fixed,selectedLabelStyle: const TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),unselectedLabelStyle: const TextStyle(fontFamily: 'Lato'),),),); }
}