import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:textile_service/Screens/Worker/Home%20Screen/worker_home_screen.dart';
import 'package:textile_service/Utils/pref_utils.dart';

import '../../../Utils/ClipperPath.dart';
import '../../../Utils/app_constant.dart';
import '../../Distributor/HomeScreen.dart';


class WorkerLoginScreen extends StatefulWidget {
  const WorkerLoginScreen({Key? key}) : super(key: key);

  @override
  State<WorkerLoginScreen> createState() => _WorkerLoginScreenState();
}

class _WorkerLoginScreenState extends State<WorkerLoginScreen> {

  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isVisible = true;
  bool isLoading = false;
  final key = GlobalKey<FormState>();
  PrefUtils prefUtils = PrefUtils();
  RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");


  signIn() async {
    try {
      setState(() {
        isLoading = true;
      });

      QuerySnapshot workers =
      await FirebaseFirestore.instance.collection('Workers').get();

      var allData = workers.docs.map((doc) => doc.data()).toList();
      var passwords = workers.docs.map((doc) => doc.get('password')).toList();
      var name = workers.docs.map((doc) => doc.get('user_name')).toList();
      var id = workers.docs.map((doc) => doc.id).toList();
      for (var i = 0; i < allData.length; i++) {
        if (userName.text == name[i] && password.text == passwords[i]) {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Login Successfully',
              message: 'Login successfully done to the Textile-Services',
              contentType: ContentType.success,
            ),
          );
          prefUtils.setName(userName.text);
          prefUtils.setRole("Worker");
          prefUtils.setWorkerID(id[i]);
          if(!mounted) return;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
          setState(() {});
          isLoading = false;
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const WorkerHomeScreen()), (route) => false);
        } else {
          final snackBar = SnackBar(
            /// need to set following properties for best effect of awesome_snackbar_content
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Something went wrong',
              inMaterialBanner: true,
              message: "Username and password are not match.",
              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
              contentType: ContentType.failure,
            ),
          );
          if(!mounted) return;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
          setState(() {});
          isLoading = false;
        }
      }
    } catch (e) {
      // TODO
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConstant.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: SizedBox(
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
                    height: size.height*0.50,
                    width: size.width,
                    margin: EdgeInsets.fromLTRB(size.width*0.05, size.height*0.20, size.width*0.05, size.height*0.10),
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
                      child: Form(
                        key: key,
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
                                    Text("Login Here",
                                      style: TextStyle(
                                        fontSize: size.width * 0.058,
                                        letterSpacing: 2.3,
                                        fontFamily: AppConstant.medium,
                                        color: AppConstant.primaryTextDarkColor,
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.04),
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      cursorColor: AppConstant.primaryTextDarkColor,
                                      controller: userName,
                                      style: TextStyle(
                                        fontSize: size.width * 0.04,
                                        letterSpacing: 1,
                                        fontFamily: AppConstant.medium,
                                        color: AppConstant.primaryTextDarkColor,
                                      ),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.email, color: AppConstant.primaryColor, size: 22,),
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
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: AppConstant.errorColor),
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: AppConstant.errorColor),
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                        ),
                                        labelText: 'Username',
                                        labelStyle: TextStyle(color: Colors.grey[600]),
                                        contentPadding: EdgeInsets.fromLTRB(15, 3, 0, 0),
                                        hintStyle: TextStyle(color: Colors.grey[600]),
                                      ),
                                      validator: (value){
                                        if(value!.isEmpty){
                                          return "Enter your username";
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: size.height * 0.02),
                                    TextFormField(
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.done,
                                      cursorColor: AppConstant.primaryTextDarkColor,
                                      obscureText: isVisible,
                                      controller: password,
                                      style: TextStyle(
                                        fontSize: size.width * 0.041,
                                        letterSpacing: 1,
                                        fontFamily: AppConstant.medium,
                                        color: AppConstant.primaryTextDarkColor,
                                      ),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock, color: AppConstant.primaryColor, size: 22,),
                                        suffixIcon: IconButton(
                                          onPressed: (){
                                            setState(() {
                                              isVisible = !isVisible;
                                            });
                                          },
                                          icon: Icon(isVisible == true? Icons.visibility : Icons.visibility_off, size: 22, color: AppConstant.primaryColor),
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
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: AppConstant.errorColor),
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: AppConstant.errorColor),
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                        ),
                                        labelText: 'Password',
                                        labelStyle: TextStyle(color: Colors.grey[600]),
                                        contentPadding: EdgeInsets.fromLTRB(15, 3, 0, 0),
                                        hintStyle: TextStyle(color: Colors.grey[600]),
                                      ),
                                      validator: (value){
                                        if(value!.isEmpty){
                                          return "Enter your password";
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: size.height * 0.04),
                                    MaterialButton(
                                      onPressed: () {
                                        if(key.currentState!.validate()){
                                          signIn();
                                        }
                                        },
                                      height: size.height * 0.06,
                                      elevation: 3,
                                      color: AppConstant.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: !isLoading ? Container(
                                        margin: EdgeInsets.symmetric(horizontal: size.width*0.235),
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                              fontSize: size.width*0.05,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ): Container(
                                          margin: EdgeInsets.symmetric(horizontal: size.width*0.250),
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