import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../Utils/ClipperPath.dart';
import '../../Utils/app_constant.dart';
import 'AddItemScreen.dart';
import 'Add Worker/AddWorkerScreen.dart';
import 'DataModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();

  List<DataModel> allData = [
    DataModel('Total Worker','Assets/Images/user1.png',100,Colors.indigo),
    DataModel('Total Items','Assets/Images/totalitem1.png',150,Colors.blueAccent),
    DataModel('Pending Work','Assets/Images/pending1.png',95,Colors.amber),
    DataModel('Completed Work','Assets/Images/complited1.png',55,Colors.green),
  ];

  // List title =  ['Total Worker','Total Items','Pending Work','Completed Work'];
  // List images = ['assets/user1.png','assets/totalitem1.png','assets/pending1.png','assets/complited1.png'];
  // List counts = ['100','150','95','5'];


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
                        height: height * 0.25,
                        margin: EdgeInsets.symmetric(horizontal: width*0.05),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset('Assets/Images/ic_profile_placeholder.jpg',
                                height:55,
                                width:55,
                              ),
                            ),
                            SizedBox(height: height*0.02),
                            Expanded(
                              child: Text(
                               '${FirebaseAuth.instance.currentUser!.email}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppConstant.backgroundColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
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
                          'user-add.svg', "Add Worker", () {
                        Navigator.of(context)
                            .push( MaterialPageRoute<String>(
                            builder: (context) => const AddWorkerScreen()));
                      }),
                      buildListMenuView(
                          'logout.svg', "Log Out", () {
                        Navigator.of(context)
                            .push( MaterialPageRoute<String>(
                            builder: (context) => const AddWorkerScreen()));
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
                           padding: EdgeInsets.only(top: statusBarHeight * 1.5),
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
                               ClipRRect(
                                 borderRadius: BorderRadius.circular(50),
                                 child: Image.asset('Assets/Images/ic_profile_placeholder.jpg',
                                   height: 35,
                                   width: 35,
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
                                 'Hello, ${FirebaseAuth.instance.currentUser!.email}',
                                 style: TextStyle(
                                     color: AppConstant.backgroundColor,
                                     fontSize: width*.09,
                                     fontWeight: FontWeight.w600),
                               ),
                             ],
                           ),
                         ),
                         SizedBox(height: height*0.04),
                         SizedBox(
                           height: height*0.28,
                           child: Container(
                             //margin: EdgeInsets.fromLTRB(20, 02, 20, ),
                             child: _buildListView(),
                           ),
                         ),
                         SfCircularChart(
                             tooltipBehavior: TooltipBehavior(enable: true),
                             legend: Legend(
                                 isVisible: true,
                                 overflowMode: LegendItemOverflowMode.none,
                                 position: LegendPosition.right,
                                toggleSeriesVisibility: true,
                                isResponsive: true,
                             ),
                             series: <CircularSeries>[
                               // Renders doughnut chart
                               DoughnutSeries<DataModel, String>(
                                   dataSource: allData,
                                   pointColorMapper:(DataModel data, _) => data.color,
                                   xValueMapper: (DataModel data, _) => data.title,
                                   yValueMapper: (DataModel data, _) => data.counts,
                                   dataLabelSettings:const DataLabelSettings(isVisible : true),
                                   enableTooltip: true,
                                   //legendIconType: LegendIconType.seriesType,
                               )
                             ]
                         )

                       ],
                     ),
                   )),)
             ),
           ],
         ),
       ),
    );
  }

  _buildListView() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding:EdgeInsets.only(left :width*.05, right:width*.05),
        shrinkWrap: true,
        itemCount: allData.length,
        itemBuilder: (context, index){
          return Container(
            margin: EdgeInsets.fromLTRB(width*.02,0,width*.02,height*0.02),
            height: height*.22,
            width: width*.41,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppConstant.primaryColor,
                  blurRadius:5,
                  spreadRadius:.4,
                ),
              ],
              color: AppConstant.backgroundColor,
            ),
            child: Column(
              children: [
                SizedBox(height: height*0.03),
                Text(
                  allData[index].title,
                  style: TextStyle(
                      color: AppConstant.primaryColor,
                      fontSize: width*.05,
                      fontWeight: FontWeight.w600),
                ),
                Image.asset(allData[index].image,
                  height: height*.12,
                  alignment: Alignment.topLeft,
                ),
                Text(
                  allData[index].counts.toString(),
                  style: TextStyle(
                      color: AppConstant.primaryColor,
                      fontSize: width*.07,
                      fontWeight: FontWeight.w600),
                ),
              ],
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
                      child: SvgPicture.asset('Assets/Images/$image',height:30,width: 30,color: AppConstant.primaryColor,),
                      // Image.asset(
                      //    'Assets/Images/$image',
                      //   height: 30,
                      //   width: 30,
                      // ),
                    ),
                    Expanded(
                      child: Text(
                        desc,
                        style: TextStyle(
                            fontSize: 15,
                            color: AppConstant.primaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 6),
                      child: Icon(
                        Icons.chevron_right,
                        color: AppConstant.primaryColor,
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

}

