import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_firbase/admin/add/addslider_carditem.dart';
import 'package:e_commerce_firbase/admin/update/updateslider_carditem.dart';
import 'package:flutter/material.dart';

import '../Utlis/utlis.dart';

class AdminSliderImageItem extends StatefulWidget {
  const AdminSliderImageItem({Key? key}) : super(key: key);

  @override
  State<AdminSliderImageItem> createState() => _AdminSliderImageItemState();
}

class _AdminSliderImageItemState extends State<AdminSliderImageItem> {
  Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("carousel-slider").snapshots();

  UpDate(cource_id, img) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (builder) => UodateSliderItem(
              docmentID: cource_id,
              img: img,
            )));
  }

  Future<void> deleteUser(selectedData) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('carousel-slider');
    return users.doc(selectedData).delete().then((value) {
      print("User Deleted");
      Utlis().toastMessage("Delet");
    }).catchError((error) {
      Utlis().toastMessage(error.toString());
      print("Failed to delete user: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("AdminSliderImageItem Page"),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.image))],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddSliderItem()));
          },
          child: Icon(Icons.add),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      print("eroooooooo");
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;

                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Stack(
                            children: [
                              Card(
                                elevation: 2,
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Card(
                                          elevation: 4,
                                          child: Container(
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.network(
                                                  data["img-path"],
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              Positioned(
                                  child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        UpDate(
                                            document.id,
                                            data["img-path"]);
                                      },
                                      icon: Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                           deleteUser(document.id);
                                        });
                                      },
                                      icon: Icon(Icons.delete)),
                                ],
                              ))
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
