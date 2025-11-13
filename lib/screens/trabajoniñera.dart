import 'package:flutter/material.dart';
import 'package:proyecto_final/main.dart';

class Trabajo11 extends StatelessWidget {
  const Trabajo11({super.key});

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
        shrinkWrap: true, 
        children: [
          mistrabajos(),
          SizedBox(height: 20),
          reparaciondepc(),
          SizedBox(height: 20),
          campodescripcion(),
          SizedBox(height: 20),
          info(),
          SizedBox(height: 20),
          proceso()
        ],
      ),
    ),
  );
}

Widget mistrabajos(){
  return Column(
    children: [
      Text(
        "Mis Trabajos", 
        style: TextStyle(
          color: Colors.white, 
          fontSize: 25, 
          fontWeight: FontWeight.bold
        ),
      ),
    ],
  );
}

Widget reparaciondepc(){
  return Column(
    children: [
      Text(
        "Busco Niñera",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w400
        ),
      ),
      SizedBox(height: 8),
      Text(
        "De Carral",
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w300
        ),
      ),
    ],
  );
}

Widget campodescripcion(){
  return Column(
    children: [
      Text(
        "Descripción",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20
        ),
      ),
      Text(
        "Busco niñera responsable y de confianza. Estoy buscando una niñera con experiencia en el cuidado de niños, que sea cariñosa, paciente y puntual. La tarea consiste en acompañar a mi hijo/a durante ciertas horas del día, ayudando con juegos, meriendas y rutinas básicas.",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w300,
          fontSize: 17
        ),
      )
    ],
  );
}

Widget info(){
  return Column(
    children: [
      Text(
        "Informacion Adicional",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
      SizedBox(height: 20),
      ubi(),
      SizedBox(height: 8),
      sueldo()
    ],
  );
}

Widget ubi(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.location_on, color: Colors.white),
      SizedBox(width: 8),
      Text("Circulo Uno", style: TextStyle(color: Colors.white,fontSize: 18),)
    ],
  );
}

Widget sueldo(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.attach_money, color: Colors.white),
      SizedBox(width: 2),
      Text("Sueldo: Negociable", style: TextStyle(color: Colors.white,fontSize: 18),)
    ],
  );
}

Widget proceso(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.access_time, color: Colors.white, size: 60),
      SizedBox(width: 10),
      Text("Finalizado", style: TextStyle(color: Colors.white,fontSize: 40),)
    ],
  );
}