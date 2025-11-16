import 'package:flutter/material.dart';
import 'package:flutter_bom/pages/abastecimento/abastecimento_add_page.dart';
import 'package:flutter_bom/pages/veiculos/add_veiculos_page.dart';
import '../services/auth_service.dart';

import 'veiculos/veiculos_list_page.dart';
import '../pages/abastecimento/abastecimentos_list_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
        backgroundColor: Colors.blue,
      ),

     
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),

            Container(
  color: Colors.blue,   
  child: ListTile(
    leading: Icon(Icons.add_circle_outline, color: Colors.white),
    title: Text("Registrar novo Veículo",
        style: TextStyle(color: Colors.white, fontSize: 18)),
    onTap: () {
     Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddVeiculosPage()),
                );
    },
  ),
),

            Container(
  color: Colors.blue,
  child: ListTile(
    tileColor: Colors.blue, 
    leading: Icon(Icons.directions_car, color: Colors.white),
    title: Text("Meus Veículos", style: TextStyle(color: Colors.white)),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VeiculosListPage()),
      );
    },
  ),
),

            Container(
              color: Colors.indigo,
            child:ListTile(
               tileColor: Colors.indigo, 
              leading: Icon(Icons.local_gas_station , color: Colors.white),
              title: Text("Registrar Abastecimento", style: TextStyle(color: Colors.white)),
              onTap: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddAbastecimentoPage()),
                );
              },
            ),
            ),

            Container(
              
            child:ListTile(
              tileColor:Colors.indigo,
              leading: Icon(Icons.history, color: Colors.white),
              title: Text("Histórico de Abastecimentos", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AbastecimentosListPage()),
                );
              },
            ),
            ),
            

            Divider(),

            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Sair"),
              onTap: () async {
                await auth.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),

 body: Center(
  child: Column(
    mainAxisSize: MainAxisSize.min, 
    children: [
      Text(
        "Posto Aupiranga",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 20),
      Container(
        constraints: BoxConstraints(
          maxWidth: 449,
          maxHeight: 646,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Posto.jpg"),
            fit: BoxFit.contain,
          ),
        ),
        child: Center(
          child: Text(
            "Bem-vindo, ${auth.currentUser?.email}!",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(blurRadius: 5, color: Colors.black)],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ],
  ),
),




    );
  }
}
