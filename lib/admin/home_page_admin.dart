import 'package:e_commerce_firbase/admin/SliderImageShow_item.dart';
import 'package:e_commerce_firbase/admin/card_item.dart';
import 'package:e_commerce_firbase/admin/category_item.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Row(children: [
              Expanded(child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminSliderImageItem()));
                },
                child: Card(child: Container(
                    height: 200,
                    child: Center(child: Text("Admin Slider"))),),
              )),
              Expanded(child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminItem()));

                },
                child: Card(child: Container(
                    height: 200,
                    child: Center(child: Text("Admin Prodact"))),),
              )),
            ],),Row(children: [
              Expanded(child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminCategoryItem()));
                },
                child: Card(child: Container(
                    height: 200,
                    child: Center(child: Text("Admin Category"))),),
              )),
              Expanded(child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminItem()));

                },
                child: Card(child: Container(
                    height: 200,
                    child: Center(child: Text("Admin"))),),
              )),
            ],),
          ],
        ),
      ),
    );
  }
}
