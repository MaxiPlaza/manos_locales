import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class CambiarCorreoScreen extends StatefulWidget {
  const CambiarCorreoScreen({super.key});

  @override
  State<CambiarCorreoScreen> createState() => _CambiarCorreoScreenState();
}

class _CambiarCorreoScreenState extends State<CambiarCorreoScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _cambiarCorreo() async {
    if (!_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingrese un correo válido'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingrese su contraseña actual'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user != null && user.email != null) {
        // Reautenticar al usuario
        final cred = EmailAuthProvider.credential(
          email: user.email!,
          password: _passwordController.text,
        );
        
        await user.reauthenticateWithCredential(cred);
        
        // Actualizar email en Firebase Auth
        await user.updateEmail(_emailController.text.trim());
        
        // Actualizar email en Firestore
        final userService = Provider.of<UserService>(context, listen: false);
        await userService.updateProfile(
          userId: user.uid,
          email: _emailController.text.trim(),
        );
        
        // Enviar verificación de email
        await user.sendEmailVerification();
        
        Navigator.pop(context);
        _mostrarDialogoExito(context, 
          'Correo cambiado con éxito. Se ha enviado un email de verificación a su nueva dirección.');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Error al cambiar correo';
      if (e.code == 'wrong-password') {
        errorMessage = 'La contraseña es incorrecta';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Este correo ya está en uso';
      } else if (e.code == 'requires-recent-login') {
        errorMessage = 'Por seguridad, debes iniciar sesión nuevamente';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Cambiar correo electrónico',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              
              // Nuevo correo
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  hintText: 'Nuevo correo electrónico',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              
              // Contraseña actual
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  hintText: 'Contraseña actual',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 30),
              
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _cambiarCorreo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF253791),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Guardar cambios',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _mostrarDialogoExito(BuildContext context, String mensaje) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF0F1B5B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.only(top: 10, right: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      title: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close, color: Colors.white),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 55),
          const SizedBox(height: 15),
          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Aceptar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}