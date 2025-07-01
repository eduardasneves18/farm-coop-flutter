import 'package:firebase_auth/firebase_auth.dart';

class UsersFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> getUser() async {
    return _auth.currentUser;
  }

  Future<UserCredential> createUser(String name, String email,
      String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload();
      }

      return userCredential;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'ERROR_CREATE_USER',
        message: 'Falha ao criar o usuário: ${e.toString()}',
      );
    }
  }
}