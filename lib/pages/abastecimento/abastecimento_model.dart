import 'package:cloud_firestore/cloud_firestore.dart';

class Abastecimento {
  final String id;
  final String veiculoId;
  final double quantidadeLitros;
  final double valorTotal;
  final DateTime data;
  final double consumo; 

  Abastecimento({
    required this.id,
    required this.veiculoId,
    required this.quantidadeLitros,
    required this.valorTotal,
    required this.data,
    required this.consumo, 
  });

  factory Abastecimento.fromMap(String id, Map<String, dynamic> map) {
    return Abastecimento(
      id: id,
      veiculoId: map["veiculoId"],
      quantidadeLitros: map["quantidadeLitros"],
      valorTotal: map["valorTotal"],
      data: (map["data"] as Timestamp).toDate(),
      consumo: map["consumo"] ?? 0, 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "veiculoId": veiculoId,
      "quantidadeLitros": quantidadeLitros,
      "valorTotal": valorTotal,
      "data": data,
      "consumo": consumo, 
    };
  }
}
