import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';

import '../../Utils/ClipperPath.dart';
import '../../Utils/app_constant.dart';


class AddWorkerScreen extends StatefulWidget {
  const AddWorkerScreen({Key? key}) : super(key: key);

  @override
  State<AddWorkerScreen> createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends State<AddWorkerScreen> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double statusBarHeight= MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: const Color(0xFFe9f0fb),
      resizeToAvoidBottomInset: false,
      body: Container(
        height: height,
        child: Stack(
          children: [
            Container(
              height: height*0.80,
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
              padding: EdgeInsets.only(top: height * 0.06),
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
                            Icons.chevron_left,
                            color: AppConstant.backgroundColor,
                            size: 35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(

              // padding: EdgeInsets.only(top: height * 0.05, left:width*0.05, right:width*0.05),
                margin: EdgeInsets.fromLTRB(width*0.40, height*0.12, width*0.05, height*0),
                child: SvgPicture.asset('Assets/Images/user-add.svg',height:height *0.10,color: AppConstant.backgroundColor,)),
            Container(
                height: height*0.68,
                width: width,
                padding: EdgeInsets.only(top: height * 0.04,left:width*0.05,right:width*0.05),
                margin: EdgeInsets.fromLTRB(width*0.05, height*0.25, width*0.05, height*0.09),
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
                  child: Column(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 275),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: 56.0,
                        child: FadeInAnimation(child: widget),
                      ),
                    children: [
                      getTextFeild(
                        'Name',
                        workerName,
                        isNumber: false,
                        inputformat: [FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z\s]')),],
                          onChanged: (){
                        }
                      ),
                      SizedBox(
                        height: height*0.03,
                      ),
                      getTextFeild(
                        'Email Id',
                        workerEmailId,
                        isNumber: false,
                          onChanged: (){
                          }
                      ),
                      SizedBox(
                        height: height*0.03,
                      ),
                      getTextFeild(
                        'Phone Number',
                        workerPhoneNumber,
                        isNumber: true,
                        inputformat:  <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                        ],
                          onChanged: (){
                         setState(() {
                           workerPassword.text = ' ${workerName.text}@${workerPhoneNumber.text.substring(0,2).toString()}';
                         });
                        }
                      ),
                      SizedBox(
                        height: height*0.03,
                      ),
                      getTextFeild(
                        'Address',
                        workerAddress,
                        maxLine: 3,
                        isNumber: false,
                          onChanged: (){
                          }
                      ),
                      SizedBox(
                        height: height*0.03,
                      ),
                      getTextFeild(
                        'Password',
                        workerPassword,
                        isNumber: false,
                        isenable: false,
                          onChanged: (){
                          }
                      ),
                      SizedBox(
                        height: height*0.05,
                      ),
                      MaterialButton(
                        onPressed: () {},
                        height: height * 0.06,
                        elevation: 3,
                        color: AppConstant.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: width*0.235),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                fontSize: width*0.05,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),)
          ],
        ),
      ),
    );
  }


  TextEditingController workerName= TextEditingController();
  TextEditingController workerEmailId= TextEditingController();
  TextEditingController workerPhoneNumber= TextEditingController();
  TextEditingController workerAddress= TextEditingController();
  TextEditingController workerPassword= TextEditingController();



  getTextFeild(String lable, var txtController,
      {int maxLine : 1,
        required VoidCallback onChanged,
        bool isenable: true,
        bool isNumber: false,
        var inputformat}) {
    List<TextInputFormatter> filter = [];
    filter.addAll(inputformat ?? []);
    if (isNumber)
      filter.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9]')));
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextField(
        controller: txtController,
        inputFormatters: filter,
        maxLines: maxLine,
        onChanged:(value){
          onChanged();
        },
        keyboardType: isNumber
            ? TextInputType.numberWithOptions(signed: true, decimal: true)
            : TextInputType.text,
        decoration: InputDecoration(
          filled: false,
          fillColor: isenable ? Colors.grey[150] : Colors.grey[300],
          // prefixIcon: preFixFile != null
          //     ? Container(
          //   padding: EdgeInsets.all(12.0),
          //   child: SvgPicture.asset(
          //     preFixFile,
          //     height: 15,
          //     color: Colors.black87,
          //   ),
          // )
          //     : null,
          enabled: isenable,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppConstant.primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppConstant.primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppConstant.primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          labelText: lable,
          labelStyle: TextStyle(color: Colors.grey[600]),
          contentPadding: EdgeInsets.fromLTRB(15, 3, 0, 0),
          hintStyle: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

}
