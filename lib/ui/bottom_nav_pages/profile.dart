import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController ?_nameController;
  TextEditingController ?_phoneController;
  TextEditingController ?_ageController;
  TextEditingController ?_dobController;


  setDataToTextField(data){
    return  Container(
      width: double.infinity,
      child: Card(
        elevation: 7,
        child: Container(
          margin:  EdgeInsets.all(8.0),
          padding:  EdgeInsets.all(8.0),


          child: Column(
            children: [
              TextFormField(
                controller: _nameController = TextEditingController(text: data['name']),
              ),SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              TextFormField(
                controller: _phoneController = TextEditingController(text: data['phone']),
              ),SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              TextFormField(
                controller: _ageController = TextEditingController(text: data['age']),
              ), SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),  TextFormField(
                controller: _ageController = TextEditingController(text: data['dob']),
              ),SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              ElevatedButton(onPressed: ()=>updateData(), child: Text("Update"))
            ],
          ),
        ),
      ),
    );
  }

  updateData(){
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update(
        {
          "name":_nameController!.text,
          "phone":_phoneController!.text,
          "age":_ageController!.text,
          "dob":_dobController!.text,
        }
        ).then((value) => print("Updated Successfully"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users-form-data").doc(FirebaseAuth.instance.currentUser!.email).snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              var data = snapshot.data;
              if(data==null){
                return Center(child: CircularProgressIndicator(),);
              }
              return setDataToTextField(data);
            },

          ),
        ),
      )),
    );
  }
}
