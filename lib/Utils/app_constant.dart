import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AppConstant{

  //Colors
  static Color primaryColor = const Color(0xFF512DA8);
  static Color backgroundColor = const Color(0xFFF5F5F5);
  static Color buttonColor = const Color(0xFF5E35B1);
  static Color primaryTextDarkColor = const Color(0xFF212121);
  static Color borderColor = const Color(0xFF424242);
  static Color errorColor = const Color(0xFFFF0000);
  static Color grey = Colors.grey.shade400;
  static Color colorDrawerIcon = const Color(0xff727272);
  static Color successColor = Colors.green;


  //Fonts
   static String regular = "Ubuntu-Regular";
   static String medium = "Ubuntu-Medium";
   static String bold = "Ubuntu-Bold";


   //Toster
   showToast(String? msg){
     Fluttertoast.showToast(
         msg: msg!,
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.BOTTOM,
         timeInSecForIosWeb: 1,
         backgroundColor: Colors.black54,
         textColor: Colors.white,
         fontSize: 16.0
     );
   }

  getTextField(
      String label,
      var txtController, {
        int maxLine: 1,
        int minimum :1,
        required VoidCallback onChanged,
        final FormFieldValidator<String>? validator,
        bool isEnable: true,
        bool isNumber: false,
        var inputFormat,
      }) {
    List<TextInputFormatter> filter = [];
    filter.addAll(inputFormat ?? []);
    if (isNumber) {
      filter.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9]')));
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextFormField(
        controller: txtController,
        inputFormatters: filter,
        maxLines: maxLine,
        minLines: minimum,
        onChanged: (value) {
          onChanged();
        },
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(signed: true, decimal: true)
            : TextInputType.text,
        decoration: InputDecoration(
          filled: false,
          fillColor: isEnable ? Colors.grey[150] : Colors.grey[300],
          enabled: isEnable,
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppConstant.primaryColor),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppConstant.primaryColor),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppConstant.primaryColor),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          contentPadding: const EdgeInsets.fromLTRB(15, 3, 0, 0),
          hintStyle: TextStyle(color: Colors.grey[600]),
        ),
        validator: validator,
      ),
    );
  }

}