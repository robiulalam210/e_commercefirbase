import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_firbase/Utlis/utlis.dart';
import 'package:e_commerce_firbase/const/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  var _product;

  ProductDetails(this._product);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  var queantity = 1;
  var total_price;
  bool loading = false;

  Future addToCart() async {
    loading = true;
    setState(() {});
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-cart-items");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc()
        .set({
      "name": widget._product["product-name"],
      "price":total_price,
      "images": widget._product["product-img"],
    }).then((value) {
      loading = false;
      setState(() {});
      Utlis().toastMessage("Suessfully");
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => UserForm()));
    }).onError((error, stackTrace) {
      loading = false;
      setState(() {});
      Utlis().toastMessage(error.toString());
    });
  }

  Future addToFavourite() async {
    loading = true;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-favourite-items");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc()
        .set({
      "name": widget._product["product-name"],
      "price": widget._product["product-price"],
      "images": widget._product["product-img"],
    }).then((value) {
      loading = false;
      setState(() {});
      Utlis().toastMessage("Suessfully");
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => UserForm()));
    }).onError((error, stackTrace) {
      loading = false;
      setState(() {});
      Utlis().toastMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.deep_orange,
            child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ),
        ),
        actions: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users-favourite-items")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection("items")
                .where("name", isEqualTo: widget._product['product-name'])
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Text("");
              }
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: loading
                      ? CircularProgressIndicator()
                      : IconButton(
                          onPressed: () => snapshot.data.docs.length == 0
                              ? addToFavourite()
                              : print("Already Added"),
                          icon: snapshot.data.docs.length == 0
                              ? Icon(
                                  Icons.favorite_outline,
                                  color: Colors.white,
                                )
                              : Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(left: 12, right: 12, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                        image: NetworkImage(widget._product["product-img"]),
                        fit: BoxFit.fitWidth)),
              ),
            ),

            // AspectRatio(
            //   aspectRatio: 3.5,
            //   child: CarouselSlider(
            //       items: widget._product['product-img']
            //           .map<Widget>((item) => Padding(
            //                 padding: const EdgeInsets.only(left: 3, right: 3),
            //                 child: Container(
            //                   decoration: BoxDecoration(
            //                       image: DecorationImage(
            //                           image: NetworkImage(item),
            //                           fit: BoxFit.fitWidth)),
            //                 ),
            //               ))
            //           .toList(),
            //       options: CarouselOptions(
            //           autoPlay: false,
            //           enlargeCenterPage: true,
            //           viewportFraction: 0.8,
            //           enlargeStrategy: CenterPageEnlargeStrategy.height,
            //           onPageChanged: (val, carouselPageChangedReason) {
            //             setState(() {});
            //           })),
            // ),
            Text(
              widget._product['product-name'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Text(widget._product['product-description']),
            SizedBox(
              height: 10,
            ),
            Text(
              "\$ ${widget._product['product-price'].toString()}",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 30, color: Colors.red),
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      if (queantity > 1) {
                        setState(() {
                          var price = widget._product['product-price'];
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
                          shape: BoxShape.circle, color: Colors.cyan),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                Text(
                  "$queantity",
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        setState(() {
                          queantity++;
                          var price =
                              widget._product['product-price'];

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
                          shape: BoxShape.circle, color: Colors.cyan),
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
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      child: queantity == 1
                          ? Text(
                              "${widget._product["product-price"].toString()}",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              "$total_price",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                      decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                )
              ],
            ),
            Divider(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => addToCart(),
                child: loading
                    ? CircularProgressIndicator()
                    : Text(
                        "Add to cart",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                style: ElevatedButton.styleFrom(
                  primary: AppColors.deep_orange,
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
