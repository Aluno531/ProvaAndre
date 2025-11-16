import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../veiculos/veiculos_model.dart';
import '../../services/veiculos_service.dart';
import 'abastecimento_service.dart';

class AddAbastecimentoPage extends StatefulWidget {
  @override
  _AddAbastecimentoPageState createState() => _AddAbastecimentoPageState();
}

class _AddAbastecimentoPageState extends State<AddAbastecimentoPage> {
  final abastecimentoService = AbastecimentoService();
  final veiculosService = VeiculosService();

  String? veiculoSelecionado;

  final litrosCtrl = TextEditingController();
  final valorCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Novo Abastecimento")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: veiculosService.listarVeiculos(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return CircularProgressIndicator();

                final veiculos = snapshot.data!.docs;

                if (veiculos.isEmpty)
                  return Text("Cadastre um veículo antes.");

                return DropdownButtonFormField(
                  decoration: InputDecoration(labelText: "Veículo"),
                  value: veiculoSelecionado,
                  items: veiculos.map((v) {
                    final veiculo = Veiculo.fromMap(v.id, v.data() as Map<String, dynamic>);
                    return DropdownMenuItem(
                      value: veiculo.id,
                      child: Text("${veiculo.modelo} - ${veiculo.placa}"),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => veiculoSelecionado = v),
                );
              },
            ),

            TextField(
              controller: litrosCtrl,
              decoration: InputDecoration(labelText: "Litros"),
              keyboardType: TextInputType.number,
            ),

            TextField(
              controller: valorCtrl,
              decoration: InputDecoration(labelText: "Valor Total"),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 20),

            ElevatedButton(
              child: Text("Salvar"),
              onPressed: () async {
                if (veiculoSelecionado == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Selecione um veículo")),
                  );
                  return;
                }

                await abastecimentoService.adicionarAbastecimento(
                  veiculoSelecionado!,
                  double.parse(litrosCtrl.text),
                  double.parse(valorCtrl.text),
                );

                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
