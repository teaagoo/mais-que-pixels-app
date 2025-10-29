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
  // Ícone de folha para 'Zen'
  CategoryModel(title: 'Zen', icon: Icons.eco, color: Color(0xFF8AAE8A)),
  // Ícone de lâmpada para 'Criatividade'
  CategoryModel(title: 'Criatividade', icon: Icons.lightbulb_outline, color: Color(0xFF8AAE8A)),
  // Ícone de mão com coração para 'Gentileza'
  CategoryModel(title: 'Gentileza', icon: Icons.volunteer_activism, color: Color(0xFF8AAE8A)),
  // Ícone de montanha para 'Coragem'
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
  // Você pode adicionar mais desafios aqui e eles aparecerão na lista!
];

// --- MODELO E DADOS DAS MISSÕES DIÁRIAS ---

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

// Lista de missões para o sorteio
const List<MissionModel> mockMissions = [
  MissionModel(
    title: 'Visite um asilo ou casa de repouso',
    points: 50,
    categoryTitle: 'Gentileza',
    categoryIcon: Icons.volunteer_activism,
  ),
  MissionModel(
    title: 'Elogie um colega de trabalho sinceramente',
    points: 20,
    categoryTitle: 'Gentileza',
    categoryIcon: Icons.volunteer_activism,
  ),
  MissionModel(
    title: 'Passe 15 minutos desenhando ou escrevendo livremente',
    points: 30,
    categoryTitle: 'Criatividade',
    categoryIcon: Icons.lightbulb_outline,
  ),
  MissionModel(
    title: 'Tente uma receita nova para o jantar',
    points: 40,
    categoryTitle: 'Criatividade',
    categoryIcon: Icons.lightbulb_outline,
  ),
  MissionModel(
    title: 'Faça uma caminhada de 20 minutos em silêncio',
    points: 25,
    categoryTitle: 'Zen',
    categoryIcon: Icons.eco,
  ),
  MissionModel(
    title: 'Fale sobre um medo seu com alguém de confiança',
    points: 60,
    categoryTitle: 'Coragem',
    categoryIcon: Icons.terrain,
  ),
];