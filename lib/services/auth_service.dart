import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Instance dari Firebase Authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fungsi untuk Login
  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Menangkap error dari Firebase (misal: password salah, email tidak terdaftar)
      throw e.message ?? "Terjadi kesalahan saat login";
    }
  }

  // Fungsi untuk Register (Daftar Akun Baru)
  Future<User?> register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Menangkap error (misal: email sudah dipakai, password terlalu pendek)
      throw e.message ?? "Terjadi kesalahan saat mendaftar";
    }
  }

  // ⬇️ FITUR BARU: Login dengan Google ⬇️
  Future<User?> signInWithGoogle() async {
    try {
      // Membuat provider Google
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      
      // Memunculkan popup login Google (Sangat cocok untuk Flutter Web)
      UserCredential userCredential = await _auth.signInWithPopup(googleProvider);
      
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Menangani error (misal: popup ditutup user sebelum selesai)
      throw e.message ?? "Gagal login dengan Google";
    } catch (e) {
      throw "Terjadi kesalahan: $e";
    }
  }

  // Fungsi untuk Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Fungsi untuk mendapatkan user yang sedang login saat ini
  User? get currentUser => _auth.currentUser;
}