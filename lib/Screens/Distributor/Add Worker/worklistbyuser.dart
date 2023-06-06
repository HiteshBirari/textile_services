


import 'dart:io';
import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:textile_service/Screens/Distributor/AddWork/Models/add_work_model.dart';

import '../../../Utils/ClipperPath.dart';
import '../../../Utils/app_constant.dart';
import '../../../Utils/pref_utils.dart';
import '../AddWork/Database/add_work_database.dart';
import 'Database/add_worker_database.dart';

class WorkListByUser extends StatefulWidget {
  String workerId;
  WorkListByUser(this.workerId,{Key? key}) : super(key: key);

  @override
  State<WorkListByUser> createState() => _WorkListByUserState();
}

class _WorkListByUserState extends State<WorkListByUser> {


  PrefUtils prefUtils = PrefUtils();
  AddWorkDatabase db = AddWorkDatabase();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double statusBarHeight= MediaQuery.of(context).padding.top;

    return  Scaffold(
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
                              padding: EdgeInsets.only(top: statusBarHeight * 1.5, left: width * 0.02),
                              margin: EdgeInsets.fromLTRB(0, 0, width*.08, height*.02),
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
                                  Center(
                                    child: Text(
                                      'Work List',
                                      style: TextStyle(
                                          fontSize: width * 0.05,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Container(),
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
              child: _buildWorkerListView(),
            )
          ],
        ),
      ),
    );
  }

  _buildWorkerListView() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
        stream: AddWorkDatabase().listenWork(widget.workerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.length == 0) {
            return const Center(
              child: Text(
                'No any Work for this worker / Please assign work first',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
            );
          } else {
            return AnimationLimiter(
              child: Column(
                children: [
                  // Padding(
                  //   padding: EdgeInsets.only(bottom: height * 0.02),
                  //   child: Row(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.all(07),
                  //         child: Tooltip(
                  //           message: 'Download Excel',
                  //           child: Bounce(
                  //             duration: const Duration(milliseconds: 110),
                  //             onPressed: () async {
                  //               Directory? directory;
                  //               try{
                  //                 if (await _requestPermission(Permission.storage)) {
                  //                   directory = io.Directory('/storage/emulated/0/Download');
                  //                 }else {
                  //                   return;
                  //                 }
                  //                 if (!await directory!.exists()) {
                  //                   await directory.create(recursive: true);
                  //                 }
                  //                 if (await directory.exists()) {
                  //                   final excel = Excel.createExcel();
                  //                   final sheet = excel[excel.getDefaultSheet()!];
                  //
                  //                   sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0,rowIndex: 0)).value= 'ItemName';
                  //                   sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1,rowIndex: 0)).value='ItemQuantity';
                  //                   sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2,rowIndex: 0)).value='TotalPrice';
                  //
                  //                   for(int row = 1; row <= snapshot.data!.docs.length; row++) {
                  //
                  //                     sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0,rowIndex: row)).value=snapshot.data!.docs[row-1]['item'].toString();
                  //                     sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1,rowIndex: row)).value=snapshot.data!.docs[row-1]['quantity'].toString();
                  //                     sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2,rowIndex: row)).value=snapshot.data!.docs[row-1]['totalPrice'].toString();
                  //
                  //                   }
                  //
                  //                   File file = File('${directory.path}/${prefUtils.getName()}.xlsx');
                  //                   List<int>? fileBytes = excel.save();
                  //                   if(fileBytes != null){
                  //                     File(file.path)..createSync(recursive: true)..writeAsBytesSync(fileBytes);
                  //                     AppConstant().showToast("Excel downloaded successfully");
                  //                     OpenFile.open(file.path);
                  //                   }
                  //                 }
                  //               }catch(e){
                  //                 print(e);
                  //               }
                  //             },
                  //             child: Container(
                  //               decoration: BoxDecoration(
                  //                 color: AppConstant.backgroundColor,
                  //                 borderRadius: BorderRadius.circular(05),
                  //                 boxShadow: const [
                  //                   BoxShadow(
                  //                     color: Colors.grey,
                  //                     blurRadius: 3,
                  //                     spreadRadius: 1,
                  //                   ),
                  //                 ],
                  //               ),
                  //               child: Padding(
                  //                 padding: const EdgeInsets.all(05),
                  //                 child: Image.asset(
                  //                   'Assets/Images/download.png',
                  //                   color: AppConstant.primaryColor,
                  //                   height: height*0.04,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
                                      height: height * 0.07,
                                      width: width * 0.02,
                                      margin: EdgeInsets.fromLTRB(width * 0.01,
                                          height * 0.015, width * 0.02, height * 0.01),
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
                                            0, height * 0.015, 0, 0),
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
                                                Text(
                                                  'TotalPrice : ${snapshot.data!.docs[index]['totalPrice']}',
                                                  style: TextStyle(
                                                      fontSize: width * 0.035),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 3),
                                              Row(
                                              children: [
                                                Text(
                                                  'Status : ',
                                                  style: TextStyle(
                                                      fontSize: width * 0.035),
                                                ),
                                                !isLoading ? Bounce(
                                                    duration: const Duration(milliseconds:90),
                                                    onPressed: ()async{
                                                      if(snapshot.data!.docs[index]['status'] == 'Pending'){
                                                        setState(() {
                                                          isLoading = true;
                                                        });
                                                        db.updateWork(data: AddWorkModel(
                                                            item: snapshot.data!.docs[index]['item'],
                                                            itemImage: snapshot.data!.docs[index]['itemImage'],
                                                            quantity: snapshot.data!.docs[index]['quantity'],
                                                            totalPrice: snapshot.data!.docs[index]['totalPrice'],
                                                            status: 'Completed',
                                                            lastUpdatedTime: DateTime.now(),
                                                            docID: snapshot.data!.docs[index].id,
                                                            workerId: snapshot.data!.docs[index]['workerId']
                                                        )).then((value){
                                                          AppConstant().showToast('Status Updated Successfully');
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                        });
                                                      }
                                                    },
                                                    child:Text(
                                                      '${snapshot.data!.docs[index]['status']}',
                                                      style: TextStyle(
                                                          color: snapshot.data!.docs[index]['status'] == 'Pending'
                                                              ? AppConstant.pendingColor
                                                              : AppConstant.successColor,
                                                          fontSize: width * 0.035),
                                                    )
                                                ) : SpinKitThreeBounce(
                                                  color: AppConstant.primaryColor,
                                                  size: 20.0,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 3),
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
