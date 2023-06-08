// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:textile_service/Utils/app_constant.dart';
import '../../../Utils/ClipperPath.dart';
import '../../../Utils/pref_utils.dart';
import '../../Distributor/AddWork/Database/add_work_database.dart';
import '../../Distributor/DataModel.dart';
import '../Login Screen/worker_login_screen.dart';
import 'QrDailog.dart';


class WorkerHomeScreen extends StatefulWidget {
  String? workerName;
  WorkerHomeScreen({Key? key, this.workerName}) : super(key: key);

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AddWorkDatabase addWorkDatabase = AddWorkDatabase();
  int pendingWork = 0;
  int completedWork = 0;

  Future<void> getPendingWorkCount()async{
    pendingWork = await addWorkDatabase.getPendingWorkCount(prefUtils.getWorkerID());
  }

  Future<void> getCompletedWorkCount()async{
    completedWork = await addWorkDatabase.getCompletedWorkCount(prefUtils.getWorkerID());
  }

  List<DataModel> allData = [];

  Future<void> setData()async{
    allData = [
      DataModel('Pending Work', 'Assets/Images/pending1.png',pendingWork,Colors.amber),
      DataModel('Completed Work', 'Assets/Images/complited1.png',completedWork,Colors.green),
    ];
  }

  String? name;
  PrefUtils prefUtils = PrefUtils();

  @override
  void initState() {
    super.initState();
    getData().whenComplete(() {
      getPendingWorkCount().whenComplete((){
         getCompletedWorkCount().whenComplete((){
           setData().whenComplete((){
             setState(() {});
           });
         });
      });
    });
  }

  Future<void> getData() async {
    prefUtils.getName();
    prefUtils.getPhoneNumber();
    prefUtils.getWorkerID();
    prefUtils.getEmail();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    var day = DateFormat.d();
    var formatedDay = day.format(DateTime.now());

    var month = DateFormat.MMMM();
    var formatedMonth = month.format(DateTime.now());

    var year = DateFormat.y();
    var formatedYear = year.format(DateTime.now());

    return Scaffold(
      backgroundColor: AppConstant.backgroundColor,
      key: _scaffoldKey,
      drawer: Padding(
        padding: EdgeInsets.only(top: height * 0.034, bottom: width * 0.001),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
          child: Drawer(
            width: MediaQuery.of(context).size.width * 0.80,
            child: Stack(
              children: [
                Container(
                  height: height * 0.40,
                  width: width,
                  child: Stack(children: [
                    Container(
                      height: height * 0.50,
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
                      padding: EdgeInsets.only(top: statusBarHeight),
                      height: height * 0.20,
                      margin: EdgeInsets.symmetric(horizontal: width * 0.08),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  prefUtils.getName(),
                                  style: TextStyle(
                                    fontSize: width * 0.05,
                                    color: AppConstant.backgroundColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  prefUtils.getPhoneNumber(),
                                  style: TextStyle(
                                    fontSize: width * 0.04,
                                    color: AppConstant.backgroundColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                // Text(
                                //   prefUtils.getEmail(),
                                //   style: TextStyle(
                                //     fontSize:  width*0.04,
                                //     color: AppConstant.backgroundColor,
                                //     fontWeight: FontWeight.w600,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                'Assets/Images/ic_profile_placeholder.jpg',
                                height: 55,
                                width: 55,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: EdgeInsets.fromLTRB(0, height * 0.25, 0, 30),
                  child: ListView(
                    children: [
                      buildListMenuView('logout.svg', "Log Out", () async {
                        await showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            builder: (context) {
                              return logout();
                            });
                        // _showDialog();
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        color: Colors.white,
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
            SingleChildScrollView(
              child: SizedBox(
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
                          padding: EdgeInsets.only(
                              top: statusBarHeight * 1.5, left: width * 0.02),
                          margin: EdgeInsets.fromLTRB(
                              0, 0, width * .03, height * .02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _scaffoldKey.currentState!.openDrawer();
                                },
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  padding: const EdgeInsets.all(7),
                                  child: SvgPicture.asset(
                                      'Assets/Images/menu.svg'),
                                ),
                              ),
                              Bounce(
                                duration: const Duration(milliseconds: 90),
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        QRDialog(id: prefUtils.getWorkerID()),
                                  );
                                },
                                child: ClipRRect(
                                  child: Image.asset(
                                    'Assets/Images/qr-code.png',
                                    color: AppConstant.backgroundColor,
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(width * .09, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${formatedDay}th $formatedMonth $formatedYear',
                                style: TextStyle(
                                    color: AppConstant.grey,
                                    fontSize: width * .04,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: height * 0.001),
                              Text(
                                'Hello, ${prefUtils.getName()}',
                                style: TextStyle(
                                    color: AppConstant.backgroundColor,
                                    fontSize: width * .08,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: height,
              width: width,
              padding: EdgeInsets.only(top: statusBarHeight * 06),
              child: _buildListView(),
            ),
            Container(
                height: height,
                width: width,
                padding: EdgeInsets.only(top: statusBarHeight * 17),
                child:  _buildWorkerListView(),),
          ],
        ),
      ),
    );
  }

  _buildListView() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return ListView.builder(
        padding: EdgeInsets.only(left: width * .05, right: width * .05),
        shrinkWrap: true,
        itemCount: allData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 0.1,
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: height * 0.003, left: width * 0.04),
                    child: Text(
                      allData[index].title,
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: AppConstant.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 05, right: 05, left: 05, top: 03),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 05, right: 05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  allData[index].image,
                                  height: height * .12,
                                  alignment: Alignment.topLeft,
                                ),
                                CircularPercentIndicator(
                                  radius: 35.0,
                                  lineWidth: 7.0,
                                  animation: true,
                                  animationDuration: 500,
                                  percent: allData[index].counts / 100,
                                  backgroundColor: Colors.grey.shade200,
                                  addAutomaticKeepAlive: true,
                                  center:
                                      Text("${allData[index].counts}"),
                                  progressColor: allData[index].color,
                                ),
                              ],
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
        });
  }

  buildListMenuView(String image, String desc, VoidCallback onclick,
      {bool ispause: true}) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
            onclick();
          },
          child: Container(
            height: 50,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 16),
                  child: SvgPicture.asset(
                    'Assets/Images/$image',
                    height: 30,
                    width: 30,
                    color: AppConstant.colorDrawerIcon,
                  ),
                ),
                Expanded(
                  child: Text(
                    desc,
                    style: TextStyle(
                        fontSize: 14,
                        color: AppConstant.colorDrawerIcon,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 6),
                  child: Icon(
                    Icons.chevron_right,
                    color: AppConstant.colorDrawerIcon,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          height: 1,
        ),
      ],
    ));
  }

  Widget logout() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: screenHeight * 0.03),
        Text(
          'LogOut',
          style: TextStyle(
              fontSize: screenWidth * .06,
              color: Colors.red,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(height: screenHeight * 0.04),
        Text(
          'Are you sure you want to log out? ',
          style: TextStyle(
              fontSize: screenWidth * .05,
              color: Colors.black,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(height: screenHeight * 0.03),
        Bounce(
          duration: const Duration(milliseconds: 110),
          onPressed: () async {
            setState(() {
              prefUtils.clearPreferencesData();
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const WorkerLoginScreen()),
                (route) => false);
          },
          child: Container(
            height: screenHeight * 0.06,
            margin: EdgeInsets.fromLTRB(
                screenWidth * 0.03, 0, screenWidth * 0.03, screenHeight * 0.01),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppConstant.primaryColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                  ),
                ]),
            alignment: Alignment.center,
            // margin: EdgeInsets.symmetric(horizontal: 30.w),
            child: Text(
              'Logout',
              style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Bounce(
          duration: const Duration(milliseconds: 110),
          onPressed: () async {
            Navigator.pop(context);
          },
          child: Container(
            height: screenHeight * 0.06,
            margin: EdgeInsets.fromLTRB(
                screenWidth * 0.03, 0, screenWidth * 0.03, screenHeight * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey.withOpacity(0.5),
            ),
            alignment: Alignment.center,
            // margin: EdgeInsets.symmetric(horizontal: 30.w),
            child: Text(
              'Cancel',
              style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  color: AppConstant.primaryColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }



  _buildWorkerListView() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
        stream: AddWorkDatabase().listenWork(prefUtils.getWorkerID()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.length == 0) {
            return const Center(
              child: Text(

                'No any Workers/Please add worker first',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
            );
          } else {
            return AnimationLimiter(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.02),
                    child: Container(
                      width: width * 0.87,
                      decoration: BoxDecoration(
                        color: AppConstant.primaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0.1,
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Work List',
                              style: TextStyle(
                                  fontSize: width * 0.05,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(07),
                            child: Tooltip(
                              message: 'Download Excel',
                              child: Bounce(
                                duration: const Duration(milliseconds: 110),
                                onPressed: () async {
                                  Directory? directory;
                                  try{
                                    if (await _requestPermission(Permission.storage)) {
                                      directory = Directory('/storage/emulated/0/Download');
                                    }else {
                                      return;
                                    }
                                    if (!await directory.exists()) {
                                      await directory.create(recursive: true);
                                    }
                                    if (await directory.exists()) {
                                      final excel = Excel.createExcel();
                                      final sheet = excel[excel.getDefaultSheet()!];

                                      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0,rowIndex: 0)).value= 'ItemName';
                                      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1,rowIndex: 0)).value='ItemQuantity';
                                      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2,rowIndex: 0)).value='TotalPrice';
                                      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3,rowIndex: 0)).value= 'Status';

                                      for(int row = 1; row <= snapshot.data!.docs.length; row++) {

                                        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0,rowIndex: row)).value=snapshot.data!.docs[row-1]['item'].toString();
                                        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1,rowIndex: row)).value=snapshot.data!.docs[row-1]['quantity'].toString();
                                        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2,rowIndex: row)).value=snapshot.data!.docs[row-1]['totalPrice'].toString();
                                        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3,rowIndex: row)).value=snapshot.data!.docs[row-1]['status'].toString();
                                      }

                                      File file = File('${directory.path}/${prefUtils.getName()}.xlsx');
                                      List<int>? fileBytes = excel.save();
                                      if(fileBytes != null){
                                        File(file.path)..createSync(recursive: true)..writeAsBytesSync(fileBytes);
                                        AppConstant().showToast("Excel downloaded successfully");
                                        OpenFile.open(file.path);
                                      }
                                    }
                                  }catch(e){
                                    print(e);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppConstant.backgroundColor,
                                    borderRadius: BorderRadius.circular(05),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 3,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(05),
                                    child: Image.asset(
                                      'Assets/Images/download.png',
                                      color: AppConstant.primaryColor,
                                      height: height*0.04,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      padding: EdgeInsets.only(left: width * .05, right: width * .05),
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 575),
                          child: SlideAnimation(
                            verticalOffset: 56.0,
                            child: FadeInAnimation(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(width * 0.03,
                                    height * 0.00, width * 0.03, height * 0.02),
                                padding: EdgeInsets.fromLTRB(
                                    width * 0.03, 0, width * 0.03, 0),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 0.1,
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                    // gradient:  LinearGradient(
                                    //     stops:const [0.02, 0.02],
                                    //     colors:[AppConstant.primaryColor, AppConstant.backgroundColor]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0))),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: height * 0.06,
                                      width: width * 0.02,
                                      margin: EdgeInsets.fromLTRB(width * 0.01,
                                          height * 0.02, width * 0.02, height * 0.01),
                                      decoration: BoxDecoration(
                                          color: snapshot.data!.docs[index]
                                                      ['status'] ==
                                                  'Pending'
                                              ? AppConstant.pendingColor
                                              : AppConstant.successColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(6.0))),
                                    ),
                                    Flexible(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(
                                            0, height * 0.025, 0, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'ItemName : ${snapshot.data!.docs[index]['item']}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: width * 0.05),
                                            ),
                                            const SizedBox(height: 3),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'TotalPrice : ${snapshot.data!.docs[index]['totalPrice']}',
                                                    style: TextStyle(
                                                        fontSize: width * 0.035),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: height * 0.10,
                                      width: width * 0.16,
                                      margin:
                                          EdgeInsets.fromLTRB(0, 0, width * 0.02, 0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        //borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              '${snapshot.data!.docs[index]['itemImage']}'),
                                          fit: BoxFit.cover,
                                        ),
                                        // border:Border.all(
                                        //     color: AppConstant.primaryColor,
                                        //     width: 1),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 3,
                                            spreadRadius: 0.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }


  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

}
