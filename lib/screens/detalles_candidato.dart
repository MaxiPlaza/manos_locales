import 'package:flutter/material.dart';

class FondoEjemplo extends StatelessWidget {
  const FondoEjemplo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_pattern.png'),
            fit: BoxFit.cover, // O BoxFit.fill si querés que estire
          ),
        ),
        child: Center(
          child: Text(
            'Hola!',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
