import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Estado actual del usuario
  User? get currentUser => _auth.currentUser;

  // Stream de cambios de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ============== REGISTRO ==============
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    String role = 'client',
  }) async {
    try {
      // 1. Crear usuario en Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2. Crear documento en Firestore
      final user = UserModel(
        userId: userCredential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        phoneVerified: false, // ← NUEVO: Por defecto no verificado
        verificationCode: '', // ← NUEVO: Vacío inicialmente
        verificationCodeExpiry: null, // ← NUEVO: Sin expiración
        role: role,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.userId).set(user.toMap());

      notifyListeners();
      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Error al crear cuenta: $e';
    }
  }

  // ============== LOGIN ==============
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Login en Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Obtener datos del usuario de Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw 'Usuario no encontrado en la base de datos';
      }

      notifyListeners();
      return UserModel.fromFirestore(userDoc);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Error al iniciar sesión: $e';
    }
  }

  // ============== LOGOUT ==============
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      throw 'Error al cerrar sesión: $e';
    }
  }

  // ============== RESTABLECER CONTRASEÑA ==============
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ============== VERIFICAR EMAIL ==============
  Future<void> sendEmailVerification() async {
    try {
      await currentUser?.sendEmailVerification();
    } catch (e) {
      throw 'Error al enviar verificación: $e';
    }
  }

  // ============== ELIMINAR CUENTA ==============
  Future<void> deleteAccount() async {
    try {
      final userId = currentUser?.uid;
      if (userId == null) throw 'No hay usuario autenticado';

      // 1. Soft delete en Firestore
      await _firestore.collection('users').doc(userId).update({
        'active': false,
      });

      // 2. Eliminar de Firebase Auth (opcional)
      // await currentUser?.delete();

      notifyListeners();
    } catch (e) {
      throw 'Error al eliminar cuenta: $e';
    }
  }

  // ============== LOGIN DEMO ==============
  Future<UserModel?> signInAsDemo() async {
    // Usuario demo para testing
    return signIn(email: 'demo@manoslocales.com', password: 'demo123456');
  }

  // ============== MANEJO DE ERRORES ==============
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'La contraseña es muy débil';
      case 'email-already-in-use':
        return 'Este email ya está registrado';
      case 'user-not-found':
        return 'Usuario no encontrado';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'invalid-email':
        return 'Email inválido';
      case 'user-disabled':
        return 'Usuario deshabilitado';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde';
      default:
        return 'Error de autenticación: ${e.message}';
    }
  }
}
