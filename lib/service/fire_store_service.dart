


import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<List<Map<String,dynamic>>> getAllProduct() async {
    List<Map<String,dynamic>> products = [];
    final data = await _fireStore.collection("fakeData").get();
    if (data.docs.isNotEmpty) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> element in data.docs) {
        products.add(element.data());
      }
    }
    return products;
  }
}
