import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:textile_service/Screens/Distributor/HomeScreen.dart';
import 'package:textile_service/Screens/Distributor/Register%20Screen/Database/distributor_database.dart';
import 'package:textile_service/Screens/Distributor/Register%20Screen/Models/distributor_model.dart';
import 'package:textile_service/Utils/app_constant.dart';
import 'package:textile_service/Utils/pref_utils.dart';
import '../../../Utils/ClipperPath.dart';
import '../Login Screen/login_screen.dart';



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
  bool isLoading = false;
  final key = GlobalKey<FormState>();
  String? role;
  DistributorDatabase db = DistributorDatabase();
  RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  PrefUtils prefUtils = PrefUtils();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppConstant.backgroundColor,
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
                Container(
                  height: size.height*0.65,
                  width: size.width,
                  margin: EdgeInsets.fromLTRB(size.width*0.05, size.height*0.25, size.width*0.05, size.height*0.10),
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
                    padding: EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05),
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
                                  verticalOffset: 55.0,
                                  child: FadeInAnimation(child: widget),
                                ),
                                children: [
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
                                      color: AppConstant.colorDrawerIcon,
                                    ),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.account_circle, color: AppConstant.primaryColor, size: 22,),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppConstant.primaryColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppConstant.primaryColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppConstant.primaryColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppConstant.errorColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppConstant.errorColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      labelText: 'Name',
                                      labelStyle: TextStyle(color: Colors.grey[600]),
                                      contentPadding: const EdgeInsets.fromLTRB(15, 3, 0, 0),
                                      hintStyle: TextStyle(color: Colors.grey[600]),
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
                                      color: AppConstant.colorDrawerIcon,
                                    ),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.phone, color: AppConstant.primaryColor, size: 22,),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppConstant.primaryColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppConstant.primaryColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppConstant.primaryColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppConstant.errorColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppConstant.errorColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      labelText: 'Mobile Number',
                                      labelStyle: TextStyle(color: Colors.grey[600]),
                                      contentPadding: const EdgeInsets.fromLTRB(15, 3, 0, 0),
                                      hintStyle: TextStyle(color: Colors.grey[600]),
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
                                      fontSize: size.width * 0.04,
                                      letterSpacing: 1,
                                      fontFamily: AppConstant.medium,
                                      color: AppConstant.colorDrawerIcon,
                                    ),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.email, color: AppConstant.primaryColor, size: 22,),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppConstant.primaryColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppConstant.primaryColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppConstant.primaryColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppConstant.errorColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppConstant.errorColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      labelText: 'Email',
                                      labelStyle: TextStyle(color: Colors.grey[600]),
                                      contentPadding: const EdgeInsets.fromLTRB(15, 3, 0, 0),
                                      hintStyle: TextStyle(color: Colors.grey[600]),
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
                                      color: AppConstant.colorDrawerIcon,
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
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppConstant.primaryColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppConstant.primaryColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppConstant.errorColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppConstant.errorColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      labelText: 'Password',
                                      labelStyle: TextStyle(color: Colors.grey[600]),
                                      contentPadding: const EdgeInsets.fromLTRB(15, 3, 0, 0),
                                      hintStyle: TextStyle(color: Colors.grey[600]),
                                    ),
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return "Enter your password";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: size.height * 0.06),
                                  MaterialButton(
                                    onPressed: () {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      if(key.currentState!.validate()){
                                        setState(() {
                                          isLoading = true;
                                        });
                                        try {
                                          FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text.toString())
                                              .then((value) {
                                            db.addDistributor(data: DistributorModel(
                                              name: name.text,
                                              mobileNumber: '+91${mobileNo.text}',
                                              email: email.text,
                                              lastUpdatedTime: DateTime.now(),
                                            ));
                                            prefUtils.setName(name.text);
                                            prefUtils.setPhoneNumber('+91${mobileNo.text}');
                                            prefUtils.setEmail(email.text);
                                            prefUtils.setRole("Distributor");
                                          }).then((value) {
                                            final snackBar = SnackBar(
                                              elevation: 0,
                                              behavior: SnackBarBehavior
                                                  .floating,
                                              backgroundColor: Colors
                                                  .transparent,
                                              content: AwesomeSnackbarContent(
                                                title: 'Registration Successfully',
                                                message: 'Registration successfully done to the Textile-Services',
                                                contentType: ContentType.success,
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(snackBar);
                                            setState(() {});
                                            isLoading = false;
                                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);

                                          }).onError((error, stackTrace) {
                                            final snackBar = SnackBar(
                                              /// need to set following properties for best effect of awesome_snackbar_content
                                              elevation: 0,
                                              behavior: SnackBarBehavior.floating,
                                              backgroundColor: Colors.transparent,
                                              content: AwesomeSnackbarContent(
                                                title: 'Something went wrong',
                                                inMaterialBanner: true,
                                                message: error.toString().split(']')[1],
                                                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                contentType: ContentType.failure,
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(snackBar);
                                            setState(() {});
                                            isLoading = false;
                                          });
                                        }catch(error){
                                          final snackBar = SnackBar(
                                            /// need to set following properties for best effect of awesome_snackbar_content
                                            elevation: 0,
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.transparent,
                                            content: AwesomeSnackbarContent(
                                              title: 'Somethings went wrong!',
                                              message: error.toString(),
                                              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                              contentType: ContentType.failure,
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(snackBar);
                                          setState(() {});
                                          isLoading = false;
                                        }

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
                                          'Register',
                                          style: TextStyle(
                                              fontSize: size.width*0.05,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        )
                                    ): Container(
                                        margin: EdgeInsets.symmetric(horizontal: size.width*0.285),
                                        child: CircularProgressIndicator(color: AppConstant.backgroundColor,)),
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
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
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
