import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meu_primeiro_app/services/user_data_service.dart';
import 'package:meu_primeiro_app/services/auth_services.dart';
import 'package:meu_primeiro_app/models/usuarios.dart';
import 'package:meu_primeiro_app/telas/tela_editar_perfil.dart';
import 'dart:convert'; // Import para Base64

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userDataService = Provider.of<UserDataService>(context);
    final currentUserId = authService.usuario?.uid;

    if (currentUserId == null) {
      return Container(); 
    }

    return StreamBuilder<Usuario?>(
      stream: userDataService.getUserStream(currentUserId),
      builder: (context, snapshot) {
        String? photoBase64 = snapshot.data?.photoUrl; // Agora é a string Base64
        
        ImageProvider? avatarImage;

        // Tenta decodificar a string Base64
        if (photoBase64 != null && photoBase64.startsWith('data:image')) {
          try {
            // Remove o prefixo 'data:image/jpeg;base64,'
            final base64String = photoBase64.split(',').last;
            avatarImage = MemoryImage(base64Decode(base64String));
          } catch (e) {
            // Se a decodificação falhar, usa o placeholder
            avatarImage = const AssetImage('assets/perfil_analu.png'); 
          }
        } else {
            avatarImage = const AssetImage('assets/perfil_analu.png');
        }

        return Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TelaEditarPerfil()),
              );
            },
            child: CircleAvatar(
              radius: 20,
              backgroundImage: avatarImage,
              backgroundColor: Colors.grey[200],
            ),
          ),
        );
      },
    );
  }
}