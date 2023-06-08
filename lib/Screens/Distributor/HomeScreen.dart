// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:textile_service/Screens/Distributor/Add%20Item/Database/add_item_database.dart';
import 'package:textile_service/Screens/Distributor/Add%20Worker/Database/add_worker_database.dart';
import 'package:textile_service/Screens/Distributor/AddWork/Database/add_work_database.dart';
import 'package:textile_service/Screens/Distributor/Login%20Screen/login_screen.dart';
import 'package:textile_service/Utils/pref_utils.dart';
import '../../Utils/ClipperPath.dart';
import '../../Utils/app_constant.dart';
import 'Add Item/AddItemScreen.dart';
import 'Add Worker/WorkersListScreen.dart';
import 'AddWork/Scanner Screen/Scanner_Screen.dart';
import 'DataModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();
   AddWorkerDatabase addWorkerDatabase = AddWorkerDatabase();
   AddItemDatabase addItemDatabase = AddItemDatabase();
   AddWorkDatabase addWorkDatabase = AddWorkDatabase();




   int totalWorker = 0;
   int totalItems = 0;
   int pendingWork = 0;
   int completedWork = 0;
  PrefUtils prefUtils = PrefUtils();

  Future<void> getWorkerCount()async{
    totalWorker = await addWorkerDatabase.getWorkerCount();
  }

  Future<void> getItemCount()async{
    totalItems = await addItemDatabase.getItemCount();
  }

  Future<void> getPendingWorkCount()async{
    pendingWork = await addWorkDatabase.getPendingWorkDCount();
  }

  Future<void> getCompletedWorkCount()async{
    completedWork = await addWorkDatabase.getCompletedWorkDCount();
  }




  List<DataModel> allData = [];

  Future<void> setData()async{
    allData = [
      DataModel('Total Worker', 'Assets/Images/user1.png', totalWorker,Colors.indigo),
      DataModel('Total Items', 'Assets/Images/totalitem1.png',totalItems,Colors.blueAccent),
      DataModel('Pending Work', 'Assets/Images/pending1.png',pendingWork,Colors.amber),
      DataModel('Completed Work', 'Assets/Images/complited1.png',completedWork,Colors.green),
    ];
  }

  String? name;


  @override
  void initState() {
    super.initState();
    getData().whenComplete((){
      getWorkerCount().whenComplete((){
         getItemCount().whenComplete((){
           getPendingWorkCount().whenComplete((){
               getCompletedWorkCount().whenComplete((){
                 setData().whenComplete((){
                   setState(() {});
                 });

               });
           });
         });
      });
    });
  }

  Future<void> getData()async{
    prefUtils.getName().toString();
    prefUtils.getPhoneNumber().toString();
    prefUtils.getEmail().toString();
    prefUtils.getWorkerID().toString();
  }

  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double statusBarHeight= MediaQuery.of(context).padding.top;

    var day =  DateFormat.d();
    var formatedDay = day.format(DateTime.now());

    var month =  DateFormat.MMMM();
    var formatedMonth = month.format(DateTime.now());

    var year  =  DateFormat.y();
    var formatedYear = year.format(DateTime.now());


    return  Scaffold(
      backgroundColor: const Color(0xFFe9f0fb),
      key: _scaffoldKey,
      drawer: Padding(
        padding: EdgeInsets.only(top: height*0.034, bottom: width*0.001),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
          child: Drawer(
            width:MediaQuery.of(context).size.width * 0.80,
            child:Stack(
              children: [
                Container(
                  height: height * 0.40,
                  width: width,
                  child: Stack(
                      children:[
                        Container(
                          height: height*0.50,
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
                          height: height*0.20,
                          margin: EdgeInsets.symmetric(horizontal:width*0.08),
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
                                        fontSize: width*0.05,
                                        color: AppConstant.backgroundColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      prefUtils.getPhoneNumber(),
                                      style: TextStyle(
                                        fontSize:  width*0.04,
                                        color: AppConstant.backgroundColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {

                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset('Assets/Images/ic_profile_placeholder.jpg',
                                    height:55,
                                    width:55,
                                  ),
                                ),)
                            ],
                          ),
                        ),
                      ]
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: EdgeInsets.fromLTRB(0, height*0.25, 0, 30),
                  child: ListView(
                    children: [
                      buildListMenuView(
                          'item_add.svg', "Add Item", () {
                        Navigator.of(context)
                            .push( MaterialPageRoute<String>(
                            builder: (context) => const AddItemScreen()));
                      }),
                      buildListMenuView(
                          'user-add.svg', "Workers List", () {
                        Navigator.of(context)
                            .push( MaterialPageRoute<String>(
                            builder: (context) => const WorkersListScreen()));
                      }),
                      buildListMenuView(
                          'logout.svg', "Log Out", () async{
                        await showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),),
                            builder: (context){
                          return logout();
                        }
                        );
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
                              padding: EdgeInsets.only(top: statusBarHeight * 1.5, left: width * 0.02),
                              margin: EdgeInsets.fromLTRB(0, 0, width*.03, height*.02),
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
                                      child: SvgPicture.asset('Assets/Images/menu.svg'),
                                    ),
                                  ),
                                  Bounce(
                                    duration: const Duration(milliseconds:90),
                                    onPressed: ()async{
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const ScannerScreen()));
                                    },
                                    child: Tooltip(
                                      message: 'Assign Work',
                                      child: Image.asset('Assets/Images/scanner.png',
                                        height: 35,
                                        width: 35,
                                        color:AppConstant.backgroundColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(width*.09,0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${formatedDay}th $formatedMonth $formatedYear',
                                    style: TextStyle(
                                        color:AppConstant.grey,
                                        fontSize:width*.04,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: height*0.001),
                                  Text(
                                    'Hello, ${prefUtils.getName()}',
                                    style: TextStyle(
                                        color: AppConstant.backgroundColor,
                                        fontSize: width*.08,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                )

            ),
            Container(
              height: height,
              width: width,
              padding: EdgeInsets.only(top: statusBarHeight*05),
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
    return ListView.builder(
        padding:EdgeInsets.only(left :width*.05, right:width*.05),
        shrinkWrap: true,
        itemCount: allData.length,
        itemBuilder: (context, index){
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
                    padding:EdgeInsets.only(top:height*0.01, bottom:height*0.00, left: width*0.04),
                    child:  Text(
                      allData[index].title,
                      style:  TextStyle(
                        fontSize: width*0.05,
                        color: AppConstant.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10, top: 05),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding:const EdgeInsets.only(left: 10, top: 05,right: 10,bottom: 05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(allData[index].image,
                                  height: height*.13,
                                  alignment: Alignment.topLeft,
                                ),
                                CircularPercentIndicator(
                                  radius: 40.0,
                                  lineWidth: 7.0,
                                  animation: true,
                                  animationDuration: 500,
                                  percent: allData[index].counts / 100,
                                  backgroundColor: Colors.grey.shade200,
                                  addAutomaticKeepAlive: true,
                                  center:Text("${allData[index].counts}"),
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




  buildListMenuView(String image, String desc, VoidCallback onclick, {bool ispause: true}) {
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
                      child: SvgPicture.asset('Assets/Images/$image',height:30,width: 30,color: AppConstant.colorDrawerIcon,),
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
          onPressed:()async{
            setState(() {
              prefUtils.clearPreferencesData();
            });
            Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>const LoginScreen()),(route) => false);
          },
          child: Container(
            height: screenHeight * 0.06,
            margin: EdgeInsets.fromLTRB(screenWidth * 0.03, 0,
                screenWidth * 0.03, screenHeight * 0.01),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppConstant.primaryColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                  ),
                ]
            ),
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
          onPressed:()async{
            Navigator.pop(context);
          },
          child: Container(
            height: screenHeight * 0.06,
            margin: EdgeInsets.fromLTRB(screenWidth * 0.03, 0,
                screenWidth * 0.03, screenHeight * 0.01),
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

  // _showDialog() async {
  //   final double height = MediaQuery.of(context).size.height;
  //   final double width = MediaQuery.of(context).size.width;
  //   await Future.delayed(const Duration(milliseconds: 1));
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           shape:  const RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all( Radius.circular(20.0))),
  //           contentPadding:  const EdgeInsets.only(top: 09),
  //           title: Column(
  //             children: [
  //               Text(
  //                 'Logout',
  //                 style: TextStyle(
  //                     fontSize: width*0.06,
  //                     color: AppConstant.primaryTextDarkColor,
  //                     fontWeight: FontWeight.w600),
  //               ),
  //               SizedBox(height: height*0.01),
  //               const Divider(
  //                 color: Colors.grey,
  //                 height: 4.0,
  //               ),
  //             ],
  //           ),
  //           content: Padding(
  //             padding: const EdgeInsets.only(left: 20.0, right: 10, top: 10.0, bottom: 20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children:[
  //                 Text(
  //                   'Are you sure you want to logout?',
  //                   style: TextStyle(
  //                     fontSize: width*0.06,
  //                     color: AppConstant.primaryTextDarkColor.withOpacity(.6),
  //                   ),
  //                 ),
  //                 SizedBox(height: height*0.03),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   crossAxisAlignment: CrossAxisAlignment.end,
  //                   children: [
  //                     MaterialButton(
  //                       onPressed: () {
  //                         setState(() {
  //                           prefUtils.clearPreferencesData();
  //                         });
  //                         Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>const LoginScreen()),(route) => false);
  //                       },
  //                       height: height * 0.05,
  //                       elevation: 3,
  //                       color: AppConstant.primaryColor,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       child: Container(
  //                         margin: EdgeInsets.symmetric(horizontal: width*0.02),
  //                         child: Text(
  //                           'Yes',
  //                           style: TextStyle(
  //                               fontSize: width*0.05,
  //                               color: Colors.white,
  //                               fontWeight: FontWeight.w500),
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(width:width*0.02),
  //                     MaterialButton(
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                       },
  //                       height: height * 0.05,
  //                       elevation: 3,
  //                       color: AppConstant.primaryColor,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       child: Container(
  //                         margin: EdgeInsets.symmetric(horizontal: width*0.02),
  //                         child: Text(
  //                           'No',
  //                           style: TextStyle(
  //                               fontSize: width*0.05,
  //                               color: Colors.white,
  //                               fontWeight: FontWeight.w500),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
}
