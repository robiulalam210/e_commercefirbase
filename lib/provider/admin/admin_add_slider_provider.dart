import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_firbase/Utlis/utlis.dart';
import 'package:e_commerce_firbase/admin/category_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AdminAddSliderProvider with ChangeNotifier{
  bool _loding = false;

  bool get loding => _loding;

  setLoding(bool value) {
    _loding = value;
    notifyListeners();
  }


  sendData(imgUrl,BuildContext context) async {
    setLoding(true);



    await FirebaseFirestore.instance
        .collection("carousel-slider")
        .add(({"img-path": imgUrl}))
        .then((value) {
      Utlis().toastMessage("Sucessfull");
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (context) => AdminI()),
      //         (route) => false);

      setLoding(false);

    }).onError((error, stackTrace) {
      Utlis().toastMessage(error.toString());

      setLoding(false);

    });
  }


}