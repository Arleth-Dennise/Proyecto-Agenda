
import 'package:flutter/material.dart';
import 'package:agenda/calendario.dart';
import 'package:agenda/login_screen.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Registrarse",
          style: TextStyle(color: Colors.white), // Color del texto del título
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 189, 140, 207), // Color del AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 215, 201, 220),
              Color.fromARGB(255, 235, 200, 212),
              Color.fromARGB(255, 209, 200, 238),  
              Color.fromARGB(255, 205, 232, 236),
              Color.fromARGB(255, 205, 240, 208),
            
            ], // Cambiar los colores del fondo
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color.fromARGB(255, 245, 254, 245), // Color del campo de texto
                ),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color.fromARGB(255, 245, 254, 245), // Color del campo de texto
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Calendar()),
                  );
                },
                child: Text(
                  "Registrarse",
                  style: TextStyle(color: Colors.black), // Color del texto del botón
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 132, 202, 172), // Color del botón
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text(
                  "¿Ya tienes una cuenta? Inicia sesión",
                  style: TextStyle(color: Color.fromARGB(255, 16, 86, 19)), // Color del texto del botón
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
