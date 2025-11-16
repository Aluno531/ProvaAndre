import 'package:cloud_firestore/cloud_firestore.dart';

class Abastecimento {
  final String id;
  final String veiculoId;
  final double quantidadeLitros;
  final double valorTotal;
  final DateTime data;

  Abastecimento({
    required this.id,
    required this.veiculoId,
    required this.quantidadeLitros,
    required this.valorTotal,
    required this.data,
  });

  factory Abastecimento.fromMap(String id, Map<String, dynamic> map) {
    return Abastecimento(
      id: id,
      veiculoId: map["veiculoId"],
      quantidadeLitros: map["quantidadeLitros"],
      valorTotal: map["valorTotal"],
      data: (map["data"] as Timestamp).toDate(),
    );
  }
}
