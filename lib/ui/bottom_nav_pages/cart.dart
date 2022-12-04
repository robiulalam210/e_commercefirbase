import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_firbase/widgets/fetchProducts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  var queantity = 1;
  var total_price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users-cart-items")
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .collection("items")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Something is wrong"),
                    );
                  }

                  return ListView.builder(
                      itemCount: snapshot.data == null
                          ? 0
                          : snapshot.data!.docs.length,
                      itemBuilder: (_, index) {
                        DocumentSnapshot _documentSnapshot =
                            snapshot.data!.docs[index];

                        return Column(
                          children: [
                            Card(
                              elevation: 5,
                              child: ListTile(
                                leading: Text(_documentSnapshot['name']),
                                title: Text(
                                  "\$ ${_documentSnapshot['price']}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                                trailing: GestureDetector(
                                  child: CircleAvatar(
                                    child: Icon(Icons.remove_circle),
                                  ),
                                  onTap: () {
                                    FirebaseFirestore.instance
                                        .collection("users-cart-items")
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.email)
                                        .collection("items")
                                        .doc(_documentSnapshot.id)
                                        .delete();
                                  },
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (queantity > 1) {
                                        setState(() {
                                          var price =
                                              _documentSnapshot['price'];
                                          queantity--;

                                          total_price = queantity * price;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(22),
                                      child: Text(
                                        "-",
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.cyan),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                                Text(
                                  "$queantity",
                                  style: TextStyle(fontSize: 22),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        setState(() {
                                          var price =
                                              _documentSnapshot['price'];
                                          queantity++;

                                          total_price = queantity * price;
                                        });
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        "+",
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.cyan),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: InkWell(
                                    onTap: () {
                                      // Navigator.of(context).push(MaterialPageRoute(
                                      //     builder: (context) => CardDetail()));
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 12),
                                      child: queantity == 1
                                          ? Text(
                                              "${_documentSnapshot["price"]}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            )
                                          : Text(
                                              "$total_price",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                      decoration: BoxDecoration(
                                          color: Colors.cyan,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        );
                      });
                },
              ),
            )),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
