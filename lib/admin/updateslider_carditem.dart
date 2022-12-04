import 'dart:io';

import 'package:e_commerce_firbase/Utlis/utlis.dart';
import 'package:e_commerce_firbase/admin/card_item.dart';
import 'package:e_commerce_firbase/provider/admin_add_provider.dart';
import 'package:e_commerce_firbase/widgets/coustom_button.dart';
import 'package:e_commerce_firbase/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UodateSliderItem extends StatefulWidget {
   UodateSliderItem({Key? key,required this.img,required this.docmentID}) : super(key: key);

  String img,docmentID;
  @override
  State<UodateSliderItem> createState() => _UodateSliderItemState();
}

class _UodateSliderItemState extends State<UodateSliderItem> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  bool loading = false;

  final picker = ImagePicker();
  File? _images;
  XFile? _courseImages;

  Future getImageGallery() async {
    _courseImages = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (_courseImages != null) {
        _images = File(_courseImages!.path);
      } else {
        print("no images selected");
      }
    });
  }

  Future getCamraImage() async {
    _courseImages = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (_courseImages != null) {
        _images = File(_courseImages!.path);
      } else {
        print("no images selected");
      }
    });
  }

  dilogBox(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      getCamraImage();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.camera),
                      title: Text("Camra"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getImageGallery();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.image),
                      title: Text("Gallery"),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    dilogBox(context);
                  },
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 1,
                      child: _images != null
                          ? ClipRRect(
                              child: Image.file(
                              _images!.absolute,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ))
                          : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20)),
                        height: 100,
                        width: 100,
                        child: Image.network(
                          widget.img,
                        ),
                      ))
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                CoustomMaterialButton(
                    onpressed: () async {
                      setState(() {
                        loading = true;

                      });
                      UpdateData(widget.docmentID);


                    },
                    loading: loading,
                    data: 'Add Data'),
              ],
            )),
      ),
    );
  }
  UpdateData(selectdata) async {
    if (_courseImages != null) {
      loading = true;
      FirebaseStorage storage = await FirebaseStorage.instance;
      UploadTask uploadTask =
      storage.ref("products").child(_courseImages!.name).putFile(_images!);

      TaskSnapshot _snapshot = await uploadTask.whenComplete(() {});

      await _snapshot.ref.getDownloadURL().then((url) async {
        await FirebaseFirestore.instance
            .collection("products")
            .doc(selectdata)
            .update(({

          "product-img": url
        }))
            .then((value) {
          Utlis().toastMessage("Sucessfull");
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(builder: (context) => HomePage()),
          //         (route) => false);
          setState(() {
            loading = false;
          });
        }).onError((error, stackTrace) {
          Utlis().toastMessage(error.toString());
          setState(() {
            loading = false;
          });
        });
      });
    } else {
      loading = false;
      FirebaseStorage storage = await FirebaseStorage.instance;
      UploadTask uploadTask =
      storage.ref("products").child(_courseImages!.name).putFile(_images!);
      TaskSnapshot _snapshot = await uploadTask.whenComplete(() {});
      await _snapshot.ref.getDownloadURL().then((img) async {
        await FirebaseFirestore.instance
            .collection("products")
            .doc(selectdata)//problem image reqer
            .update(({
          "product-img": widget.img
        }))
            .then((value) {
          Utlis().toastMessage("Sucessfull");
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(builder: (context) => HomePage()),
          //         (route) => false);
          setState(() {
            loading = false;
          });
        }).onError((error, stackTrace) {
          Utlis().toastMessage(error.toString());
          setState(() {
            loading = false;
          });
        });
      });
    }
  }
}
