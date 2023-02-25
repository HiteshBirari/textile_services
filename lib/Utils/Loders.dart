


import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:textile_service/Utils/app_constant.dart';


Widget loaderView(BuildContext context,{var loadcolor,var backgroundcolor}) => Center(
  child: Container(
      color: Colors.transparent,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: backgroundcolor ?? AppConstant.backgroundColor ,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(3),
          child:  SizedBox(
            width: 35,
            height: 35,
            child: SpinKitCircle(
              color:loadcolor,
              size: 32.0,
            ),
          ),
        ),
      )),
);

buildsmallLoadingView(BuildContext context,{var loadcolor:Colors.white}) {
  return Theme(
    data: Theme.of(context).copyWith(accentColor:loadcolor ),
    child: SpinKitCircle(
      color:loadcolor,
      size: 32.0,
    ),
  );
}