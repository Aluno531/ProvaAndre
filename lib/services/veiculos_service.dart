import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VeiculosService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

 
  String get uid => _auth.currentUser!.uid;

  
  CollectionReference get veiculosRef =>
      _db.collection('users').doc(uid).collection('veiculos');

  Future adicionarVeiculo(
    String modelo,
    String marca,
    String placa,
    int ano,
    String tipoCombustivel,
  ) async {
    await veiculosRef.add({
      'modelo': modelo,
      'marca': marca,
      'placa': placa,
      'ano': ano,
      'tipoCombustivel': tipoCombustivel,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> listarVeiculos() {
    return veiculosRef.orderBy('createdAt', descending: true).snapshots();
  }
}
