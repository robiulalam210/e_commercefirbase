import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_firbase/Utlis/utlis.dart';
import 'package:e_commerce_firbase/admin/card_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AdminAddProvider with ChangeNotifier{
  bool _loding = false;

  bool get loding => _loding;

  setLoding(bool value) {
    _loding = value;
    notifyListeners();
  }


  sendData(title,discreption,price,img,BuildContext context) async {
    setLoding(true);


    await FirebaseFirestore.instance.collection("products")
        .add(({
      "product-name": title,
      "product-description": discreption,
      "product-price": price,
      "product-img": img
    }))
        .then((value) {
      Utlis().toastMessage("Sucessfull");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminItem()));
      setLoding(false);
    }).onError((error, stackTrace) {
      Utlis().toastMessage(error.toString());

      setLoding(false);

    });
  }


}