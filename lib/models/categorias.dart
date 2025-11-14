// lib/models/categorias.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


// --- MODELO E DADOS DAS CATEGORIAS (FIXAS) ---
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
  CategoryModel(title: 'Zen', icon: Icons.spa, color: Color(0xFF8AAE8A)),
  CategoryModel(title: 'Criatividade', icon: Icons.lightbulb_outline, color: Color(0xFF8AAE8A)),
  CategoryModel(title: 'Gentileza', icon: Icons.volunteer_activism, color: Color(0xFF8AAE8A)),
  CategoryModel(title: 'Coragem', icon: Icons.terrain, color: Color(0xFF8AAE8A)),
];

// --- MODELO DOS DESAFIOS EM DESTAQUE (AJUSTADO PARA USAR INT) ---
class HighlightChallengeModel {
  final String title;
  final int points; 
  final Color color;

  const HighlightChallengeModel({
    required this.title,
    required this.points,
    required this.color,
  });
  
  // Getter para formatar os pontos (usado no _buildChallengeCard)
  String get formattedPoints => '+${points} pontos';
}

// --- MODELO BÁSICO DE MISSÃO PARA SORTEIO (MANTIDO) ---
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

// --- MODELO DETALHADO DA MISSÃO ---

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

  // Construtor para ler dados do Firestore (AGORA USANDO CASTS EXPLÍCITOS)
  factory DetailedMissionModel.fromFirestore(Map<String, dynamic> data) {
    
    // --- Funções Auxiliares ---
    MissionDifficulty _getDifficulty(String? diff) {
      if (diff == 'Médio') return MissionDifficulty.Medio;
      if (diff == 'Difícil') return MissionDifficulty.Dificil;
      return MissionDifficulty.Facil;
    }

    IconData _getIcon(String iconName) {
      switch (iconName) {
        case 'Icons.spa': return Icons.spa;
        case 'Icons.lightbulb_outline': return Icons.lightbulb_outline;
        case 'Icons.volunteer_activism': return Icons.volunteer_activism;
        case 'Icons.terrain': return Icons.terrain;
        default: return Icons.help_outline;
      }
    }
    // --- Fim Funções Auxiliares ---


    // --- Extração e Cast de Dados (CORRIGIDO PARA CAST EXPLÍCITO) ---
    // Usamos 'as String?' para obter a string (ou null) e usamos '??' para o fallback.
    final String title = data['title'] as String? ?? 'Missão sem título';
    final String description = data['description'] as String? ?? 'Sem descrição.';
    
    // O campo 'points' é do tipo Number no Firestore e lido como 'num' (int ou double).
    // Usamos 'as num?' para aceitar ambos e converter para int.
    final int points = (data['points'] as num?)?.toInt() ?? 0;
    
    final String categoryTitle = data['categoryTitle'] as String? ?? 'Geral';
    final String iconName = data['categoryIcon'] as String? ?? '';
    final String difficultyString = data['difficulty'] as String? ?? 'Fácil';
    final String time = data['time'] as String? ?? 'Indefinido';
    final String imageAsset = data['imageAsset'] as String? ?? 'assets/default.png';

    return DetailedMissionModel(
      title: title,
      description: description,
      points: points,
      categoryTitle: categoryTitle,
      categoryIcon: _getIcon(iconName),
      difficulty: _getDifficulty(difficultyString),
      time: time,
      imageAsset: imageAsset,
    );
  }


  String get difficultyAsString {
    switch (difficulty) {
      case MissionDifficulty.Facil: return 'Fácil';
      case MissionDifficulty.Medio: return 'Médio';
      case MissionDifficulty.Dificil: return 'Difícil';
    }
  }
}