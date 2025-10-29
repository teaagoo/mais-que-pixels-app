class Usuario {
  final int? id; 
  final String nome;
  final String email;
  final String senha;

  Usuario({
    this.id, 
    required this.nome, 
    required this.email, 
    required this.senha,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      email: map['email'] as String,
      senha: map['senha'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nome': nome,
      'email': email,
      'senha': senha,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}