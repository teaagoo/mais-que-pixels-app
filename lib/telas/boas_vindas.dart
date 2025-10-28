import 'package:flutter/material.dart';

// -----------------------------------------------------
// 2. TELA DE BOAS-VINDAS (WIDGET COMPLETO)
// -----------------------------------------------------

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // Função que será chamada ao clicar no botão 'Iniciar'
  void _iniciar(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/inicio');
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold é o esqueleto da tela
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // -------------------------------------------
          // 1. BACKGROUND COMPLETO (PRIMEIRO ELEMENTO = FUNDO)
          // -------------------------------------------
          Positioned.fill(
            child: Image.asset(
              'assets/ilustracao_boas_vindas.png', 
              fit: BoxFit.cover, 
            ),
          ),

          // -------------------------------------------
          // 2. CONTEÚDO PRINCIPAL (SEGUNDO ELEMENTO = TOPO)
          // -------------------------------------------
          SafeArea( 
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start, 
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Espaço do topo
                    const SizedBox(height: 100), 

                    // Título
                    const Text(
                      'Mais que\nPixels',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, 
                        height: 1.1, 
                      ),
                    ),
                    
                    // Espaço
                    const SizedBox(height: 10),

                    // Slogan
                    const Text(
                      'Viva fora da tela, um\ndesafio por vez.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87, 
                      ),
                    ),

                    // Usa um 'Spacer' para empurrar o botão para o fundo da tela.
                    const Spacer(), 

                    // Botão 'Iniciar'
                    ElevatedButton(
                      // ALTERAÇÃO CRUCIAL: Passa o 'context' ao chamar a função
                      onPressed: () => _iniciar(context), 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B8E4C), 
                        foregroundColor: Colors.white, 
                        minimumSize: const Size(200, 65), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), 
                        ),
                        elevation: 5, 
                      ),
                      child: const Text(
                        'Iniciar',
                        style: TextStyle(
                          fontSize: 25, 
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                    
                    // Espaço na parte inferior, abaixo do botão
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
