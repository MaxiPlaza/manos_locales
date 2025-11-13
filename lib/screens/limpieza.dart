import 'package:flutter/material.dart';
import 'package:proyecto_final/main.dart';
import 'package:proyecto_final/pages/perfil.dart';

class Paglimpieza extends StatelessWidget {
  const Paglimpieza({super.key});

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
                      MaterialPageRoute route = MaterialPageRoute(builder: (context) => const MyApp());
                      Navigator.push(context, route);           
                    },
            ),
          ),
          Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 100),
                misservicios(),
                SizedBox(height: 50),
                busca(),
                SizedBox(height: 15),
                encargado(),
                solicitud2(),
                SizedBox(height: 70),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget misservicios(){
  return Column(
    children: [
      Text(
        "Mis Servicios", 
        style: TextStyle(
          color: Colors.white, 
          fontSize: 35, 
          fontWeight: FontWeight.bold
        ),
      ),
    ],
  );
}

Widget busca(){
  return Column(
    children: [
      Text(
        "Busco personal de limpieza", 
        style: TextStyle(
          color: Colors.white, 
          fontSize: 25, 
          fontWeight: FontWeight.bold
        ),
      ),
    ],
  );
}

Widget encargado(){
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.black,
      border: Border.all(color: Colors.blue, width: 2),
    ),
    child: Center(
      child: Text("Encargado", style: TextStyle(color: Colors.white)),
    ),
  );
}

Widget solicitud2(){
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.black,
      border: Border.all(color: Colors.blue, width: 2),
    ),
    child: Column(
      children: [
        persona1(),
      ],
    ),
  );
}

Widget persona1(){
  return Builder( 
    builder: (context){        
      return GestureDetector(
        onTap: () {
          MaterialPageRoute route = MaterialPageRoute(builder: (context) => const Perfil());
          Navigator.push(context, route);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Row(
            children:[ 
              Icon(Icons.person, color: Colors.white, size: 30,),
              SizedBox(width: 8),
              Text(
                "Ludmila Gorriti", 
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                )
              ),
              SizedBox(width: 40),
              pendiente()
            ]
          ),
        ),
      );
    }
  );
}

Widget pendiente(){
  return Row(
      children:[ 
        Icon(Icons.access_time, color: Colors.orange,),
        SizedBox(width: 8),
        Text(
        "Pendiente", 
        style: TextStyle(
          color: Colors.orange, 
          fontSize: 10,
          fontWeight: FontWeight.bold
          )
        )
      ]
    );
}

