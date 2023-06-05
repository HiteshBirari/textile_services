import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:textile_service/Screens/Distributor/Add%20Worker/Database/add_worker_database.dart';
import 'package:textile_service/Screens/Distributor/Add%20Worker/Models/add_worker_model.dart';

import '../../../Utils/ClipperPath.dart';
import '../../../Utils/app_constant.dart';

class AddWorkerScreen extends StatefulWidget {
  const AddWorkerScreen({Key? key}) : super(key: key);

  @override
  State<AddWorkerScreen> createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends State<AddWorkerScreen> {
  RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final key = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  AddWorkerDatabase db = AddWorkerDatabase();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: const Color(0xFFe9f0fb),
      resizeToAvoidBottomInset: false,
      body: Container(
        height: height,
        child: Stack(
          children: [
            Container(
              height: height * 0.80,
              alignment: Alignment.center,
              child: ClipPath(
                clipper: CustomClipPath(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: AppConstant.primaryColor,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: height * 0.04,left:width*0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 45,
                          width: 40,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: AppConstant.backgroundColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(width*0.05, height*0.17, width*0.05, height*0),
              child: Row(
                children: [
                  SvgPicture.asset('Assets/Images/user-add.svg',height:height *0.05,color: AppConstant.backgroundColor,),
                  SizedBox(width: width*0.01,),
                  Text('Add Worker',
                    style: TextStyle(
                        color: AppConstant.backgroundColor,
                        fontSize: width*.06,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Container(
              height: height * 0.70,
              width: width,
              padding: EdgeInsets.only(top: height * 0.01, left: width * 0.05, right: width * 0.05),
              margin: EdgeInsets.fromLTRB(
                  width * 0.05, height * 0.25, width * 0.05, height * 0.09),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  // BoxShape.circle or BoxShape.retangle
                  color: AppConstant.backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppConstant.grey,
                      blurRadius: 5.0,
                    ),
                  ]),
              child: AnimationLimiter(
                  child: Form(
                    key: key,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Column(
                          children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 275),
                            childAnimationBuilder: (widget) => SlideAnimation(
                              verticalOffset: 56.0,
                              child: FadeInAnimation(child: widget),
                            ),
                            children: [
                              AppConstant().getTextField(
                                'Name*',
                                workerName,
                                isNumber: false,
                                inputFormat: [
                                  FilteringTextInputFormatter.deny(
                                      RegExp(r'[^a-zA-Z\s]')),
                                ],
                                onChanged: () {
                                  if(workerPhoneNumber.text.isNotEmpty){
                                    setState(() {
                                      workerPassword.text = '${workerName.text.trim()}@${workerPhoneNumber.text.substring(0, 2).toString()}';
                                    });
                                  }
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter your name";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              AppConstant().getTextField(
                                'Email Id*',
                                workerEmailId,
                                isNumber: false,
                                onChanged: () {},
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter your email";
                                  } else if (!emailRegex.hasMatch(value)) {
                                    return "Enter a valid email";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              AppConstant().getTextField(
                                'Phone Number*',
                                workerPhoneNumber,
                                isNumber: true,
                                inputFormat: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                onChanged: () {
                                  setState(() {
                                    workerPassword.text = '${workerName.text.replaceAll(" ", "")}@${workerPhoneNumber.text.substring(0, 2).toString()}';
                                  });
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter your mobile number.";
                                  } else if (value.length < 10) {
                                    return "Enter a valid mobile number.";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              AppConstant().getTextField(
                                'Address',
                                workerAddress,
                                maxLine: 4,
                                isNumber: false,
                                onChanged: () {},
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              AppConstant().getTextField(
                                'Password',
                                workerPassword,
                                isNumber: false,
                                isEnable: false,
                                onChanged: () {},
                              ),
                              SizedBox(
                                height: height * 0.05,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (key.currentState!.validate()) {
                                    setState(() {});
                                    isLoading = true;
                                    db.addWorker(data: AddWorkerModel(
                                      name: workerName.text,
                                      mobileNumber: '+91${workerPhoneNumber.text}',
                                      email: workerEmailId.text,
                                      address: workerAddress.text,
                                      password: workerPassword.text,
                                      distributorEmail: auth.currentUser!.email!,
                                      lastUpdatedTime: DateTime.now(),
                                    )).then((value){
                                      AppConstant().showToast('Worker Added Successfully');
                                      workerName.clear();
                                      workerPhoneNumber.clear();
                                      workerEmailId.clear();
                                      workerAddress.clear();
                                      workerPassword.clear();
                                      setState(() {});
                                      isLoading = false;
                                    }).onError((error, stackTrace){
                                      AppConstant().showToast(error.toString().split(']')[1]);
                                      setState(() {});
                                      isLoading = false;
                                    });
                                  }
                                },
                                height: height * 0.06,
                                elevation: 3,
                                color: AppConstant.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: !isLoading ? Container(
                                  margin:
                                  EdgeInsets.symmetric(horizontal: width * 0.235),
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                        fontSize: width * 0.05,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ): Container(
                                    margin: EdgeInsets.symmetric(horizontal: width*0.250),
                                    child: CircularProgressIndicator(color: AppConstant.backgroundColor,)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  TextEditingController workerName = TextEditingController();
  TextEditingController workerEmailId = TextEditingController();
  TextEditingController workerPhoneNumber = TextEditingController();
  TextEditingController workerAddress = TextEditingController();
  TextEditingController workerPassword = TextEditingController();

// getTextFeild(
//   String lable,
//   var txtController, {
//   int maxLine: 1,
//       int minimum :1,
//   required VoidCallback onChanged,
//   final FormFieldValidator<String>? validator,
//   bool isenable: true,
//   bool isNumber: false,
//   var inputformat,
// }) {
//   List<TextInputFormatter> filter = [];
//   filter.addAll(inputformat ?? []);
//   if (isNumber)
//     filter.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9]')));
//   return Container(
//     margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
//     child: TextFormField(
//       controller: txtController,
//       inputFormatters: filter,
//       maxLines: maxLine,
//       minLines: minimum,
//       onChanged: (value) {
//         onChanged();
//       },
//       keyboardType: isNumber
//           ? TextInputType.numberWithOptions(signed: true, decimal: true)
//           : TextInputType.text,
//       decoration: InputDecoration(
//         filled: false,
//         fillColor: isenable ? Colors.grey[150] : Colors.grey[300],
//         enabled: isenable,
//         errorBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.red),
//           borderRadius: BorderRadius.all(Radius.circular(5)),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.red),
//           borderRadius: BorderRadius.all(Radius.circular(5)),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: AppConstant.primaryColor),
//           borderRadius: BorderRadius.all(Radius.circular(5)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: AppConstant.primaryColor),
//           borderRadius: BorderRadius.all(Radius.circular(5)),
//         ),
//         disabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: AppConstant.primaryColor),
//           borderRadius: BorderRadius.all(Radius.circular(5)),
//         ),
//         labelText: lable,
//         labelStyle: TextStyle(color: Colors.grey[600]),
//         contentPadding: EdgeInsets.fromLTRB(15, 3, 0, 0),
//         hintStyle: TextStyle(color: Colors.grey[600]),
//       ),
//       validator: validator,
//     ),
//   );
// }
}
