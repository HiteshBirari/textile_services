import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:textile_service/Utils/app_constant.dart';
import 'package:textile_service/Utils/pref_utils.dart';
import '../../../Utils/ClipperPath.dart';
import '../HomeScreen.dart';
import '../Register Screen/register_screen.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isVisible = true;
  bool isLoading = false;
  final key = GlobalKey<FormState>();
  PrefUtils prefUtils = PrefUtils();
  RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");


  Future<void> signIn() async {
    QuerySnapshot workers =
    await FirebaseFirestore.instance.collection('Distributors').get();
    var allData = workers.docs.map((doc) => doc.data()).toList();
    var name = workers.docs.map((doc) => doc.get('name')).toList();
    var phoneNumber = workers.docs.map((doc) => doc.get('mobileNumber')).toList();
    var emails = workers.docs.map((doc) => doc.get('email')).toList();
    for (var i = 0; i < allData.length; i++) {
      if (email.text == emails[i]) {
        prefUtils.setName(name[i]);
        prefUtils.setPhoneNumber(phoneNumber[i]);
        prefUtils.setEmail(emails[i]);
        prefUtils.setRole("Distributor");
      }
    }
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
                                        labelText: 'Email',
                                        labelStyle: TextStyle(color: Colors.grey[600]),
                                        contentPadding: EdgeInsets.fromLTRB(15, 3, 0, 0),
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
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        setState(() {
                                          if(key.currentState!.validate()){
                                            setState(() {});
                                            isLoading = true;
                                            signIn().whenComplete((){
                                              try {
                                                FirebaseAuth.instance.signInWithEmailAndPassword(
                                                    email: email.text, password: password.text).then((value) {
                                                  final snackBar = SnackBar(
                                                    /// need to set following properties for best effect of awesome_snackbar_content
                                                    elevation: 0,
                                                    behavior: SnackBarBehavior.floating,
                                                    backgroundColor: Colors.transparent,
                                                    content: AwesomeSnackbarContent(
                                                      title: 'Login Successfully',
                                                      message: 'Login successfully done to the Textile-Services',
                                                      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
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
                                                print(error.toString());
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
                                            });
                                          }
                                        });
                                        return;
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
                                    SizedBox(height: size.height * 0.023),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Don't have an account?",
                                          style: TextStyle(
                                            fontSize: size.width * 0.042,
                                            fontFamily: AppConstant.regular,
                                            color: AppConstant.primaryTextDarkColor,
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.01),
                                        InkWell(
                                          onTap: (){
                                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const RegisterScreen()), (route) => false);
                                          },
                                          child: Text("Register",
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
