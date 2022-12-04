import 'package:flutter/material.dart';

CoustomMaterialButton({required VoidCallback onpressed, required bool loading, required String data}) {
  return MaterialButton(
      onPressed: onpressed,
      minWidth: double.infinity,
      height: 45,
      elevation: 5,
      color: Colors.orange,

      child: loading
          ? CircularProgressIndicator(
              color: Colors.red,
            )
          : Text("$data"));
}
