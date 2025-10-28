import 'package:flutter/material.dart';
import 'package:meu_primeiro_app/models/categorias.dart'; // Importa nossos dados mockados

// -----------------------------------------------------
// 1. HOME SCREEN - WIDGET MUTÁVEL (STATEFUL)
// -----------------------------------------------------

// StatefulWidget é usado porque o estado da navegação (o índice da tela)
// precisa ser alterado quando o usuário clica na barra de navegação inferior.
class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  // Índice (endereço) da tela atualmente selecionada. 0 = Início.
  int _selectedIndex = 0;

  // Função chamada quando o usuário toca em um ícone da BottomNavigationBar
  void _onItemTapped(int index) {
    // setState é OBRIGATÓRIO para notificar o Flutter que o widget deve ser redesenhado.
    setState(() {
      _selectedIndex = index;
    });
    // FUTURO: Aqui você implementará a lógica para trocar a tela real exibida.
    debugPrint('Item de navegação selecionado: $index');
  }

  // Lista de widgets (telas) que serão exibidas. Por enquanto, só a tela de Início (index 0).
  static final List<Widget> _widgetOptions = <Widget>[
    _HomeContent(), // Index 0: O conteúdo que vamos construir agora.
    const Center(child: Text('Estatísticas')), // Index 1
    const Center(child: Text('Histórico')), // Index 2
    const Center(child: Text('Minhas Conexões')), // Index 3
    const Center(child: Text('Modo Foco')), // Index 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Exibe a tela correspondente ao índice selecionado
      body: _widgetOptions.elementAt(_selectedIndex),

      // -----------------------------------------------------
      // BARRA DE NAVEGAÇÃO INFERIOR (BOTTOM NAVIGATION BAR)
      // -----------------------------------------------------
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Estatísticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_toggle_off),
            activeIcon: Icon(Icons.history),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            activeIcon: Icon(Icons.people_alt),
            label: 'Conexões',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mode_night_outlined),
            activeIcon: Icon(Icons.mode_night),
            label: 'Foco',
          ),
        ],
        currentIndex: _selectedIndex, // Qual item está ativo
        selectedItemColor: const Color(
          0xFF558B55,
        ), // Cor de destaque do item ativo
        unselectedItemColor: Colors.grey, // Cor dos itens inativos
        onTap: _onItemTapped, // Função chamada ao clicar
        type: BottomNavigationBarType
            .fixed, // Garante que todos os itens apareçam
        backgroundColor: Colors.white,
      ),
    );
  }
}

// -----------------------------------------------------
// 2. CONTEÚDO REAL DA TELA DE INÍCIO (O QUE SERÁ ROLADO)
// -----------------------------------------------------

class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SingleChildScrollView: Permite a rolagem vertical de toda a tela
    return SingleChildScrollView(
      // Column organiza todos os elementos verticalmente
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // -------------------------------------------
          // A. CABEÇALHO (Imagem de Fundo + Perfil)
          // -------------------------------------------
          _buildHeader(context),

          // -------------------------------------------
          // B. MISSÃO DIÁRIA
          // -------------------------------------------
          _buildMissionCard(),

          // -------------------------------------------
          // C. TÍTULO CATEGORIAS
          // -------------------------------------------
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 25, bottom: 10),
            child: Text(
              'Categorias',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          // -------------------------------------------
          // D. LISTA DE CATEGORIAS (ROLAGEM HORIZONTAL)
          // -------------------------------------------
          _buildCategoryList(),

          // -------------------------------------------
          // E. TÍTULO DESAFIOS EM DESTAQUE
          // -------------------------------------------
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 25, bottom: 10),
            child: Text(
              'Desafios em Destaque',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          // -------------------------------------------
          // F. LISTA DE DESAFIOS (ROLAGEM HORIZONTAL)
          // -------------------------------------------
          _buildChallengeList(),

          // Espaço extra para garantir que a barra de navegação inferior não cubra o último item
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // -----------------------------------------------------
  // MÉTODOS DE CONSTRUÇÃO DE WIDGETS (FUNÇÕES AUXILIARES)
  // -----------------------------------------------------

  // Função para construir o cabeçalho (Imagem de Fundo + Olá, Analu!)
  Widget _buildHeader(BuildContext context) {
    // Stack usado para colocar o texto e o perfil por cima da imagem de fundo
    return Stack(
      children: [
        // Imagem de Fundo do topo (Mock: substitua por sua imagem real)
        Image.asset(
          'assets/header_tela_inicial.png', // Substitua pelo seu asset real
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
        ),

        // Coloca um container de cor sólida na parte inferior do header para a curva
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 50, // Altura da seção de cor sólida
            decoration: const BoxDecoration(
              color: Color(0xFF6B8E4C), // Cor verde do design
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
          ),
        ),

        // Conteúdo de boas-vindas e perfil
        Padding(
          padding: EdgeInsets.only(
            top:
                MediaQuery.of(context).padding.top +
                150, // Ajusta o topo para descer
            left: 20,
            right: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Texto de Boas-Vindas
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, Analu!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Vamos fazer uma missão hoje?',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),

              // Imagem de Perfil (Mock)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://placehold.co/50x50/cccccc/333333?text=A',
                    ), // Substitua por seu Asset
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Função para construir o cartão da Missão Diária
  Widget _buildMissionCard() {
    return Center(
      // Usando Transform.translate para subir o card e sobrepor o header
      child: Transform.translate(
        offset: const Offset(0, -35), // Move 35 pixels para cima
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Categoria da Missão
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.handshake, size: 16, color: Color(0xFF6B8E4C)),
                    SizedBox(width: 5),
                    Text(
                      'Gentileza',
                      style: TextStyle(color: Color(0xFF6B8E4C), fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Título e Pontos
              const Text(
                'Missão Diária',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                'Visite um asilo ou casa de repouso',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 5),
              const Text(
                '+50 Pontos',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),

              // Botão Sortear
              Center(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6B8E4C),
                    side: const BorderSide(color: Color(0xFF6B8E4C)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Sortear Missão'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para construir a Lista de Categorias (Horizontal)
  Widget _buildCategoryList() {
    // Container para dar uma altura fixa à lista horizontal
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Habilita a rolagem lateral!
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: mockCategories.length,
        itemBuilder: (context, index) {
          final category = mockCategories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            // Widget da Categoria (Ícone e Texto)
            child: _CategoryItem(category: category),
          );
        },
      ),
    );
  }

  // Função para construir a Lista de Desafios em Destaque (Horizontal)
  Widget _buildChallengeList() {
    return SizedBox(
      height: 150, // Altura fixa para os cards de desafio
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Rolagem lateral
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: mockChallenges.length,
        itemBuilder: (context, index) {
          final challenge = mockChallenges[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _ChallengeItem(challenge: challenge),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------
// 3. WIDGET AUXILIAR: ITEM DE CATEGORIA
// -----------------------------------------------------
class _CategoryItem extends StatelessWidget {
  final CategoryModel category;
  const _CategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: category.color.withOpacity(0.9), // Cor de fundo da categoria
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(category.icon, color: Colors.white, size: 30),
          const SizedBox(height: 5),
          Text(
            category.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------
// 4. WIDGET AUXILIAR: ITEM DE DESAFIO EM DESTAQUE
// -----------------------------------------------------
class _ChallengeItem extends StatelessWidget {
  final HighlightChallengeModel challenge;
  const _ChallengeItem({required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: challenge.color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título do Desafio
          Text(
            challenge.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(), // Empurra os pontos para baixo
          // Pontos
          Text(
            challenge.points,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
