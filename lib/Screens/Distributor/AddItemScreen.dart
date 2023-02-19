
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../Utils/ClipperPath.dart';
import '../../Utils/app_constant.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
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
                child: SvgPicture.asset('Assets/Images/item_add.svg',height:height *0.10,color: AppConstant.backgroundColor,)),
            Container(
                height: height*0.56,
                width: width,
                padding: EdgeInsets.only(top: height * 0.05, left:width*0.05, right:width*0.05),
                margin: EdgeInsets.fromLTRB(width*0.05, height*0.25, width*0.05, height*0.10),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
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
                        'Item name',
                        itemName,
                        isNumber: false,
                        inputformat: [FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z\s]')),],
                      ),
                       SizedBox(
                        height: height*0.03,
                      ),
                      getTextFeild(
                        'Item price',
                        itemPrice,
                        isNumber: true,
                      ),
                      SizedBox(
                        height: height*0.03,
                      ),
                      DottedBorder(
                        borderType: BorderType.RRect,
                        color: AppConstant.primaryColor,
                        radius: Radius.circular(12),
                      strokeWidth: 0.8,
                      dashPattern: [3],
                      strokeCap: StrokeCap.butt,
                      child: GestureDetector(
                        onTap: ()async{
                          final itemImage1 = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality:25);
                          if(itemImage1 == null) return;
                          final finalItemImage = File(itemImage1.path.toString());
                          setState(() {
                            itemImage = finalItemImage;
                          });
                        },
                        child:itemImage == null ?
                        Container(
                         height: height * 0.16,
                        width: width*0.80,
                     child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('Assets/Images/Download.svg',color: const Color(0xff673AB7)),
                          SizedBox(height: height * 0.02, ) ,
                          Text('Upload item Image',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: width*0.04,
                            ),
                          ),
                        ],
                  ),
              ):Container(
                          height: height * 0.16,
                          width: width*0.80,
                          decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(itemImage!),
                            ),
                          ),
                        ),
                      ),
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

  TextEditingController itemName= TextEditingController();
  TextEditingController itemPrice= TextEditingController();

  getTextFeild(String lable, var txtController,
      {bool isenable: true,
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

  File? itemImage;

}
