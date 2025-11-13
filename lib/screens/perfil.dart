import 'package:flutter/material.dart';
import 'package:proyecto_final/pages/misservicios.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/fondo.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 60),
                perfil()
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget perfil(){
  return Column(
    children: [
      Text(
        "Perfil", 
        style: TextStyle(
          color: Colors.white, 
          fontSize: 35, 
          fontWeight: FontWeight.w700
        ),
      ),
      Icon(Icons.person, color: Colors.white, size: 90,),
      Text(
        "Ludmila",
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w400
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_on, color: Colors.white),
          SizedBox(width: 10),
          Text(
            "Salta, San Remo",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15
            ),
          )
        ],
      ),
      SizedBox(height: 30),
      sobremi(),
      SizedBox(height: 40),
      contratarrechazar()
    ],
  );
}

Widget sobremi(){
  return Column(
    children: [
      Text(
        "Sobre mi",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Soy técnica en informática con experiencia en mantenimiento de computadoras, instalación de software, reparación de hardware, configuración de redes y asesoramiento técnico general",
        style: TextStyle(
          color: Colors.white,
          fontSize: 15
        ),
      ),
    ],
  );
}

Widget contratarrechazar() {
  return Row(
    children: [
      Expanded(
        child: Builder( 
          builder: (context){        
            return GestureDetector(
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(builder: (context) => const Mistrabajos1());
                Navigator.push(context, route);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Center(
                  child: Text("Contratar", style: TextStyle(color: Colors.white)),
                    ),
              ),
            );
          }
        ),
      ),
      SizedBox(width: 20),
      Expanded(
        child: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(builder: (context) => const Mistrabajos1());
                Navigator.push(context, route);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Center(
                  child: Text("Rechazar", style: TextStyle(color: Colors.white)),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
