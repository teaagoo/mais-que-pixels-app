import 'package:flutter/material.dart';
import 'package:meu_primeiro_app/models/categorias.dart';

// Importe a nova tela que acabamos de criar
import 'package:meu_primeiro_app/telas/missao_em_andamento_tela.dart';

class DetalheMissaoTela extends StatelessWidget {
  final DetailedMissionModel missao;

  const DetalheMissaoTela({Key? key, required this.missao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ... o build continua exatamente o mesmo ...
    const Color primaryColor = Color(0xFFE5EDE4);
    const Color accentColor = Color(0xFF98B586);

    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 125.0),
                  child: _buildMissionCard(accentColor),
                ),
                Image.asset(missao.imageAsset, height: 250),
              ],
            ),
            const SizedBox(height: 20),
            // A única mudança é que este método agora tem a lógica
            _buildActionButtons(context, accentColor),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- MÉTODO DOS BOTÕES ATUALIZADO ---
  Widget _buildActionButtons(BuildContext context, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // LÓGICA PARA ACEITAR A MISSÃO
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
            // LÓGICA PARA PULAR A MISSÃO
            onPressed: () {
              // Retorna até a primeira tela da pilha (tela_principal)
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

  // O resto dos seus widgets (_buildHeader, _buildMissionCard, etc.) continua igual
  Widget _buildHeader() {
  return Padding(
    padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center, // Adicionado para melhor alinhamento vertical
      children: [
        // O Expanded vai aqui, envolvendo a Row interna para que ela seja flexível
        Expanded(
          child: Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage('assets/perfil_analu.png'),
              ),
              const SizedBox(width: 15),
              // E outro Expanded aqui dentro, para que a coluna de texto
              // ocupe todo o espaço restante disponível nesta Row interna
              Expanded(
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá, Analu!', 
                      style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold, fontSize: 20),
                      overflow: TextOverflow.ellipsis, // Evita que o nome quebre a linha
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Vamos viver algo novo hoje?', 
                      style: TextStyle(fontFamily: 'Lato', color: Colors.black54),
                      overflow: TextOverflow.ellipsis, // Adiciona "..." se o texto for muito grande
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // O Container dos pontos fica fora do Expanded, 
        // pois ele tem um tamanho fixo e queremos que ele fique à direita.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
            ],
          ),
          child: const Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber, size: 20),
              SizedBox(width: 5),
              Text('590 pontos', style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    ),
  );
}
  Widget _buildMissionCard(Color accentColor) { /* ... Seu código do _buildMissionCard ... */ return Container(margin: const EdgeInsets.symmetric(horizontal: 20),padding: const EdgeInsets.all(25.0),decoration: BoxDecoration(color: Colors.white.withOpacity(0.8),borderRadius: BorderRadius.circular(25),),child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [_buildTag(missao.categoryTitle, missao.categoryIcon, accentColor),_buildTag(missao.difficultyAsString, null, accentColor),],),const SizedBox(height: 20),Text(missao.title,textAlign: TextAlign.center,style: const TextStyle(fontFamily: 'MochiyPopOne', fontSize: 28, height: 1.2),),const SizedBox(height: 15),Center(child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),decoration: BoxDecoration(color: const Color(0xFFD5E8D4),borderRadius: BorderRadius.circular(15.0),),child: Text('+${missao.points} pontos',style: const TextStyle(fontFamily: 'Lato', color: Color(0xFF3A6A4D), fontWeight: FontWeight.bold),),),),const SizedBox(height: 25),Text(missao.description,style: const TextStyle(fontFamily: 'Lato', color: Colors.black54, fontSize: 16, height: 1.5),),const SizedBox(height: 25),Row(children: [const Icon(Icons.access_time, color: Colors.black54, size: 20),const SizedBox(width: 8),Text(missao.time,style: const TextStyle(fontFamily: 'Lato', color: Colors.black54, fontSize: 14),),],),],),);}
  Widget _buildTag(String label, IconData? icon, Color color) { /* ... Seu código do _buildTag ... */ return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),decoration: BoxDecoration(color: color,borderRadius: BorderRadius.circular(20),),child: Row(children: [if (icon != null) Icon(icon, color: Colors.white, size: 16),if (icon != null) const SizedBox(width: 5),Text(label,style: const TextStyle(color: Colors.white, fontFamily: 'Lato', fontWeight: FontWeight.bold),),],),);}

}