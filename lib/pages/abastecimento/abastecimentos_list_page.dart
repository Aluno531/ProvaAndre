import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/veiculos_service.dart';
import '../veiculos/veiculos_model.dart';
import 'abastecimento_service.dart';
import 'abastecimento_model.dart';
import 'abastecimento_add_page.dart';
import 'abastecimento_edit_page.dart';


class AbastecimentosListPage extends StatelessWidget {
  final service = AbastecimentoService();
  final veiculosService = VeiculosService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Abastecimentos"),
       titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
      backgroundColor: Colors.indigo, 
      
      ),


      
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddAbastecimentoPage()),
          );
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: service.listarAbastecimentos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty)
            return Center(child: Text("Nenhum abastecimento registrado."));

          return ListView(
            children: docs.map((doc) {
              final ab = Abastecimento.fromMap(
                doc.id,
                doc.data() as Map<String, dynamic>,
              );

              return FutureBuilder<DocumentSnapshot>(
                future: veiculosService.veiculosRef
                    .doc(ab.veiculoId)
                    .get(),
                builder: (context, veicSnap) {
                  if (!veicSnap.hasData)
                    return Card(
                      child: ListTile(
                        title: Text("Carregando veículo..."),
                      ),
                    );

                  final vData = veicSnap.data!.data() as Map<String, dynamic>;
                  final veiculo = Veiculo.fromMap(ab.veiculoId, vData);

                  return Card(
                    child: ListTile(
                      title: Text(
                        "${veiculo.modelo} • ${veiculo.placa}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Litros: ${ab.quantidadeLitros}\n"
                        "Valor: R\$ ${ab.valorTotal}\n"
                        "Data: ${ab.data}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditAbastecimentoPage(
                                    abastecimento: ab,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => service.deletar(ab.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
