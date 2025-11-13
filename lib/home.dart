import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis Servicios',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF001B3A),
        primaryColor: Colors.blueAccent,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

// 🏠 Pantalla Principal
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF00122B),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF001E4E), Color(0xFF001030)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                // Encabezado
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '¡Hola Roman!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      radius: 22,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Sección: Mis servicios
                _buildSectionCard(
                  title: "Mis servicios",
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ServiceButton(title: "Lavado de auto", onTap: () {}),
                      ServiceButton(title: "Busco personal", onTap: () {}),
                      ServiceButton(title: "Reparación de PC", onTap: () {}),
                      ServiceButton(title: "Busco niñera", onTap: () {}),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Sección: Últimos mensajes / Próximos trabajos
                Row(
                  children: [
                    Expanded(
                      child: _buildSectionCard(
                        title: "Últimos mensajes",
                        child: Column(
                          children: const [
                            MessagePreview(name: "Lucía", message: "Hola, ¿sigue disponible?"),
                            MessagePreview(name: "Mario", message: "Te envié mis datos."),
                            MessagePreview(name: "Jorge", message: "Podría empezar el lunes."),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildSectionCard(
                        title: "Próximos trabajos",
                        child: Column(
                          children: const [
                            MessagePreview(name: "Niñera", message: "Mañana 10:00 AM"),
                            MessagePreview(name: "Lavado", message: "Viernes 14:00"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Sección: Cerca de tu zona
                _buildSectionCard(
                  title: "Cerca de tu zona",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hay nuevas búsquedas activas cerca de tu zona. ¡Anímate a postularte o publicar tu servicio!",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Hacer publicación",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Tarjetas de secciones
  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF002C73).withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

// 🔹 Botón de servicio
class ServiceButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ServiceButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.8),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// 🔹 Vista previa de mensajes
class MessagePreview extends StatelessWidget {
  final String name;
  final String message;

  const MessagePreview({
    super.key,
    required this.name,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue.shade900.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                message,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
            ),
        );
  }
}