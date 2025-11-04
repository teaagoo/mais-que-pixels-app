import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meu_primeiro_app/services/auth_services.dart';

class CadastroPage extends StatefulWidget {
  CadastroPage({Key? key}) : super(key: key);

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final formKey = GlobalKey<FormState>();
  final nome = TextEditingController();
  final email = TextEditingController();
  final senha = TextEditingController();
  bool loading = false;

  registrar() async {
    setState(() {
      loading = true;
    });
    try {
      await context
          .read<AuthService>()
          .registrar(nome.text, email.text, senha.text);
      Navigator.pop(context);
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
      appBar: AppBar(title: Text("Cadastro")),
      body: Container(
        decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('./assets/fundo.png'),
          fit: BoxFit.cover,
        ),
      ),
        child: Padding(
          padding: EdgeInsets.only(top: 50),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Crie sua conta",
                  style: TextStyle(
                   fontSize: 35,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: -1.5,
                    ),
                ),

                const SizedBox(height: 20),

                Image.asset(
                './assets/logo.png',
                width: 120, 
                height: 120,
               
                ),
                Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: TextFormField(                  
                    controller: nome,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFC9D8B6),
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      labelText: 'Nome',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Digite seu nome';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFC9D8B6),
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Digite seu email';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20),

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
                      labelText: 'Senha',
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
                
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5E8C61),
                      minimumSize: const Size(200, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        registrar();
                      }
                    },
                    child: (loading)
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Cadastrar",  style: TextStyle(fontSize: 20, color: Colors.white)),
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
