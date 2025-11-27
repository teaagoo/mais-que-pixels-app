import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meu_primeiro_app/services/auth_services.dart';
import 'package:meu_primeiro_app/services/user_data_service.dart';
import 'package:meu_primeiro_app/models/usuarios.dart';
import 'package:meu_primeiro_app/telas/tela_login.dart';

class TelaEditarPerfil extends StatefulWidget {
  const TelaEditarPerfil({super.key});

  @override
  State<TelaEditarPerfil> createState() => _TelaEditarPerfilState();
}

class _TelaEditarPerfilState extends State<TelaEditarPerfil> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isLoading = false;

  final Color primaryColor = const Color(0xFF3A6A4D);
  final Color dangerColor = Colors.red[700]!;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // --- Funções de Lógica ---

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _compressAndConvertImageToBase64() async {
    if (_imageFile == null) return null;

    try {
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        _imageFile!.absolute.path,
        '${_imageFile!.absolute.path}_compressed.jpg',
        quality: 50,
      );

      if (compressedFile == null) return null;

      final bytes = await compressedFile.readAsBytes();
      final base64String = base64Encode(bytes);
      
      return 'data:image/jpeg;base64,$base64String';
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao processar a foto.')),
        );
      }
      return null;
    }
  }

  Future<void> _saveProfile(String uid, Usuario? currentUser) async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final userDataService = Provider.of<UserDataService>(context, listen: false);
      final newName = _nameController.text.trim();
      String? newPhotoBase64 = currentUser?.photoUrl;

      // 1. Converte a Nova Imagem para Base64
      if (_imageFile != null) {
        final base64String = await _compressAndConvertImageToBase64();
        if (base64String != null) {
          newPhotoBase64 = base64String;
        } else {
          setState(() => _isLoading = false);
          return;
        }
      }

      // 2. Atualiza o Perfil no Firestore
      await userDataService.updateProfile(uid, newName, newPhotoBase64);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar as mudanças.')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Função utilitária para exibir a imagem Base64
  ImageProvider _buildImageProvider(String? photoUrlBase64, Usuario? user) {
    if (_imageFile != null) {
      return FileImage(_imageFile!);
    }
    
    final finalPhotoUrl = photoUrlBase64 ?? user?.photoUrl;
    
    if (finalPhotoUrl != null && finalPhotoUrl.startsWith('data:image')) {
      try {
        final base64String = finalPhotoUrl.split(',').last;
        return MemoryImage(base64Decode(base64String));
      } catch (e) {
        return const AssetImage('assets/perfil_analu.png');
      }
    }
    
    return const AssetImage('assets/perfil_analu.png');
  }

  // --- Funções de Gerenciamento de Conta ---

  // Função genérica para exibir um diálogo de reautenticação
  Future<String?> _showReauthDialog() async {
    String? password;
    final formKey = GlobalKey<FormState>();

    await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirme a Senha'),
        content: Form(
          key: formKey,
          child: TextFormField(
            onChanged: (value) => password = value,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Senha Atual'),
            validator: (value) => value!.isEmpty ? 'Insira sua senha' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, password);
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
    return password;
  }

  // Altera a Senha
  void _changePassword() async {
    String? newPassword;
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Senha'),
        content: Form(
          key: formKey,
          child: TextFormField(
            onChanged: (value) => newPassword = value,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Nova Senha (mín. 6 caracteres)'),
            validator: (value) => value!.length < 6 ? 'Mínimo 6 caracteres' : null,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate() && newPassword != null) {
                Navigator.pop(context); 
                final password = await _showReauthDialog();
                if (password != null) {
                  _executePasswordChange(password, newPassword!);
                }
              }
            },
            child: const Text('Próximo'),
          ),
        ],
      ),
    );
  }

  void _executePasswordChange(String currentPassword, String newPassword) async {
    setState(() => _isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      // ⭐ CHAMA O MÉTODO REAUTHENTICATEUSER DO SEU AUTHSERVICE
      await authService.reauthenticateUser(user!, currentPassword);
      await user.updatePassword(newPassword);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha alterada com sucesso!')),
      );
    } on FirebaseAuthException catch (e) {
      String msg = 'Erro ao alterar a senha.';
      if (e.code == 'wrong-password') {
        msg = 'Senha atual incorreta.';
      } else if (e.code == 'requires-recent-login') {
        msg = 'Faça login novamente antes de trocar a senha.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Altera o Email
  void _changeEmail(String currentEmail) async {
    String? newEmail;
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar Email'),
        content: Form(
          key: formKey,
          child: TextFormField(
            initialValue: currentEmail,
            onChanged: (value) => newEmail = value,
            decoration: const InputDecoration(labelText: 'Novo Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value!.isEmpty || !value.contains('@') ? 'Email inválido' : null,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate() && newEmail != null && newEmail != currentEmail) {
                Navigator.pop(context); 
                final password = await _showReauthDialog();
                if (password != null) {
                  _executeEmailChange(password, newEmail!);
                }
              }
            },
            child: const Text('Próximo'),
          ),
        ],
      ),
    );
  }

  void _executeEmailChange(String currentPassword, String newEmail) async {
    setState(() => _isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      // ⭐ CHAMA O MÉTODO REAUTHENTICATEUSER DO SEU AUTHSERVICE
      await authService.reauthenticateUser(user!, currentPassword);
      await user.verifyBeforeUpdateEmail(newEmail);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email de verificação enviado! Verifique sua caixa de entrada para confirmar o novo email.')),
      );
    } on FirebaseAuthException catch (e) {
      String msg = 'Erro ao alterar o email.';
      if (e.code == 'email-already-in-use') {
        msg = 'O novo email já está em uso.';
      } else if (e.code == 'requires-recent-login') {
        msg = 'Faça login novamente antes de trocar o email.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Excluir Conta
  void _deleteAccount() async {
    final password = await _showReauthDialog();
    if (password == null) return;

    setState(() => _isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    final authService = Provider.of<AuthService>(context, listen: false);
    final userDataService = Provider.of<UserDataService>(context, listen: false);

    try {
      // ⭐ CHAMA O MÉTODO REAUTHENTICATEUSER DO SEU AUTHSERVICE
      await authService.reauthenticateUser(user!, password);
      
      // 1. Excluir dados do Firestore (opcional, mas recomendado)
      // Você precisará implementar o método deleteUserData(uid) no UserDataService
      // await userDataService.deleteUserData(user.uid); 

      // 2. Excluir conta no Firebase Auth
      await user.delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conta excluída com sucesso.')),
        );
        // Redireciona para a tela de login
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String msg = 'Erro ao excluir a conta.';
      if (e.code == 'wrong-password') {
        msg = 'Senha incorreta. A conta não foi excluída.';
      } else if (e.code == 'requires-recent-login') {
        msg = 'Faça login novamente antes de excluir a conta.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      setState(() => _isLoading = false);
    }
  }


  // --- UI Components ---

  Widget _buildProfileSection(Usuario? user) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[200],
            backgroundImage: _buildImageProvider(user?.photoUrl, user),
            child: Align(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: primaryColor,
                child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          user?.email ?? 'Usuário Sem Email',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        // ⭐ Adicionado Dica visual para reautenticação
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Para alterar dados sensíveis (email/senha), você será solicitado a reconfirmar sua senha.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.blueGrey),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(Usuario? user, String uid) {
    if (_nameController.text.isEmpty && user != null) {
      _nameController.text = user.nome;
    }

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dados Públicos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            // Campo Nome
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome de Exibição',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O nome não pode ser vazio.';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Botão Salvar
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _saveProfile(uid, user),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Salvar Nome e Foto',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),
            
            const SizedBox(height: 40),
            _buildAccountManagement(user?.email ?? '', uid),
          ],
        ),
      ),
    );
  }

  // Novo Widget: Gerenciamento de Conta
  Widget _buildAccountManagement(String currentEmail, String uid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gerenciamento de Conta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        // Botão Mudar Email
        _buildListTile(
          title: 'Alterar Email',
          subtitle: currentEmail,
          icon: Icons.email_outlined,
          onTap: _isLoading ? null : () => _changeEmail(currentEmail),
        ),

        const Divider(),

        // Botão Mudar Senha
        _buildListTile(
          title: 'Alterar Senha',
          subtitle: 'Requer senha atual',
          icon: Icons.lock_outline,
          onTap: _isLoading ? null : _changePassword,
        ),

        const Divider(),

        // Botão Excluir Conta
        _buildListTile(
          title: 'Excluir Conta',
          subtitle: 'Esta ação é irreversível.',
          icon: Icons.delete_forever,
          iconColor: dangerColor,
          onTap: _isLoading ? null : _deleteAccount,
        ),
      ],
    );
  }

  // Utility para criar itens de lista
  Widget _buildListTile({
    required String title,
    required String subtitle,
    required IconData icon,
    Color iconColor = Colors.black87,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: onTap == null ? Colors.grey : Colors.black87)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  // --- Método Build Principal ---
  
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final userDataService = Provider.of<UserDataService>(context);
    final uid = auth.usuario?.uid;

    if (uid == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Editar Perfil')),
        body: const Center(child: Text('Erro: Usuário não autenticado.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<Usuario?>(
        stream: userDataService.getUserStream(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;

          return SingleChildScrollView(
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfileSection(user),
                _buildForm(user, uid),
              ],
            ),
          );
        },
      ),
    );
  }
}