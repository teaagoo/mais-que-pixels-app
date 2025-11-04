import 'package:flutter/material.dart';
import 'package:meu_primeiro_app/services/auth_services.dart';
import 'package:meu_primeiro_app/telas/tela_principal.dart';
import 'package:provider/provider.dart';
import 'package:meu_primeiro_app/telas/tela_cadastro.dart'; // importa a tela de cadastro

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  bool loading = false;

  login() async {
    setState(() {
      loading = true;
    });
    try {
      await context.read<AuthService>().login(email.text, senha.text);
      Navigator.pushReplacement(
         context, 
         MaterialPageRoute(builder: (_) => const TelaPrincipal()),
      );

    } on AuthException catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2E0), 
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Título
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 35,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: -1.5,
                  ),
                ),

                const SizedBox(height: 40),

                // Campo de Email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFC9D8B6),
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      labelText: 'Digite seu usuário ou e-mail',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Digite seu Email';
                      }
                      return null;
                    },
                  ),
                ),

                // Campo de Senha
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: TextFormField(
                    controller: senha,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFC9D8B6),
                      prefixIcon: const Icon(Icons.key_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      labelText: 'Digite sua senha',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Digite sua senha';
                      } else if (value.length < 8) {
                        return 'Sua senha deve ter no mínimo 8 caracteres';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 8),

                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Não tem uma conta? ',
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CadastroPage()),
                        );
                      },
                      child: Text(
                        'Cadastre-se aqui',
                        style: TextStyle(
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Esqueceu sua senha?',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),

                const SizedBox(height: 16),

                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5E8C61),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        login();
                      }
                    },
                    child: (loading)
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Logar',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
