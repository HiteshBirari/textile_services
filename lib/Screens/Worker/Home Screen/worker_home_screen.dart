import 'package:flutter/material.dart';
import 'package:textile_service/Utils/app_constant.dart';

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({Key? key}) : super(key: key);

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.backgroundColor,
      body: SafeArea(
          child: Center(
         child: Text("Worker Home Screen",
           style: TextStyle(
             fontSize: 18,
             fontFamily: AppConstant.medium,
             color: AppConstant.primaryTextDarkColor
           ),
         ),
      )),
    );
  }
}
