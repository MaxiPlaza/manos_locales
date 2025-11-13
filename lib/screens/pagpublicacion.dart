import 'package:flutter/material.dart';
import 'package:proyecto_final/main.dart';

class Pagpublicacion extends StatelessWidget {
  const Pagpublicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pantalla(),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                MaterialPageRoute route = MaterialPageRoute(builder: (context) => const MyApp());
                Navigator.push(context, route);              
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget pantalla() {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/fondo.jpg"),
        fit: BoxFit.cover,
      ),
    ),
    child: Center(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 80, horizontal: 16),
        shrinkWrap: true, // se adapta al contenido
        children: [
          anadirpuesto(),
        ],
      ),
    ),
  );
}

Widget anadirpuesto(){
  return Column(
    children: [
      Text(
        "Añadir Puesto", 
        style: TextStyle(
          color: Colors.white, 
          fontSize: 35, 
          fontWeight: FontWeight.bold
        ),
      ),
      SizedBox(height: 40),
      cuadrotrabajo(),
      SizedBox(height: 30),
      cuadrodescripcion(),
      SizedBox(height: 30),
      botonpublicar()
    ],
  );
}

Widget cuadrotrabajo() {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Título del trabajo:",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            campotitulo(),
            SizedBox(height: 8),
            listaempleo1(),
            SizedBox(height: 8),
            Text(
              "Ubicacion:",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            campoubicacion(),
            SizedBox(height: 8),
            Text(
              "Pago:",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            campopago(),
          ],
        ),
      ),
    ],
  );
}

Widget campotitulo(){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: TextField(
      decoration: InputDecoration(
        hintText: "Titulo",
        fillColor: Colors.white,
        filled: true
      ),
    ),
  );
}

Widget listaempleo1() {
  final Map<String, bool> opciones = {
    "Servicios de Hogar": false,
    "Tecnologia": false,
    "Automotor": false,
    "Educacion y Clases": false,
    "Servicios Personales": false,
    "Todos": false,
  };

  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      return ExpansionTile(
        title: Row(
          children: [
            Icon(Icons.work, color: Colors.white), 
            SizedBox(width: 8),
            Text(
              "Tipos de Empleos",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        collapsedBackgroundColor: Colors.blue[900],
        backgroundColor: Colors.blue[800],
        iconColor: Colors.white,
        children: opciones.keys.map((String clave) {
          return CheckboxListTile(
            title: Text(
              clave,
              style: TextStyle(color: Colors.white),
            ),
            value: opciones[clave],
            activeColor: Colors.blueAccent,
            checkColor: Colors.white,
            onChanged: (bool? nuevoValor) {
              setState(() {
                opciones[clave] = nuevoValor ?? false;
              });
            },
          );
        }).toList(),
      );
    },
  );
}

Widget campoubicacion(){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: TextField(
      decoration: InputDecoration(
        hintText: "Ubicacion",
        fillColor: Colors.white,
        filled: true
      ),
    ),
  );
}

Widget campopago(){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: TextField(
      decoration: InputDecoration(
        hintText: "Pago",
        fillColor: Colors.white,
        filled: true
      ),
    ),
  );
}

Widget cuadrodescripcion(){
  return Column(
    children: [
      Container(
              padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: Column(
          children: [
            Text(
              "Descripción:",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Descripcion...",
                  fillColor: Colors.white,
                  filled: true
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget botonpublicar() {
  return Builder(
    builder: (context) {
      return GestureDetector(
        onTap: () {
          mostrarAlerta(context);
        },
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.4, 
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12), 
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12), 
              border: Border.all(color: Colors.blue, width: 1.5),
            ),
            child: Center(
              child: Text(
                "Publicar",
                style: TextStyle(color: Colors.white, fontSize: 14), 
              ),
            ),
          ),
        ),
      );
    },
  );
}

void mostrarAlerta(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.blue,
        title: Text(
          "Publicación creada correctamente",              
          style: TextStyle(
            color: Colors.white
          ),
        ),
        content: Text(
          "Tu servicio se ha publicado con éxito. Podés verlo en Mis publicaciones o editarlo cuando quieras. 🎉",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              "Ok", 
              style: TextStyle(
                color: Colors.white
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyApp()),
              );
            },
          ),
        ],
      );
    },
  );
}