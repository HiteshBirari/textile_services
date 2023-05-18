


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:textile_service/Screens/Distributor/AddWork/Models/add_work_model.dart';

import '../../../Utils/ClipperPath.dart';
import '../../../Utils/app_constant.dart';
import '../Add Item/Database/add_item_database.dart';
import '../HomeScreen.dart';
import 'Database/add_work_database.dart';

class AddWorkScreen extends StatefulWidget {
  String workerID;
  AddWorkScreen({Key? key,required this.workerID}) : super(key: key);

  @override
  State<AddWorkScreen> createState() => _AddWorkScreenState();
}

class _AddWorkScreenState extends State<AddWorkScreen> {

  final key = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  AddWorkDatabase db = AddWorkDatabase();
  bool isLoading = false;
  String email = "";

  TextEditingController itemQuantity= TextEditingController();
  TextEditingController totalPrice= TextEditingController();

  @override
  void initState() {
    setState(() {
       email = auth.currentUser!.email!;
    });
    super.initState();
  }

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
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>const HomeScreen()));
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
                  Text('Add Work',
                    style: TextStyle(
                        color: AppConstant.backgroundColor,
                        fontSize: width*.06,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Container(
              height: height*0.50,
              width: width,
              padding: EdgeInsets.only(top: height * 0.07, left:width*0.05, right:width*0.05),
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
                               GestureDetector(
                                 onTap: (){
                                   selectItemSheet();
                                 },
                                 child: InputDecorator(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(15, 3, 0, 0),
                                    filled: false,
                                    fillColor: const Color(0x1d35312b),
                                    hintText: 'Select Item',
                                    labelText: 'Select Item',
                                    enabledBorder:OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppConstant.primaryColor),
                                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                                    ),
                                  ),
                                   child:Text('Select Item') ,
                              ),
                               ),
                              SizedBox(
                                height: height*0.03,
                              ),
                             AppConstant().getTextField(
                                'Item Quantity',
                               itemQuantity,
                                isNumber: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter Item Price";
                                  } else {
                                    return null;
                                  }
                                },
                               onChanged: () { },
                              ),
                              SizedBox(
                                height: height*0.03,
                              ),
                              AppConstant().getTextField(
                                'Total Price',
                                totalPrice,
                                isNumber: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter Item Price";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: () { },
                              ),
                              SizedBox(
                                height: height*0.08,
                              ),
                              MaterialButton(
                                onPressed: ()async {
                                  if (key.currentState!.validate())  {
                                    setState(() {});
                                    isLoading = true;
                                    db.addWork(data: AddWorkModel(
                                      item: '',
                                      quantity: itemQuantity.text,
                                      totalPrice: totalPrice.text,
                                      workerId: widget.workerID,
                                      lastUpdatedTime: DateTime.now(),
                                    )).then((value){
                                      AppConstant().showToast('Work Assign Successfully');
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
                      ],
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Future<void> selectItemSheet()async{
    Size size = MediaQuery.of(context).size;
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),),
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext  context, StateSetter setState ){
                return Container(
                  height: size.height * 0.5,
                  width: size.width,
                  padding: EdgeInsets.only(
                      top: size.height * 0.02,
                      left: size.width * 0.02,
                      right: size.width * 0.02,
                      bottom: size.height * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstant.backgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildListView(),
                    ],
                  ),
                );
              });
        });
  }

  _buildListView() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
     final FirebaseAuth auth = FirebaseAuth.instance;
    return StreamBuilder<QuerySnapshot>(
        stream: AddItemDatabase().listenItem(email),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: Text('Loading......',
                style:  TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
            );
          } else if(snapshot.data!.docs.length == 0 || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No any Items/Please add item first',
                style:  TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
            );
          }else{
            return AnimationLimiter(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                padding:EdgeInsets.only(left :width*.05, right:width*.05),
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds:575),
                    child: SlideAnimation(
                      verticalOffset: 34.0,
                      child: FadeInAnimation(
                        child: InkWell(
                          onTap: (){},
                          child: Container(
                            decoration:  BoxDecoration(
                                color: AppConstant.backgroundColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 0.1,
                                    blurRadius: 5.0,
                                  ),
                                ],
                                borderRadius: const BorderRadius.all( Radius.circular(6.0))),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: height*0.06,
                                  width: width*0.02,
                                  margin:  EdgeInsets.fromLTRB(width*0.01, height*0.01, width*0.02, height*0.002),
                                  decoration:  BoxDecoration(
                                      color:AppConstant.primaryColor,
                                      borderRadius: const BorderRadius.all( Radius.circular(6.0))),
                                ),
                                Flexible(
                                  child: Container(
                                    margin:  const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data!.docs[index]['itemName'],
                                          style:  TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: width*0.05),
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "${snapshot.data!.docs[index]['itemPrice']}",
                                                style: TextStyle(
                                                    fontSize: width*0.035),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        });
  }
}
