import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:textile_service/Screens/Distributor/HomeScreen.dart';
import 'package:textile_service/Screens/Worker/Home%20Screen/worker_home_screen.dart';
import 'package:textile_service/Utils/app_constant.dart';
import 'package:textile_service/Utils/pref_utils.dart';
import '../LoginType/SelectLoginType.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String version = "";
  String name = "";
  String role = "";
  PrefUtils prefUtils = PrefUtils();

  Future<void> getData()async{
    name = prefUtils.getName();
    role = prefUtils.getRole();
  }

  Future<void> getAppVersion()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState((){
      version = packageInfo.version;
    });
  }



  Future<void> goToNextPage()async{
    Future.delayed(const Duration(seconds: 2),()async{
      if(name.isEmpty){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SelectLoginType()), (route) => false);
      }else{
        if(role == "Distributor"){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
        }else{
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const WorkerHomeScreen()), (route) => false);
        }
      }
    });
  }


  @override
  void initState() {
    getAppVersion().whenComplete((){
      getData().whenComplete((){
        goToNextPage();
      });
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
          child: Container(
            height: size.height,
            width: size.width,
            child: Stack(
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(child: CircularProgressIndicator(color: AppConstant.primaryColor, strokeWidth: 2.5,)),
                        SizedBox(height: size.height * 0.01),
                        Text("V $version",
                          style: TextStyle(
                            fontSize: size.width * 0.040,
                            fontFamily: AppConstant.regular,
                            color: AppConstant.primaryTextDarkColor,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                      ],
                    ),
                  ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
