import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_firbase/Utlis/utlis.dart';
import 'package:e_commerce_firbase/admin/category_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AdminAddCategoryProvider with ChangeNotifier{
  bool _loding = false;

  bool get loding => _loding;

  setLoding(bool value) {
    _loding = value;
    notifyListeners();
  }


  sendData(title,img,BuildContext context) async {
    setLoding(true);


    await FirebaseFirestore.instance.collection("category")
        .add(({
      "product-name": title,
      "product-img": img
    }))
        .then((value) {
      Utlis().toastMessage("Sucessfull");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminCategoryItem()));
      setLoding(false);
    }).onError((error, stackTrace) {
      Utlis().toastMessage(error.toString());

      setLoding(false);

    });
  }


}