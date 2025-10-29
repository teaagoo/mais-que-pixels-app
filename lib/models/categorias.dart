import 'package:flutter/material.dart';

// --- MODELO E DADOS DAS CATEGORIAS ---
class CategoryModel {
  final String title;
  final IconData icon;
  final Color color;

  const CategoryModel({
    required this.title,
    required this.icon,
    required this.color,
  });
}

const List<CategoryModel> mockCategories = [
  CategoryModel(title: 'Zen', icon: Icons.eco, color: Color(0xFF8AAE8A)),
  CategoryModel(title: 'Criatividade', icon: Icons.lightbulb_outline, color: Color(0xFF8AAE8A)),
  CategoryModel(title: 'Gentileza', icon: Icons.volunteer_activism, color: Color(0xFF8AAE8A)),
  CategoryModel(title: 'Coragem', icon: Icons.terrain, color: Color(0xFF8AAE8A)),
];

// --- MODELO E DADOS DOS DESAFIOS EM DESTAQUE ---
class HighlightChallengeModel {
  final String title;
  final String points;
  final Color color;

  const HighlightChallengeModel({
    required this.title,
    required this.points,
    required this.color,
  });
}

const List<HighlightChallengeModel> mockChallenges = [
  HighlightChallengeModel(title: 'Medite por 5 min', points: '+30 pontos', color: Color(0xFF8AAE8A)),
  HighlightChallengeModel(title: 'Beba 3 litros de água', points: '+20 pontos', color: Color(0xFF8AAE8A)),
  HighlightChallengeModel(title: 'Ligue para um amigo', points: '+50 pontos', color: Color(0xFF8AAE8A)),
];

// --- MODELO E DADOS DAS MISSÕES PARA SORTEIO ---
class MissionModel {
  final String title;
  final int points;
  final String categoryTitle;
  final IconData categoryIcon;

  const MissionModel({
    required this.title,
    required this.points,
    required this.categoryTitle,
    required this.categoryIcon,
  });
}

const List<MissionModel> mockMissions = [
  MissionModel(title: 'Visite um asilo ou casa de repouso', points: 50, categoryTitle: 'Gentileza', categoryIcon: Icons.volunteer_activism),
  MissionModel(title: 'Elogie um colega de trabalho sinceramente', points: 20, categoryTitle: 'Gentileza', categoryIcon: Icons.volunteer_activism),
  MissionModel(title: 'Passe 15 minutos desenhando ou escrevendo livremente', points: 30, categoryTitle: 'Criatividade', categoryIcon: Icons.lightbulb_outline),
  MissionModel(title: 'Tente uma receita nova para o jantar', points: 40, categoryTitle: 'Criatividade', categoryIcon: Icons.lightbulb_outline),
  MissionModel(title: 'Faça uma caminhada de 20 minutos em silêncio', points: 25, categoryTitle: 'Zen', categoryIcon: Icons.eco),
  MissionModel(title: 'Fale sobre um medo seu com alguém de confiança', points: 60, categoryTitle: 'Coragem', categoryIcon: Icons.terrain),
];

// --- MODELO E DADOS DETALHADOS DAS MISSÕES ---

enum MissionDifficulty { Facil, Medio, Dificil }

class DetailedMissionModel {
  final String title;
  final String description;
  final int points;
  final String categoryTitle;
  final IconData categoryIcon;
  final MissionDifficulty difficulty;
  final String time;
  final String imageAsset;

  const DetailedMissionModel({
    required this.title,
    required this.description,
    required this.points,
    required this.categoryTitle,
    required this.categoryIcon,
    required this.difficulty,
    required this.time,
    required this.imageAsset,
  });

  String get difficultyAsString {
    switch (difficulty) {
      case MissionDifficulty.Facil: return 'Fácil';
      case MissionDifficulty.Medio: return 'Médio';
      case MissionDifficulty.Dificil: return 'Difícil';
    }
  }
}

final List<DetailedMissionModel> mockDetailedMissions = [
  DetailedMissionModel(
    title: 'Visite um asilo ou casa de repouso',
    description:
        'A ideia é levar um pouco de alegria e atenção a quem precisa. Converse com os residentes, ouça suas histórias e compartilhe um momento de carinho e presença. Você pode levar um jogo de tabuleiro, ler um livro, ou simplesmente passar um tempo em boa companhia. Lembre-se de verificar as regras de visitação do local.',
    points: 50,
    categoryTitle: 'Gentileza',
    categoryIcon: Icons.volunteer_activism,
    difficulty: MissionDifficulty.Medio,
    time: '1 minuto (ou o tempo que puder dedicar)',
    imageAsset:
        'assets/illustrations/gentileza_missao.png', // Lembre-se de criar essa imagem
  ),
  // Adicione aqui as versões detalhadas das outras missões da lista mockMissions
  // para que o clique funcione para todas elas.
];