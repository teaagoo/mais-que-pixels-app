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
  CategoryModel(title: 'Zen', icon: Icons.spa, color: Color(0xFF8AAE8A)),
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
  HighlightChallengeModel(title: 'Deixe uma avaliação positiva online', points: '+25 pontos', color: Color(0xFF8AAE8A)),
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
  MissionModel(title: 'Faça uma caminhada de 20 minutos em silêncio', points: 25, categoryTitle: 'Zen', categoryIcon: Icons.spa),
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
  DetailedMissionModel(
    title: 'Medite por 5 min',
    description: 'Encontre um lugar tranquilo, feche os olhos e concentre-se na sua respiração. Não se preocupe com os pensamentos que surgem, apenas observe-os e volte sua atenção para o ar que entra e sai. O objetivo é acalmar a mente e estar presente.',
    points: 30,
    categoryTitle: 'Zen',
    categoryIcon: Icons.spa, // Usando o novo ícone que você escolheu!
    difficulty: MissionDifficulty.Facil,
    time: '5 minutos',
    imageAsset: 'assets/illustrations/zen_missao.png', // Lembre-se de criar e adicionar essa imagem
  ),
  DetailedMissionModel(
    title: 'Deixe uma avaliação positiva online',
    description: 'Pense em um pequeno negócio local que você gosta, como um café, uma livraria ou um restaurante. Deixe uma avaliação sincera e positiva no Google Maps ou em outra plataforma. Isso ajuda muito os pequenos empreendedores!',
    points: 25, // Ajustei os pontos para o novo desafio
    categoryTitle: 'Gentileza',
    categoryIcon: Icons.volunteer_activism,
    difficulty: MissionDifficulty.Facil,
    time: '5 minutos',
    imageAsset: 'assets/illustrations/gentileza_missao.png', // CRIE E ADICIONE ESSA IMAGEM
  ),
  DetailedMissionModel(
    title: 'Ligue para um amigo',
    description: 'Escolha um amigo ou familiar com quem você não conversa há algum tempo e faça uma ligação. Pergunte como ele está, ouça com atenção e compartilhe um pouco do seu dia. Fortalecer conexões é um ato de gentileza.',
    points: 50,
    categoryTitle: 'Gentileza',
    categoryIcon: Icons.volunteer_activism,
    difficulty: MissionDifficulty.Facil,
    time: '10 minutos',
    imageAsset: 'assets/illustrations/gentileza_missao.png', // Crie e adicione essa imagem
  ),
  DetailedMissionModel(
  title: 'Elogie um colega de trabalho sinceramente',
  description: 'Observe as qualidades de um colega e ofereça um elogio genuíno. Pode ser sobre uma habilidade, uma atitude positiva ou um bom trabalho. O objetivo é fortalecer laços e criar um ambiente mais leve e colaborativo.',
  points: 20,
  categoryTitle: 'Gentileza',
  categoryIcon: Icons.volunteer_activism,
  difficulty: MissionDifficulty.Facil,
  time: '5 minutos',
  imageAsset: 'assets/illustrations/gentileza_missao.png', // Lembre-se de criar e adicionar essa imagem
  ),

  DetailedMissionModel(
    title: 'Passe 15 minutos desenhando ou escrevendo livremente',
    description: 'Pegue um caderno, papel ou abra um editor de texto. Por 15 minutos, desenhe o que vier à mente ou escreva sem parar, sem se preocupar com gramática, sentido ou qualidade. Apenas deixe a criatividade fluir.',
    points: 30,
    categoryTitle: 'Criatividade',
    categoryIcon: Icons.lightbulb_outline,
    difficulty: MissionDifficulty.Facil,
    time: '15 minutos',
    imageAsset: 'assets/illustrations/criatividade_missao.png', // Lembre-se de criar e adicionar essa imagem
  ),

  DetailedMissionModel(
    title: 'Tente uma receita nova para o jantar',
    description: 'Saia da sua zona de conforto culinária! Procure uma receita que te pareça interessante, seja de um prato simples ou algo mais elaborado. O processo de cozinhar algo novo pode ser uma forma deliciosa de exercitar a criatividade.',
    points: 40,
    categoryTitle: 'Criatividade',
    categoryIcon: Icons.lightbulb_outline,
    difficulty: MissionDifficulty.Medio,
    time: '1 hora',
    imageAsset: 'assets/illustrations/criatividade_missao.png', // Lembre-se de criar e adicionar essa imagem
  ),

  DetailedMissionModel(
    title: 'Faça uma caminhada de 20 minutos em silêncio',
    description: 'Deixe o celular e os fones de ouvido em casa. Faça uma caminhada de 20 minutos prestando atenção total ao seu redor: os sons, as cores, o vento no rosto, seus próprios passos. É uma meditação em movimento para acalmar a mente.',
    points: 25,
    categoryTitle: 'Zen',
    categoryIcon: Icons.spa,
    difficulty: MissionDifficulty.Facil,
    time: '20 minutos',
    imageAsset: 'assets/illustrations/zen_missao.png', // Lembre-se de criar e adicionar essa imagem
  ),

  DetailedMissionModel(
    title: 'Fale sobre um medo seu com alguém de confiança',
    description: 'A coragem não é a ausência do medo, mas a ação apesar dele. Escolha um amigo próximo ou familiar e compartilhe algo que te assusta ou te deixa vulnerável. Expressar seus medos pode diminuir o peso deles e fortalecer seus laços.',
    points: 60,
    categoryTitle: 'Coragem',
    categoryIcon: Icons.terrain,
    difficulty: MissionDifficulty.Dificil,
    time: '15 minutos',
    imageAsset: 'assets/illustrations/coragem_missao.png', // Lembre-se de criar e adicionar essa imagem
  ),
  // Adicione aqui as versões detalhadas das outras missões da lista mockMissions
  // para que o clique funcione para todas elas.
];