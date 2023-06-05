import 'package:cloud_firestore/cloud_firestore.dart';

class SenhaFirestore {
  CollectionReference senhas = FirebaseFirestore.instance.collection('senhas');

  getTodasSenhasUsuario(String idUsuario) {
    return senhas
        .orderBy('nome', descending: true)
        .where('idUsuario', isEqualTo: idUsuario)
        .snapshots();
  }

  snapshotsSenhaId(String idUsuario) {
    return senhas.where('idUsuario', isEqualTo: idUsuario).snapshots();
  }

  postSenhaId(Map<String, dynamic> senha) async {
    return await senhas.doc(senha['idSenha']).set(senha);
  }
}
