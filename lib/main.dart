import 'package:flutter/material.dart';
import 'welcome.dart';
import 'home_screen.dart';
import 'medication_search_screen.dart';


void main() {
  runApp(MedecaiApp());
}

class MedecaiApp extends StatelessWidget {
  const MedecaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medecai',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
        '/search': (context) => MedicationSearchScreen(),
      },
    );
  }
}