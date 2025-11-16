import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'veiculos_model.dart';

import 'add_veiculos_page.dart';
import 'edit_veiculos_page.dart';

class VeiculosListPage extends StatelessWidget {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  VeiculosListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Veículos"),
       titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
      backgroundColor: Colors.blue, 
      ),

  


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddVeiculosPage()),
          );
        },
        child: Icon(Icons.add),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("veiculos")
          .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty)
            return Center(child: Text("Nenhum veículo cadastrado."));

          return ListView(
            children: docs.map((doc) {
              final veiculo = 
                Veiculo.fromMap(doc.id, doc.data() as Map<String, dynamic>);

              return Card(
                child: ListTile(
                  title: Text(veiculo.modelo),
                  subtitle: Text(
                    "${veiculo.marca} - ${veiculo.placa}\n"
                    "Ano: ${veiculo.ano}  •  Combustível: ${veiculo.tipoCombustivel}",
                  ),
                  isThreeLine: true,

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditVeiculosPage(veiculo: veiculo),
                            ),
                          );
                        },
                      ),

                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          db
                            .collection("users")
                            .doc(auth.currentUser!.uid)
                            .collection("veiculos")
                            .doc(veiculo.id)
                            .delete();
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
