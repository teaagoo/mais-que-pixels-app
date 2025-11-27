import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Adicionado
import 'package:meu_primeiro_app/widgets/auth_check.dart'; // Adicionado

// -----------------------------------------------------
// 2. TELA DE BOAS-VINDAS (WIDGET COMPLETO)
// -----------------------------------------------------

class BoasVindasTela extends StatelessWidget { // Renomeado para seguir o padrão do main.dart
  const BoasVindasTela({super.key});

  // Função para salvar o estado e navegar para o AuthCheck
  void _iniciar(BuildContext context) async {
    // 1. Salva a flag de que a tela de boas-vindas já foi vista
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenWelcome', true);
    
    // 2. Navega para o AuthCheck, que decidirá se o usuário vai para
    //    o Login (se deslogado) ou para a Tela Principal (se logado).
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => AuthCheck()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // -------------------------------------------
          // 1. BACKGROUND COMPLETO
          // -------------------------------------------
          Positioned.fill(
            child: Image.asset(
              'assets/ilustracao_boas_vindas.png',
              fit: BoxFit.cover,
            ),
          ),

          // -------------------------------------------
          // 2. CONTEÚDO PRINCIPAL
          // -------------------------------------------
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 120),

                    // -------------------------------------------
                    // TÍTULO
                    // -------------------------------------------
                    Text(
                      'Mais que\nPixels',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontFamily: 'MochiyPopPOne',
                        fontSize: 48,
                        color: Colors.black,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // -------------------------------------------
                    // SLOGAN
                    // -------------------------------------------
                    Text(
                      'Viva fora da tela,\num desafio por vez.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontFamily: 'Lato',
                        fontSize: 18,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),

                    const Spacer(),

                    // -------------------------------------------
                    // BOTÃO 'INICIAR'
                    // -------------------------------------------
                    ElevatedButton(
                      onPressed: () => _iniciar(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B8E4C),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(220, 65),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        elevation: 6,
                      ),
                      child: const Text(
                        'Iniciar',
                        style: TextStyle(
                          fontFamily: 'MochiyPopPOne',
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 350),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}