import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AbastecimentoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  CollectionReference get abastecimentosRef =>
      _db.collection("users").doc(uid).collection("abastecimentos");

  
  Future adicionarAbastecimento(
    String veiculoId,
    double litros,
    double kmRodados, 
    double valor,
  ) async {
    double consumo = kmRodados > 0 ? litros / kmRodados : 0; 

    await abastecimentosRef.add({
      "veiculoId": veiculoId,
      "quantidadeLitros": litros,
      "valorTotal": valor,
      "data": Timestamp.now(),
      "consumo": consumo, 
    });
  }

  Stream<QuerySnapshot> listarAbastecimentos() {
    return abastecimentosRef.orderBy("data", descending: true).snapshots();
  }

  Future atualizar(String id, Map<String, dynamic> dados) async {
    await abastecimentosRef.doc(id).update(dados);
  }

  Future deletar(String id) async {
    await abastecimentosRef.doc(id).delete();
  }
}
