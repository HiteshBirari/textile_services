

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:textile_service/Screens/Distributor/Login%20Screen/login_screen.dart';

import '../../Utils/ClipperPath.dart';
import '../../Utils/app_constant.dart';

class SelectLoginType extends StatefulWidget {
  const SelectLoginType({Key? key}) : super(key: key);

  @override
  State<SelectLoginType> createState() => _SelectLoginTypeState();
}

class _SelectLoginTypeState extends State<SelectLoginType> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConstant.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Container(
              height: size.height*0.80,
              alignment: Alignment.center,
              child: ClipPath(
                clipper: CustomClipPath(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: AppConstant.primaryColor,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: size.height*0.35,
                    width: size.width,
                    margin: EdgeInsets.fromLTRB(size.width*0.05, size.height*0.06, size.width*0.05, size.height*0.10),
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
                    child: Padding(
                      padding: EdgeInsets.only(left:size.width*0.05, right:size.width*0.05),
                      child: AnimationLimiter(
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
                                  Text("Select Login",
                                    style: TextStyle(
                                      fontSize: size.width * 0.058,
                                      letterSpacing: 2.3,
                                      fontFamily: AppConstant.medium,
                                      color: AppConstant.primaryTextDarkColor,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.04),
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()),(route) => false);
                                    },
                                    height: size.height * 0.06,
                                    elevation: 3,
                                    color: AppConstant.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: size.width*0.126),
                                      child: Text(
                                        'Distributor Login',
                                        style: TextStyle(
                                            fontSize: size.width*0.05,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.03),
                                  MaterialButton(
                                    onPressed: () {
                                    },
                                    height: size.height * 0.06,
                                    elevation: 3,
                                    color: AppConstant.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: size.width*0.170),
                                      child: Text(
                                        'Worker Login',
                                        style: TextStyle(
                                            fontSize: size.width*0.05,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.023),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
