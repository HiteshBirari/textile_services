import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:textile_service/Screens/Login%20Screen/login_screen.dart';
import 'package:textile_service/Utils/app_constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String version = "";

  Future<void> getAppVersion()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState((){
      version = packageInfo.version;
    });
  }

  Future<void> goToNextPage()async{
    Future.delayed(const Duration(seconds: 2),(){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
    });
  }


  @override
  void initState() {
    getAppVersion().whenComplete((){
      goToNextPage();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConstant.backgroundColor,
      body: SafeArea(
        child: AnimationLimiter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  AnimationConfiguration.toStaggeredList(
               duration: const Duration(milliseconds: 275),
                childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 76.0,
                    child: FadeInAnimation(child: widget),
                ),
                children: [
                  Center(
                    child: Image(image: const AssetImage("Assets/Icons/logo.png"),
                      height: size.height * 0.4,
                      width: size.width * 0.9,
                    ),
                  ),
                ],
            )
          ),
        ),
      ),
     bottomNavigationBar: SizedBox(
        height: size.height * 0.1,
       width: size.width,
       child: Column(
         children: [
           Center(child: CircularProgressIndicator(color: AppConstant.primaryColor)),
           SizedBox(height: size.height * 0.01),
           Text("V $version",
            style: TextStyle(
              fontSize: size.width * 0.051,
              fontFamily: AppConstant.regular,
              color: AppConstant.primaryTextDarkColor,
            ),
           ),
           SizedBox(height: size.height * 0.01),
         ],
       ),
     ),
    );
  }
}
