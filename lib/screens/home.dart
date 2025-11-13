import 'package:flutter/material.dart';
import 'package:proyecto_final/pages/limpieza.dart';
import 'package:proyecto_final/pages/misservicios.dart';
import 'package:proyecto_final/pages/pagpublicacion.dart';
import 'package:proyecto_final/pages/trabajoni%C3%B1era.dart';
import 'package:proyecto_final/pages/trabajopc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/fondo.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                nombre(),
                const SizedBox(height: 10),
                cuadro(),
                const SizedBox(height: 30),
                doscuadros(),
                const SizedBox(height: 20),
                cuadrofinal(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget nombre() {
  return Column(
    children: const [
      Text(
        "¡Hola (nombre de usuario)!",
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 8),
      Icon(
        Icons.person,
        size: 60,
        color: Colors.white,
      ),
    ],
  );
}

Widget cuadro() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.8),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.blue, width: 2),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Mis Servicios",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const Mistrabajos1(),
                      ));
                    },
                    child: _opcionCuadro("Lavado de Auto"),
                  );
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const Paglimpieza(),
                      ));
                    },
                    child: _opcionCuadro("Busco Personal de Limpieza"),
                  );
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
        const Text(
          "Mis trabajos",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const Trabajo(),
                      ));
                    },
                    child: _opcionCuadro("Reparación de Computadora"),
                  );
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const Trabajo11(),
                      ));
                    },
                    child: _opcionCuadro("Busco Niñera"),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _opcionCuadro(String texto) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.blue, width: 2),
    ),
    child: Center(
      child: Text(
        texto,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget doscuadros() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _panelInfo(
            "Últimos mensajes",
            const ["Lucia", "Mario", "Jorge"],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _panelInfo(
            "Próximos trabajos",
            const [
              "No tienes próximos trabajos asignados para hoy. ¡Asigna ahora!"
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _panelInfo(String titulo, List<String> contenido) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.8),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.blue, width: 2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        for (var texto in contenido)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              texto,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    ),
  );
}

Widget cuadrofinal() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.8),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.blue, width: 2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Cerca de tu zona",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          "Por el momento, no hay trabajos cerca de tu zona. ¡Vuelve pronto u ofrece tú un trabajo!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        botonpublicidad(),
      ],
    ),
  );
}

Widget botonpublicidad() {
  return Builder(
    builder: (context) {
      return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Pagpublicacion()));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue, width: 1.5),
          ),
          child: const Text(
            "Hacer publicidad",
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );
    },
  );
}
