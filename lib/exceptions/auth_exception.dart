class AuthException implements Exception{
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'O email já existe.',
    'OPERATION_NOT_ALLOWED': 'A operação não foi autorizada.',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Já foram realizadas muitas tentativas. Tente mais tarde.',
    'EMAIL_NOT_FOUND': 'Email não foi encontrado.',
    'INVALID_PASSWORD': 'Senha Inválida',
    'USER_DISABLED': 'O usuário foi desativado. Faça o Login novamente.',
  };

  final String key;

  const AuthException(this.key);

  @override
  String toString() {
    if(errors.containsKey(this.key)){
      return errors[this.key];
    }else{
      return 'Ocorreu um erro durante a Autentificação.';
    }
  }
}