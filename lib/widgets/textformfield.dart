import 'package:flutter/material.dart';


 CoustomTextFormField(
     { required TextEditingController controller,
    required String data_return,
    required bool obsText,
    required Widget icon,
    required String hintText}) {

  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.text,
    validator: (value) {
      if (value!.isEmpty) {
        return "$data_return";
      }
      return null;
    },
    obscureText: obsText,
    style: TextStyle(color: Colors.black),
    cursorRadius: Radius.circular(10),
    cursorColor: Color(0xff8A8A8E),
    decoration: InputDecoration(
        fillColor: Colors.black,
        contentPadding: EdgeInsets.all(10),
        focusedBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.blue)),
        enabledBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xff8A8A8E))),
        border: OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(20))),
        prefixIcon: icon,
        prefixIconColor: Color(0xff8A8A8E).withOpacity(0.7),
        suffixIconColor: Color(0xff8A8A8E).withOpacity(0.7),
        hintText: hintText,
        hintStyle: TextStyle(color: Color(0xff8A8A8E))),
  );
}