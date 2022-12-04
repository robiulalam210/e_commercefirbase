import 'package:e_commerce_firbase/const/AppColors.dart';
import 'package:flutter/material.dart';

Widget customButton (String buttonText,onPressed){
  return SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(

      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
            color: Colors.white, fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.deep_orange,


        elevation: 3,
      ),
    ),
  );
}