import 'package:flutter/material.dart';

class MissaoConcluidaTela extends StatelessWidget {
  // A tela recebe os pontos da missão que foi concluída
  final int pontosGanhos;

  const MissaoConcluidaTela({Key? key, required this.pontosGanhos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFE5EDE4);
    const Color accentColor = Color(0xFF98B586);

    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          // O cabeçalho é o mesmo das outras telas
          _buildHeader(),
          
          // O conteúdo principal da tela
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ilustração de sucesso/comemoração
                Image.asset('assets/illustrations/missao_concluida.png', height: 250),
                const SizedBox(height: 30),
                
                // Os textos e o card de pontos
                _buildSuccessContent(context, accentColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
              Text('640 pontos', style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    ),
  );
}

  Widget _buildSuccessContent(BuildContext context, Color accentColor) {
    return Column(
      children: [
        const Text(
          'Missão cumprida!',
          style: TextStyle(fontFamily: 'MochiyPopOne', fontSize: 32, color: Color(0xFF3A6A4D)),
        ),
        const SizedBox(height: 8),
        const Text(
          'Parabéns!',
          style: TextStyle(fontFamily: 'Lato', fontSize: 18, color: Colors.black54),
        ),
        const SizedBox(height: 30),
        
        // Card de Pontos Ganhos
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // O card branco que fica embaixo
            Container(
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5)),
                ]
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 30),
                  const SizedBox(width: 10),
                  Text(
                    '+$pontosGanhos pts',
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            // A tag "Total de Pontos" que fica por cima
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Total de Pontos',
                style: TextStyle(color: Colors.white, fontFamily: 'Lato', fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 40),

        // Botão Finalizar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navega de volta para a primeira tela da pilha (tela_principal)
                Navigator.of(context).popUntil((route) => route.isFirst);
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
                'Finalizar',
                style: TextStyle(fontSize: 18, fontFamily: 'Lato', fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}