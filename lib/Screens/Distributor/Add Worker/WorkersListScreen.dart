
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:textile_service/Screens/Distributor/Add%20Worker/AddWorkerScreen.dart';
import 'package:textile_service/Utils/ClipperPath.dart';

import '../../../Utils/app_constant.dart';
import 'Database/add_worker_database.dart';
import 'Models/add_worker_model.dart';

class WorkersListScreen extends StatefulWidget {
  const WorkersListScreen({Key? key}) : super(key: key);

  @override
  State<WorkersListScreen> createState() => _WorkersListScreenState();
}

class _WorkersListScreenState extends State<WorkersListScreen> {
  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double statusBarHeight= MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFe9f0fb),
      body: Container(
        height: height,
        width: width,
        color: Colors.white,
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
            SingleChildScrollView(
                child: Container(
                  height: height,
                  width: width,
                  child: AnimationLimiter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 275),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 56.0,
                            child: FadeInAnimation(child: widget),
                          ),
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: statusBarHeight * 1.3, left: width * 0.02),
                              margin: EdgeInsets.fromLTRB(0, 0, width*.03, height*.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding:  EdgeInsets.only(left:width*0.01),
                                      child:  Icon(Icons.arrow_back_ios,color: AppConstant.backgroundColor,),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddWorkerScreen()));
                                    },
                                    child: Tooltip(
                                      message: 'Add Worker',
                                      child:  SvgPicture.asset('Assets/Images/user-add.svg',height:height *0.04,color: AppConstant.backgroundColor,),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // SfCircularChart(
                            //     tooltipBehavior: TooltipBehavior(enable: true),
                            //     legend: Legend(
                            //         isVisible: true,
                            //         overflowMode: LegendItemOverflowMode.none,
                            //         position: LegendPosition.right,
                            //        toggleSeriesVisibility: true,
                            //        isResponsive: true,
                            //     ),
                            //     series: <CircularSeries>[
                            //       // Renders doughnut chart
                            //       DoughnutSeries<DataModel, String>(
                            //           dataSource: allData,
                            //           pointColorMapper:(DataModel data, _) => data.color,
                            //           xValueMapper: (DataModel data, _) => data.title,
                            //           yValueMapper: (DataModel data, _) => data.counts,
                            //           dataLabelSettings:const DataLabelSettings(isVisible : true),
                            //           enableTooltip: true,
                            //           //legendIconType: LegendIconType.seriesType,
                            //       )
                            //     ]
                            // )
                          ],
                        ),
                      )
                  ),
                )

            ),
            Container(
              height: height,
              width: width,
              padding: EdgeInsets.only(top: statusBarHeight*03),
              child: _buildListView(),
            )
          ],
        ),
      ),
    );
  }


  _buildListView() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
        stream: AddWorkerDatabase().listenWorker(),
        builder: (context, snapshot){
          if (snapshot.data == null){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else if(snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No any Workers/Please add worker first',
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
                      verticalOffset: 56.0,
                      child: FadeInAnimation(
                        child: InkWell(
                          onTap: null,
                          child: Container(
                            margin:  EdgeInsets.fromLTRB(width*0.03, height*0.00, width*0.03, height*0.02),
                            padding:  EdgeInsets.fromLTRB(width*0.03, 0, width*0.03, 0),
                            decoration:  BoxDecoration(
                                color: AppConstant.backgroundColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 0.1,
                                    blurRadius: 5.0,
                                  ),
                                ],
                                // gradient:  LinearGradient(
                                //     stops:const [0.02, 0.02],
                                //     colors:[AppConstant.primaryColor, AppConstant.backgroundColor]),
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
                                          snapshot.data!.docs[index]['name'],
                                          style:  TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: width*0.05),
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                snapshot.data!.docs[index]['mobileNumber'],
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
                                GestureDetector(
                                  onTap: (){
                                    _update(address:snapshot.data!.docs[index]['address'], email:snapshot.data!.docs[index]['email'] ,id:snapshot.data!.docs[index].id ,name:snapshot.data!.docs[index]['name'],password: snapshot.data!.docs[index]['password'],phoneNumber:snapshot.data!.docs[index]['mobileNumber']);
                                  },
                                  child: Container(
                                    height: height*0.05,
                                    width: width*0.09,
                                    margin:  EdgeInsets.fromLTRB(width*0.01,   height*0.01, width*0.02, height*0.002),
                                    child: Image.asset(
                                      'Assets/Images/pen.png',
                                    ),
                                  ),
                                ),
                                // IconButton(
                                //   onPressed: (){},
                                //   icon: Icon(Icons.edit_outlined, color: AppConstant.primaryTextDarkColor),
                                // ),
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

  TextEditingController workerName = TextEditingController();
  TextEditingController workerEmailId = TextEditingController();
  TextEditingController workerPhoneNumber = TextEditingController();
  TextEditingController workerAddress = TextEditingController();
  TextEditingController workerPassword = TextEditingController();
  RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  FirebaseAuth auth = FirebaseAuth.instance;
  AddWorkerDatabase db = AddWorkerDatabase();
  bool isLoading = false;

  Future<void> _update(
      {String? id,
        String? name,
        String? email,
        String? phoneNumber,
        String? address,
        String? password}) async {

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    workerName.text = name.toString();
    workerEmailId.text = email.toString();
    workerPhoneNumber.text = phoneNumber.toString();
    workerAddress.text = address.toString();
    workerPassword.text = password.toString();

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext  context,StateSetter setState ){
                return Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Worker Details',
                            style: TextStyle(
                                color: AppConstant.primaryColor,
                                fontSize: width*.06,
                                fontWeight: FontWeight.w600),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    AlertDialog(
                                      title: Text("Delete Worker",
                                        style:  TextStyle(
                                          fontSize: width*0.06,
                                          color: Colors.red,
                                        ),
                                      ),
                                      content:  Text("Are you sure you want to delete this Worker",
                                        style:  TextStyle(
                                          color: Colors.black,
                                          fontSize: width*0.04,
                                        ),
                                      ),
                                      actions: [
                                        // ignore: deprecated_member_use
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            MaterialButton(
                                              onPressed: () async{
                                                Navigator.of(context).pop();
                                              },
                                              height: height * 0.05,
                                              elevation: 3,
                                              color: AppConstant.colorDrawerIcon,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child:  Container(
                                                margin:EdgeInsets.symmetric(horizontal: width * 0.010),
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      fontSize: width * 0.05,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * 0.03,
                                            ),
                                            MaterialButton(
                                              onPressed: () async{
                                                Navigator.of(context);
                                                await FirebaseFirestore.instance.collection('Workers').doc(id).delete().then((value) {
                                                  Navigator.of(context).pop();
                                                  AppConstant().showToast('Worker Deleted Successfully');
                                                });
                                              },
                                              height: height * 0.05,
                                              elevation: 3,
                                              color: Colors.redAccent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child:  Container(
                                                margin:EdgeInsets.symmetric(horizontal: width * 0.010),
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      fontSize: width * 0.05,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                              );
                            },
                            child: Container(
                              height: height*0.05,
                              width: width*0.08,
                              margin:  EdgeInsets.fromLTRB(width*0.01,   height*0.01, width*0.02, height*0.002),
                              child: Image.asset(
                                'Assets/Images/delete.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      AppConstant().getTextField(
                        'Name*',
                        workerName,
                        isNumber: false,
                        inputFormat: [
                          FilteringTextInputFormatter.deny(
                              RegExp(r'[^a-zA-Z\s]')),
                        ],
                        onChanged: () {
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
                        isEnable: false,
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });
                              db.updateWorker(data:AddWorkerModel(
                                name: workerName.text,
                                mobileNumber: workerPhoneNumber.text,
                                email: workerEmailId.text,
                                address: workerAddress.text,
                                password: workerPassword.text,
                                distributorEmail: auth.currentUser!.email!,
                                docID: id,
                                lastUpdatedTime: DateTime.now(),
                              )).then((value){
                                AppConstant().showToast('Worker Updated Successfully');
                                setState(() {
                                  isLoading = false;
                                });
                              }).onError((error, stackTrace){
                                AppConstant().showToast('${error.toString().split(']')[1]}');
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            },
                            height: height * 0.06,
                            elevation: 3,
                            color: AppConstant.successColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: !isLoading ? Container(
                              margin:EdgeInsets.symmetric(horizontal: width * 0.090),
                              child: Text(
                                'Update',
                                style: TextStyle(
                                    fontSize: width * 0.05,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ): Container(
                                margin: EdgeInsets.symmetric(horizontal: width*0.122),
                                child: CircularProgressIndicator(color: AppConstant.backgroundColor,)),
                          ),
                          SizedBox(
                            width: width * 0.03,
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            height: height * 0.06,
                            elevation: 3,
                            color: AppConstant.colorDrawerIcon,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:  Container(
                              margin:EdgeInsets.symmetric(horizontal: width * 0.090),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    fontSize: width * 0.05,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
        });
  }

// _buildListView() {
//   final double height = MediaQuery.of(context).size.height;
//   final double width = MediaQuery.of(context).size.width;
//   return ListView.builder(
//       padding:EdgeInsets.only(left :width*.05, right:width*.05),
//       shrinkWrap: true,
//       itemCount: 10,
//       itemBuilder: (context, index){
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.grey.shade200,
//               borderRadius: BorderRadius.circular(10.0),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.grey,
//                   spreadRadius: 0.1,
//                   blurRadius: 5.0,
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding:EdgeInsets.only(top:height*0.01, bottom:height*0.00, left: width*0.04),
//                   child:  Text(
//                     'WorkerName',
//                     style:  TextStyle(
//                       fontSize: width*0.05,
//                       color: AppConstant.primaryColor,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     textAlign: TextAlign.start,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10, top: 05),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       });
// }

}
