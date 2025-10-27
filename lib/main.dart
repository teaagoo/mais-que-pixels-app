import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// -----------------------------------------------------
// 1. WIDGET RAIZ DO APLICATIVO
// -----------------------------------------------------

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mais que pixels',
      theme: ThemeData(
        // Cor principal do aplicativo (tom de verde para combinar com o design)
        primarySwatch: Colors.green,
        // Cor de fundo padrão (branco/creme claro, como no design)
        scaffoldBackgroundColor: const Color(0xFFF5F5E5), // Tom de creme
      ),
      home: const WelcomeScreen(),
    );
  }
}

// -----------------------------------------------------
// 2. TELA DE BOAS-VINDAS (RECRIAÇÃO DO DESIGN)
// -----------------------------------------------------

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // Função que será chamada ao clicar no botão 'Iniciar'
  void _iniciar() {
    // Por enquanto, apenas para testes, imprime no console.
    debugPrint('Botão Iniciar Pressionado!');
    // FUTURO: Aqui você colocará a navegação: Navigator.push(...)
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold é o esqueleto da tela
    return Scaffold(
      // Removendo a cor de fundo padrão, pois a imagem de fundo fará isso.
      // body é o corpo principal da tela
      body: Stack(
        children: <Widget>[
          // -------------------------------------------
          // 1. BACKGROUND COMPLETO (PRIMEIRO ELEMENTO = FUNDO)
          // -------------------------------------------
          // Positioned.fill faz com que a imagem ocupe todo o espaço da tela.
          Positioned.fill(
            child: Image.asset(
              // ATENÇÃO: Se o nome do seu arquivo for diferente, ajuste aqui!
              'assets/ilustracao_boas_vindas.png', 
              fit: BoxFit.cover, // Preenche toda a área, cortando o que for necessário.
            ),
          ),

          // -------------------------------------------
          // 2. CONTEÚDO PRINCIPAL (SEGUNDO ELEMENTO = TOPO)
          // -------------------------------------------
          // SafeArea evita que o conteúdo seja coberto pela barra de status do celular
          SafeArea( 
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  // mainAxisAlignment.start alinha o conteúdo mais para o topo
                  mainAxisAlignment: MainAxisAlignment.start, 
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Espaço do topo (ajustado para que o texto comece mais abaixo)
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
                        color: Colors.black87, // Um preto um pouco mais escuro para garantir leitura
                      ),
                    ),

                    // Usa um 'Spacer' para empurrar o botão para o fundo da tela.
                    const Spacer(), 

                    // Botão 'Iniciar'
                    ElevatedButton(
                      onPressed: _iniciar, 
                      style: ElevatedButton.styleFrom(
                        // Usando a cor de fundo do botão do seu Figma (Verde Musgo)
                        backgroundColor: const Color(0xFF6B8E4C), 
                        foregroundColor: Colors.white, 
                        minimumSize: const Size(200, 65), // double.infinity usa a largura máxima
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), 
                        ),
                        elevation: 5, // Sombra do botão
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