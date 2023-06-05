import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textile_service/Screens/Distributor/Add%20Item/Models/add_item_model.dart';
import 'package:textile_service/Service/storage.dart';

import '../../../Utils/ClipperPath.dart';
import '../../../Utils/app_constant.dart';
import 'Database/add_item_database.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {


  final key = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  AddItemDatabase db = AddItemDatabase();
  bool isLoading = false;
  // PlatformFile? imageFile;

  File? file;
  XFile? imageFile;
  Uint8List? imageBytes;

  Storage storage =  Storage();

  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;




    Future<void> getImage()async{
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
       if(image != null){
         imageBytes = await image.readAsBytes();
         setState(() {
           file = File(image.path);
           imageFile = image;
         });
       }
    }

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
              margin: EdgeInsets.fromLTRB(width*0.05, height*0.17, width*0.05, height*0),
              child: Row(
                children: [
                  SvgPicture.asset('Assets/Images/item_add.svg',height:height *0.05,color: AppConstant.backgroundColor,),
                  Text('Add Item',
                    style: TextStyle(
                        color: AppConstant.backgroundColor,
                        fontSize: width*.06,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
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
                  child: Form(
                    key: key,
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Item name";
                            } else {
                              return null;
                            }
                          },
                        ),
                         SizedBox(
                          height: height*0.03,
                        ),
                        getTextFeild(
                          'Item price',
                          itemPrice,
                          isNumber: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Item Price";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: height*0.03,
                        ),
                        DottedBorder(
                          borderType: BorderType.RRect,
                          color: AppConstant.primaryColor,
                          radius: const Radius.circular(12),
                        strokeWidth: 0.8,
                        dashPattern: [3],
                        strokeCap: StrokeCap.butt,
                        child: GestureDetector(
                          onTap: (){
                            getImage();
                          },
                          child:imageFile == null ?
                          SizedBox(
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
              )
                              :SizedBox(
                            height: height * 0.16,
                            width: width*0.80,
                            child: Image.file(file!),
                          ),
                        ),
                      ),
                        SizedBox(
                          height: height*0.05,
                        ),
                        MaterialButton(
                          onPressed: ()async {
                         if (key.currentState!.validate())  {
                           setState(() {});
                           isLoading = true;
                           if(imageFile == null){
                             AppConstant().showToast("Select item image.");
                             setState(() {});
                             isLoading = false;
                           }else{
                             db.addItem(data: AddItemModel(
                               itemName: itemName.text,
                               itemPrice: num.parse(itemPrice.text),
                               itemImage: (await storage.uploadFile(
                                   imageFile!,
                                   'Items/',
                                   '${itemName.text}_item',
                                    imageBytes!,
                               ))!,
                               distributorEmail: auth.currentUser!.email!,
                               lastUpdatedTime: DateTime.now(),
                             )).then((value){
                               itemName.text = "";
                               itemPrice.text = "";
                               imageFile = null;
                               AppConstant().showToast('Item Added Successfully');
                               setState(() {});
                               isLoading = false;
                             }).onError((error, stackTrace){
                               AppConstant().showToast(error.toString().split(']')[1]);
                               setState(() {});
                               isLoading = false;
                             });
                           }

                         }
                          },
                          height: height * 0.06,
                          elevation: 3,
                          color: AppConstant.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),),
                          child: !isLoading ? Container(
                            margin: EdgeInsets.symmetric(horizontal: width*0.235),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: width*0.05,
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
        final FormFieldValidator<String>? validator,
        var inputformat}) {
    List<TextInputFormatter> filter = [];
    filter.addAll(inputformat ?? []);
    if (isNumber)
      filter.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9]')));
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextFormField(
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
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
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
        validator: validator,
      ),
    );
  }
}
