import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'veiculos_model.dart';

class EditVeiculosPage extends StatefulWidget {
  final Veiculo veiculo;

  EditVeiculosPage({required this.veiculo});

  @override
  _EditVeiculosPageState createState() => _EditVeiculosPageState();
}

class _EditVeiculosPageState extends State<EditVeiculosPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  late TextEditingController modeloCtrl;
  late TextEditingController marcaCtrl;
  late TextEditingController placaCtrl;
  late TextEditingController anoCtrl;

  late String combustivelSelecionado;

  final combustiveis = ["Álcool", "Gasolina", "Diesel"];

  @override
  void initState() {
    super.initState();

    modeloCtrl = TextEditingController(text: widget.veiculo.modelo);
    marcaCtrl = TextEditingController(text: widget.veiculo.marca);
    placaCtrl = TextEditingController(text: widget.veiculo.placa);
    anoCtrl = TextEditingController(text: widget.veiculo.ano.toString());

    combustivelSelecionado = widget.veiculo.tipoCombustivel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Editar Veículo")),
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
              decoration: InputDecoration(labelText: "Ano"),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 10),

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
                  combustivelSelecionado = value!;
                });
              },
            ),

            SizedBox(height: 20),

            ElevatedButton(
              child: Text("Atualizar"),
              onPressed: () async {
                await db
                    .collection("users")
                    .doc(auth.currentUser!.uid)
                    .collection("veiculos")
                    .doc(widget.veiculo.id)
                    .update({
                  "modelo": modeloCtrl.text,
                  "marca": marcaCtrl.text,
                  "placa": placaCtrl.text,
                  "ano": int.parse(anoCtrl.text),
                  "tipoCombustivel": combustivelSelecionado,
                });

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
