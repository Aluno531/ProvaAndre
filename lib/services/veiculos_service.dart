import 'package:cloud_firestore/cloud_firestore.dart';

class VeiculosService {
  final CollectionReference veiculos =
      FirebaseFirestore.instance.collection('veiculos');

  Future adicionarVeiculo(
    String modelo,
    String marca,
    String placa,
    String ano,
    String tipoCombustivel,
  ) async {
    await veiculos.add({
      'modelo': modelo,
      'marca': marca,
      'placa': placa,
      'ano': ano,
      'tipoCombustivel': tipoCombustivel,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> listarVeiculos() {
    return veiculos.orderBy('createdAt', descending: true).snapshots();
  }
}
