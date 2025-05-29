class Cliente {
  final String? id;
  final String? email;
  final String? password;
  final String? nome;
  final String? primeiroNome;
  final String? ultimoNome;

  Cliente({
    this.id,
    this.nome,
    this.primeiroNome,
    this.ultimoNome,
    this.email,
    this.password,
  });

  Cliente.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        password = json['senha'],
        nome = json['nome'],
        primeiroNome = json['primeiroNome'],
        ultimoNome = json['ultimoNome'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'password': password,
    'nome': nome,
    'primeiroNome': primeiroNome,
    if (ultimoNome != null) 'ultimoNome': ultimoNome,
  };

  Map<String, dynamic> toRegisterJson() => {
    'nome': nome,
    'email': email,
    'senha': password,
  };

  Map<String, dynamic> toLoginJson() => {
    'email': email,
    'password': password,
  };

  @override
  String toString() {
    return 'Cliente{id: $id, email: $email, senha: $password, nome: $nome, primeiroNome: $primeiroNome, ultimoNome: $ultimoNome,}';
  }
}
