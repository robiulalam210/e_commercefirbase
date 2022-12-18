import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_firbase/admin/add/add_category_item.dart';
import 'package:e_commerce_firbase/admin/update/update_category.dart';
import 'package:flutter/material.dart';

import '../Utlis/utlis.dart';
import 'SliderImageShow_item.dart';

class AdminCategoryItem extends StatefulWidget {
  const AdminCategoryItem({Key? key}) : super(key: key);

  @override
  State<AdminCategoryItem> createState() => _AdminCategoryItemState();
}

class _AdminCategoryItemState extends State<AdminCategoryItem> {
  Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("category").snapshots();

  UpDate(cource_id, cource_title, img) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (builder) => UpdateCategory(
              docmentID: cource_id,
              title: cource_title,
              img: img,
            )));
  }

  Future<void> deleteUser(selectedData) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('category');
    return users.doc(selectedData).delete().then((value) {
      print("User Deleted");
      Utlis().toastMessage("Delete");
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
          title: Text("Category Page"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddCategoryItem()));
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
                          child: Card(
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
                                              data["product-img"],
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Text(
                                            data["product-name"],
                                            style: TextStyle(fontSize: 22),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    UpDate(
                                                        document.id,
                                                        data["product-name"],
                                                        data["product-img"]);
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
                                          )
                                        ],
                                      ),
                                    ))
                              ],
                            ),
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
