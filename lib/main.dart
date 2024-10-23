import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/transaksi_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warnet SIlver Link',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/transaksi': (context) => const TransaksiScreen(),
      },
    );
  }
}
