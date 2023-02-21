import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AppConstant{

  //Colors
  static Color primaryColor = const Color(0xFF4527A0);
  static Color backgroundColor = const Color(0xFFF5F5F5);
  static Color buttonColor = const Color(0xFF5E35B1);
  static Color primaryTextDarkColor = const Color(0xFF212121);
  static Color borderColor = const Color(0xFF424242);
  static Color errorColor = const Color(0xFFFF0000);
  static Color grey = Colors.grey.shade400;



  //Fonts
   static String regular = "Ubuntu-Regular";
   static String medium = "Ubuntu-Medium";
   static String bold = "Ubuntu-Bold";


   //Toster
   showToast(String? msg){
     Fluttertoast.showToast(
         msg: msg!,
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.CENTER,
         timeInSecForIosWeb: 1,
         backgroundColor: Colors.black54,
         textColor: Colors.white,
         fontSize: 16.0
     );
   }

}