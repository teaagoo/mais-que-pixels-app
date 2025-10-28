import 'package:flutter/material.dart';

// Esta classe define a estrutura de dados para cada item de categoria
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

// Lista de dados mockados (fictícios) para construir as categorias
const List<CategoryModel> mockCategories = [
  CategoryModel(title: 'Zen', icon: Icons.self_improvement, color: Color(0xFF98B586)),
  CategoryModel(title: 'Criatividade', icon: Icons.lightbulb, color: Color(0xFF98B586)),
  CategoryModel(title: 'Gentileza', icon: Icons.handshake, color: Color(0xFF98B586)),
  CategoryModel(title: 'Coragem', icon: Icons.flash_on, color: Color(0xFF98B586)),
];

// ----------------------------------------------------------------------

// Esta classe define a estrutura de dados para cada item de desafio em destaque
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

// Lista de dados mockados (fictícios) para construir os desafios em destaque
const List<HighlightChallengeModel> mockChallenges = [
  HighlightChallengeModel(title: 'Medite por 5 min', points: '+30 pontos', color: Color(0xFF98B586)),
  HighlightChallengeModel(title: 'Beba 3 litros de água', points: '+20 pontos', color: Color(0xFF98B586)),
  HighlightChallengeModel(title: 'Ligue para um amigo', points: '+50 pontos', color: Color(0xFF98B586)),
];
