import 'package:flutter/material.dart';
import '../services/auth_service.dart';

import 'veiculos/veiculos_list_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bem-vindo, ${auth.currentUser?.email}!"),

            const SizedBox(height: 20),

            ElevatedButton(
              child: Text("Gerenciar Veículos"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => VeiculosListPage()),
                );
              },
            ),
          ],
        ),
      ),
    ); 
  }
}
