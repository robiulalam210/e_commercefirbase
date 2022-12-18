import 'dart:io';

import 'package:e_commerce_firbase/Utlis/utlis.dart';
import 'package:e_commerce_firbase/provider/admin/admin_add_slider_provider.dart';
import 'package:e_commerce_firbase/widgets/coustom_button.dart';
import 'package:e_commerce_firbase/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddSliderItem extends StatefulWidget {
  const AddSliderItem({Key? key}) : super(key: key);

  @override
  State<AddSliderItem> createState() => _AddPostItemState();
}

class _AddPostItemState extends State<AddSliderItem> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

 // bool loading = false;
  final _key = GlobalKey<FormState>();

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
    final addsliderProvider=Provider.of<AdminAddSliderProvider>(context);
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
                              child: Icon(Icons.camera),
                            )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                CoustomMaterialButton(
                    onpressed: () async {

                      addsliderProvider.setLoding(true);

                      FirebaseStorage storage = await FirebaseStorage.instance;
                      UploadTask uploadTask =
                      storage.ref("carousel-slider").child(_courseImages!.name).putFile(_images!);
                      TaskSnapshot _snapshot = await uploadTask;
                      var imgUrl = await _snapshot.ref.getDownloadURL();
                    addsliderProvider.sendData(imgUrl, context);


                    },
                    loading: addsliderProvider.loding,
                    data: 'Add Data'),
              ],
            )),
      ),
    );
  }
  //
  // sendData() async {
  //   loading = true;
  //   FirebaseStorage storage = await FirebaseStorage.instance;
  //   UploadTask uploadTask =
  //       storage.ref("carousel-slider").child(_courseImages!.name).putFile(_images!);
  //   TaskSnapshot _snapshot = await uploadTask;
  //   var imgUrl = await _snapshot.ref.getDownloadURL();
  //
  //   await FirebaseFirestore.instance
  //       .collection("carousel-slider")
  //       .add(({"img-path": imgUrl}))
  //       .then((value) {
  //     Utlis().toastMessage("Sucessfull");
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => AdminItem()),
  //         (route) => false);
  //     setState(() {
  //       loading = false;
  //     });
  //   }).onError((error, stackTrace) {
  //     Utlis().toastMessage(error.toString());
  //     setState(() {
  //       loading = false;
  //     });
  //   });
  // }
}
