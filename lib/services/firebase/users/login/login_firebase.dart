import 'package:firebase_auth/firebase_auth.dart';
import 'package:yes_bank/store/cliente_store.dart';

import '../sessions/sessionManager.dart';

class LoginFirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailPassword(String email, String senha, ClienteStore clienteStore,) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'Erro ao autenticar. Tente novamente.',
      );

    } catch (e) {
      throw Exception('Erro desconhecido ao fazer login: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
