import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddVeiculosPage extends StatefulWidget {
  @override
  _AddVeiculosPageState createState() => _AddVeiculosPageState();
}

class _AddVeiculosPageState extends State<AddVeiculosPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController modeloCtrl = TextEditingController();
  final TextEditingController marcaCtrl = TextEditingController();
  final TextEditingController placaCtrl = TextEditingController();
  final TextEditingController anoCtrl = TextEditingController();

  String? combustivelSelecionado;
  final combustiveis = ["Álcool", "Gasolina", "Diesel"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adicionar Veículo")),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: modeloCtrl,
              decoration: InputDecoration(labelText: "Modelo"),
            ),
            TextField(
              controller: marcaCtrl,
              decoration: InputDecoration(labelText: "Marca"),
            ),
            TextField(
              controller: placaCtrl,
              decoration: InputDecoration(labelText: "Placa"),
            ),
            TextField(
              controller: anoCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Ano"),
            ),

            SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: combustivelSelecionado,
              decoration: InputDecoration(labelText: "Tipo de Combustível"),
              items: combustiveis.map((tipo) {
                return DropdownMenuItem(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  combustivelSelecionado = value;
                });
              },
            ),

            SizedBox(height: 20),

            ElevatedButton(
              child: Text("Salvar"),
              onPressed: () async {
                if (combustivelSelecionado == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Selecione o tipo de combustível")),
                  );
                  return;
                }

                final uid = auth.currentUser!.uid;

                await db
                    .collection("users")
                    .doc(uid)
                    .collection("veiculos")
                    .add({
                  "modelo": modeloCtrl.text,
                  "marca": marcaCtrl.text,
                  "placa": placaCtrl.text,
                  "ano": int.parse(anoCtrl.text),
                  "tipoCombustivel": combustivelSelecionado,
                  "createdAt": Timestamp.now(),
                });

                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
