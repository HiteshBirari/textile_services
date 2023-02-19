


import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authentication{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future registration({required String name,required String mobileno,required String email,required String password,required BuildContext context}) async{
    try{
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email.toString(), password: password.toString());
      //     .then((value) {
      //   DocumentReference documentReference = _firestore.collection(
      //       'DistributorData').doc();
      //   Map<String, dynamic> distributorData = {
      //     'Name': name,
      //     'Mobile-Number': mobileno,
      //     'Email': email,
      //     'Password': password
      //   };
      //   documentReference.set(distributorData);
      //
      // });
    }catch(error){
      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Somethings went wrong!',
          message: error.toString(),
          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }


  Future login({required String email, required String password, required BuildContext context}) async{
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    }catch(error){
      print(error.toString());
      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Somethings went wrong!',
          message: error.toString(),
          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }
}