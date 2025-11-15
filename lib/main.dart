import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Arquivo gerado pelo FlutterFire CLI
import 'firebase_options.dart';


import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Rota inicial
      initialRoute: '/',

      // Definição de rotas
      routes: {
        '/': (_) => const LoginPage(),
        '/home': (_) => HomePage(),
      },
    );
  }
}
