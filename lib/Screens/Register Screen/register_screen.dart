import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:textile_service/Screens/Login%20Screen/login_screen.dart';
import 'package:textile_service/Utils/app_constant.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  TextEditingController name = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isVisible = true;
  final key = GlobalKey<FormState>();
  String? role;

  RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConstant.backgroundColor,
       body: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Center(
             child: Container(
               height: size.height * 0.6,
               width: size.width * 0.9,
               decoration: BoxDecoration(
                 border: Border.all(
                   color: AppConstant.borderColor,
                   width: 1,
                 ),
                 borderRadius: BorderRadius.circular(7),
               ),
               child: Padding(
                 padding: EdgeInsets.only(left: size.width * 0.04, right: size.width * 0.04),
                 child: Form(
                   key: key,
                   child: AnimationLimiter(
                     child: Column(
                       children: AnimationConfiguration.toStaggeredList(
                         duration: const Duration(milliseconds: 275),
                         childAnimationBuilder: (widget) => SlideAnimation(
                           verticalOffset: 56.0,
                           child: FadeInAnimation(child: widget),
                         ),
                         children: [
                           SizedBox(height: size.height * 0.01),
                           Text("Register Here",
                             style: TextStyle(
                               fontSize: size.width * 0.058,
                               letterSpacing: 2.3,
                               fontFamily: AppConstant.medium,
                               color: AppConstant.primaryTextDarkColor,
                             ),
                           ),
                           SizedBox(height: size.height * 0.04),
                           TextFormField(
                             keyboardType: TextInputType.name,
                             textInputAction: TextInputAction.done,
                             cursorColor: AppConstant.primaryTextDarkColor,
                             controller: name,
                             style: TextStyle(
                               fontSize: size.width * 0.041,
                               letterSpacing: 1,
                               fontFamily: AppConstant.medium,
                               color: AppConstant.primaryTextDarkColor,
                             ),
                             decoration: InputDecoration(
                               hintText: "Name",
                               hintStyle: TextStyle(
                                 fontSize: size.width * 0.04,
                                 letterSpacing: 1,
                                 fontFamily: AppConstant.regular,
                                 color: AppConstant.primaryTextDarkColor,
                               ),
                               enabledBorder: OutlineInputBorder(
                                 borderSide: BorderSide(
                                     color: AppConstant.borderColor,
                                     width: 0.6
                                 ),
                               ),
                               focusedBorder: OutlineInputBorder(
                                 borderSide: BorderSide(
                                     color: AppConstant.borderColor,
                                     width: 1.1
                                 ),
                               ),
                               errorBorder: OutlineInputBorder(
                                 borderSide: BorderSide(
                                     color: Colors.red[600]!,
                                     width: 0.6
                                 ),
                               ),
                               focusedErrorBorder: OutlineInputBorder(
                                 borderSide: BorderSide(
                                     color: Colors.red[600]!,
                                     width: 1.1
                                 ),
                               ),
                               prefixIcon: Icon(Icons.account_circle, color: AppConstant.borderColor, size: 22,),
                             ),
                             validator: (value){
                               if(value!.isEmpty){
                                 return "Enter your name";
                               }
                               return null;
                             },
                           ),
                           SizedBox(height: size.height * 0.015),
                           TextFormField(
                             keyboardType: TextInputType.number,
                             textInputAction: TextInputAction.next,
                             cursorColor: AppConstant.primaryTextDarkColor,
                             controller: mobileNo,
                             style: TextStyle(
                               fontSize: size.width * 0.041,
                               letterSpacing: 1,
                               fontFamily: AppConstant.medium,
                               color: AppConstant.primaryTextDarkColor,
                             ),
                             decoration: InputDecoration(
                                 hintText: "Mobile Number",
                                 hintStyle: TextStyle(
                                   fontSize: size.width * 0.04,
                                   letterSpacing: 1,
                                   fontFamily: AppConstant.regular,
                                   color: AppConstant.primaryTextDarkColor,
                                 ),
                                 enabledBorder: OutlineInputBorder(
                                   borderSide: BorderSide(
                                       color: AppConstant.borderColor,
                                       width: 0.6
                                   ),
                                 ),
                                 focusedBorder: OutlineInputBorder(
                                   borderSide: BorderSide(
                                       color: AppConstant.borderColor,
                                       width: 1.1
                                   ),
                                 ),
                                 errorBorder: OutlineInputBorder(
                                   borderSide: BorderSide(
                                       color: Colors.red[600]!,
                                       width: 0.6
                                   ),
                                 ),
                                 focusedErrorBorder: OutlineInputBorder(
                                   borderSide: BorderSide(
                                       color: Colors.red[600]!,
                                       width: 1.1
                                   ),
                                 ),
                                 prefixIcon: Icon(Icons.phone, color: AppConstant.borderColor, size: 22,)
                             ),
                             validator: (value){
                               if(value!.isEmpty){
                                 return "Enter your mobile number.";
                               }else if(value.length < 10){
                                 return "Enter a valid mobile number.";
                               }
                               return null;
                             },
                           ),
                           SizedBox(height: size.height * 0.015),
                           TextFormField(
                             keyboardType: TextInputType.emailAddress,
                             textInputAction: TextInputAction.next,
                             cursorColor: AppConstant.primaryTextDarkColor,
                             controller: email,
                             style: TextStyle(
                               fontSize: size.width * 0.041,
                               letterSpacing: 1,
                               fontFamily: AppConstant.medium,
                               color: AppConstant.primaryTextDarkColor,
                             ),
                             decoration: InputDecoration(
                                 hintText: "Email",
                                 hintStyle: TextStyle(
                                   fontSize: size.width * 0.04,
                                   letterSpacing: 1,
                                   fontFamily: AppConstant.regular,
                                   color: AppConstant.primaryTextDarkColor,
                                 ),
                                 enabledBorder: OutlineInputBorder(
                                   borderSide: BorderSide(
                                       color: AppConstant.borderColor,
                                       width: 0.6
                                   ),
                                 ),
                                 focusedBorder: OutlineInputBorder(
                                   borderSide: BorderSide(
                                       color: AppConstant.borderColor,
                                       width: 1.1
                                   ),
                                 ),
                                 errorBorder: OutlineInputBorder(
                                   borderSide: BorderSide(
                                       color: Colors.red[600]!,
                                       width: 0.6
                                   ),
                                 ),
                                 focusedErrorBorder: OutlineInputBorder(
                                   borderSide: BorderSide(
                                       color: Colors.red[600]!,
                                       width: 1.1
                                   ),
                                 ),
                                 prefixIcon: Icon(Icons.email, color: AppConstant.borderColor, size: 22,)
                             ),
                             validator: (value){
                               if(value!.isEmpty){
                                 return "Enter your  email";
                               }else if(!emailRegex.hasMatch(value)){
                                 return "Enter a valid email";
                               }
                               return null;
                             },
                           ),
                           SizedBox(height: size.height * 0.015),
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
                               hintText: "Password",
                               hintStyle: TextStyle(
                                 fontSize: size.width * 0.04,
                                 letterSpacing: 1,
                                 fontFamily: AppConstant.regular,
                                 color: AppConstant.primaryTextDarkColor,
                               ),
                               enabledBorder: OutlineInputBorder(
                                 borderSide: BorderSide(
                                     color: AppConstant.borderColor,
                                     width: 0.6
                                 ),
                               ),
                               focusedBorder: OutlineInputBorder(
                                 borderSide: BorderSide(
                                     color: AppConstant.borderColor,
                                     width: 1.1
                                 ),
                               ),
                               errorBorder: OutlineInputBorder(
                                 borderSide: BorderSide(
                                     color: Colors.red[600]!,
                                     width: 0.6
                                 ),
                               ),
                               focusedErrorBorder: OutlineInputBorder(
                                 borderSide: BorderSide(
                                     color: Colors.red[600]!,
                                     width: 1.1
                                 ),
                               ),
                               prefixIcon: Icon(Icons.lock, color: AppConstant.borderColor, size: 22,),
                               suffixIcon: IconButton(
                                 onPressed: (){
                                   setState(() {
                                     isVisible = !isVisible;
                                   });
                                 },
                                 icon: Icon(isVisible == true? Icons.visibility : Icons.visibility_off, size: 22, color: AppConstant.borderColor),
                               ),
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
                             onPressed: (){
                               if(key.currentState!.validate()){

                               }
                             },
                             minWidth: size.width * 0.5,
                             height: size.height * 0.058,
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                             color: AppConstant.buttonColor,
                             child:  Text("Register",
                               style: TextStyle(
                                 fontSize: size.height * 0.03,
                                 letterSpacing: 2.5,
                                 fontFamily: AppConstant.medium,
                                 color: AppConstant.backgroundColor,
                               ),
                             ),
                           ),
                           SizedBox(height: size.height * 0.023),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text("Already have an account?",
                                 style: TextStyle(
                                   fontSize: size.width * 0.042,
                                   fontFamily: AppConstant.regular,
                                   color: AppConstant.primaryTextDarkColor,
                                 ),
                               ),
                               SizedBox(width: size.width * 0.01),
                               InkWell(
                                 onTap: (){
                                   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                                 },
                                 child: Text("Login",
                                   style: TextStyle(
                                     fontSize: size.width * 0.042,
                                     fontFamily: AppConstant.medium,
                                     color: AppConstant.primaryColor,
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         ],
                       ),
                     ),
                   ),
                 ),
               ),
             ),
           ),
         ],
       ),
    );
  }
}
