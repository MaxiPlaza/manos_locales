import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_screen.dart';
import 'onboarding1_screen.dart';
import 'onboarding2_screen.dart';
import 'onboarding3_screen.dart';
import 'terms_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import '../services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manos Locales',
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      home: const SplashScreen(),
      routes: {
        '/onboarding1': (context) => const Onboarding1Screen(),
        '/onboarding2': (context) => const Onboarding2Screen(),
        '/onboarding3': (context) => const Onboarding3Screen(),
        '/terms': (context) => const TermsScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }

  ThemeData _buildAppTheme() {
    const Color kPrimary = Color(0xFF5B6BFF);
    const Color kBg = Color(0xFF0E1220);
    const Color kCard = Color(0xFF0F1630);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: kPrimary,
      scaffoldBackgroundColor: kBg,
      cardColor: kCard,
      appBarTheme: const AppBarTheme(backgroundColor: kBg, elevation: 0),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontSize: 14),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Manos Locales - Home')),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bienvenido a Manos Locales!',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    // cerrar sesión con el servicio de Auth
                    try {
                      // Usamos AuthService para cerrar sesión correctamente
                      final auth = AuthService();
                      await auth.signOut();
                    } catch (_) {}
                    // limpiar flag local
                    final sp = await SharedPreferences.getInstance();
                    await sp.setBool('loggedIn', false);
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                            (route) => false,
                      );
                    }
                  },
                  child: const Text('Cerrar sesión (demo)'),
                ),
              ],
            ),
             ),
            );
      }
}