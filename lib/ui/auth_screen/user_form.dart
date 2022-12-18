import 'package:e_commerce_firbase/const/AppColors.dart';
import 'package:e_commerce_firbase/provider/auth_provider.dart';
import 'package:e_commerce_firbase/ui/bottom_nav_controller.dart';
import 'package:e_commerce_firbase/widgets/customButton.dart';
import 'package:e_commerce_firbase/widgets/myTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  List<String> gender = ["Male", "Female", "Other"];

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null)
      setState(() {
        _dobController.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
      });
  }

  sendUserDataToDB() async {
    //  Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavController()));
    //
    // final FirebaseAuth _auth = FirebaseAuth.instance;
    // var  currentUser = _auth.currentUser;
    //
    // CollectionReference _collectionRef = FirebaseFirestore.instance.collection("users-form-data");
    // return _collectionRef.doc(currentUser!.email).set({
    //   "name":_nameController.text,
    //   "phone":_phoneController.text,
    //   "dob":_dobController.text,
    //   "gender":_genderController.text,
    //   "age":_ageController.text,
    // }).then((value) => Navigator.push(context, MaterialPageRoute(builder: (_)=>BottomNavController()))).catchError((error)=>print("something is wrong. $error"));
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Submit the form to continue.",
                  style: TextStyle(fontSize: 22, color: AppColors.deep_orange),
                ),
                Text(
                  "We will not share your information with anyone.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFBBBBBB),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                myTextField(
                    "enter your name", TextInputType.text, _nameController),
                myTextField("enter your phone number", TextInputType.number,
                    _phoneController),
                TextField(
                  controller: _dobController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "date of birth",
                    suffixIcon: IconButton(
                      onPressed: () => _selectDateFromPicker(context),
                      icon: Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                ),
                TextField(
                  controller: _genderController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "choose your gender",
                    prefixIcon: DropdownButton<String>(
                      items: gender.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                          onTap: () {
                            setState(() {
                              _genderController.text = value;
                            });
                          },
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                ),
                myTextField(
                    "enter your age", TextInputType.number, _ageController),

                SizedBox(
                  height: 50,
                ),

                // elevated button
               authProvider.loding? CircularProgressIndicator(): customButton("Continue", () {
                  authProvider.sendUserDataToDB(
                      _nameController.text,
                      _phoneController.text,
                      _dobController.text,
                      _genderController.text,
                      _ageController.text,
                      context);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
