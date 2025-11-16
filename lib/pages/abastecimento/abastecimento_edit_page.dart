import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/veiculos_service.dart';
import '../veiculos/veiculos_model.dart';
import 'abastecimento_model.dart';
import 'abastecimento_service.dart';

class EditAbastecimentoPage extends StatefulWidget {
  final Abastecimento abastecimento;

  EditAbastecimentoPage({required this.abastecimento});

  @override
  _EditAbastecimentoPageState createState() => _EditAbastecimentoPageState();
}

class _EditAbastecimentoPageState extends State<EditAbastecimentoPage> {
  final service = AbastecimentoService();
  final veiculosService = VeiculosService();

  final litrosCtrl = TextEditingController();
  final valorCtrl = TextEditingController();

  String? veiculoSelecionado;

  @override
  void initState() {
    super.initState();
    litrosCtrl.text = widget.abastecimento.quantidadeLitros.toString();
    valorCtrl.text = widget.abastecimento.valorTotal.toString();
    veiculoSelecionado = widget.abastecimento.veiculoId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Editar Abastecimento")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            
            FutureBuilder<DocumentSnapshot>(
              future: veiculosService.veiculosRef
                  .doc(widget.abastecimento.veiculoId)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                final data = snapshot.data!.data() as Map<String, dynamic>;
                final veiculo = Veiculo.fromMap(widget.abastecimento.veiculoId, data);

                return TextFormField(
                  decoration: InputDecoration(labelText: "Veículo"),
                  initialValue: "${veiculo.modelo} - ${veiculo.placa}",
                  enabled: false,
                );
              },
            ),

            SizedBox(height: 12),

            TextField(
              controller: litrosCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Litros"),
            ),

            TextField(
              controller: valorCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Valor Total"),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              child: Text("Atualizar"),
              onPressed: () async {
                await service.atualizar(widget.abastecimento.id, {
                  "quantidadeLitros": double.parse(litrosCtrl.text),
                  "valorTotal": double.parse(valorCtrl.text),

                  
                  "veiculoId": widget.abastecimento.veiculoId,
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
