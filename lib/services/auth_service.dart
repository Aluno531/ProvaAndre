import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // sucesso
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Criar conta
  Future<String?> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null; // sucesso
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Logout
  Future signOut() async {
    await _auth.signOut();
  }

  // Usuário atual
  User? get currentUser => _auth.currentUser;
}
