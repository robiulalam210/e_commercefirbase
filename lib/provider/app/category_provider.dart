import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_firbase/Utlis/utlis.dart';
import 'package:e_commerce_firbase/admin/category_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  List _categorys = [];

  bool _loding = false;

  bool get loding => _loding;

  setLoding(bool value) {
    _loding = value;
    notifyListeners();
  }

  getCategory() async {
    setLoding(true);

    var _firestoreInstance = FirebaseFirestore.instance;

    QuerySnapshot qn = await _firestoreInstance.collection("category").get();

    for (int i = 0; i < qn.docs.length; i++) {
      _categorys.add({
        "product-name": qn.docs[i]["product-name"],
        "product-img": qn.docs[i]["product-img"],
      });
    }

    return qn.docs;
  }
}
