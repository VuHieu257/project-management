import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quanly_duan/service/getX/getX.dart';

import '../../../database/database_service.dart';
import '../../../models/manage.dart';
import '../../../service/auth_service.dart';
import '../../home/home_welfare_manager/home.dart';
import '../sign_in/sign_in.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _RegisterAcountState();
}

class _RegisterAcountState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  final TextEditingController _userVerifyPasswordController = TextEditingController();

  final DatabaseUserService _databaseService=DatabaseUserService('db_user');

  RoleController _roleController=Get.put(RoleController());

  bool obscurrentText = true;
  bool obscurrentTextVerify = true;
  bool isSigningUp = false;
  String validEmail="";
  String validPassword="";

  final user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    // TODO: implement dispose
    _userNameController.dispose();
    _userEmailController.dispose();
    _userPasswordController.dispose();
    _userVerifyPasswordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBarSub(role: _roleController.role.value,textAppBar: "Create employee accounts"),
      body: GestureDetector(
        onTap: () => AuthService().hideKeyBoard(),
        child: SingleChildScrollView(
            child:Column(
              children: [
                SizedBox(
                  height: context.height,
                  child: Stack(
                    children: [
                      Container(height: context.height*0.45,width: context.width,color: Colors.green,
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 40,top: 40,left: 20),
                          alignment: Alignment.topLeft,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/logo.jpg"),
                                  fit: BoxFit.fill
                              )
                          ),
                          child: InkWell(onTap: () => Get.offAll(const SignInScreen()),child: const Icon(Icons.arrow_back,color: Colors.white,)),
                        ),
                      ),
                      Align(alignment: Alignment.bottomCenter,
                          child: Container(
                            height: context.height*0.64,
                            width: context.width,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(40),topLeft: Radius.circular(40))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1.0,),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text("Register an account",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical:8.0),
                                          child: SizedBox(
                                            width: context.width*0.85,
                                            child: TextFormField(
                                              validator:(value) => value==null||value.isEmpty?'Please enter username.':null,
                                              keyboardType: TextInputType.emailAddress,
                                              controller: _userNameController,
                                              decoration: const InputDecoration(
                                                alignLabelWithHint: true,
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(width: 1),
                                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                                ),
                                                prefixIcon: Icon(Icons.person,size: 30,),
                                                hintText: "Enter UserName",
                                                labelText: "UserName",
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical:8.0),
                                          child: SizedBox(
                                            width: context.width*0.85,
                                            child: TextFormField(
                                              validator:(value) =>
                                              EmailValidator.validate(value!) ?
                                              // (validEmail?null:"Email already exists. Please use another email.")
                                              (validEmail=="The email address is already in use by another account."? validEmail : null)
                                                  : "Please enter a valid email",
                                              keyboardType: TextInputType.emailAddress,
                                              controller: _userEmailController,
                                              decoration: const InputDecoration(
                                                alignLabelWithHint: true,
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(width: 1),
                                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                                ),
                                                prefixIcon: Icon(Icons.email_outlined,size: 30,),
                                                hintText: "Enter E-mail",
                                                labelText: "E-mail",
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical:8.0),
                                          child: SizedBox(
                                            width: context.width*0.85,
                                            child: TextFormField(
                                              validator:(value) =>(value!.length >= 8 && value!.length<=24)?(validPassword=="The password provided is too weak"? validPassword :null):"Enter a password greater than 8 and less than 24",
                                              keyboardType: TextInputType.emailAddress,
                                              controller: _userPasswordController,
                                              obscureText: obscurrentText,
                                              decoration: InputDecoration(
                                                alignLabelWithHint: true,
                                                border: const OutlineInputBorder(
                                                  borderSide: BorderSide(width: 1),
                                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                                ),
                                                prefixIcon: const Icon(Icons.lock_outline,size: 30,),
                                                hintText: "Enter Password",
                                                labelText: "Password",
                                                suffixIcon: GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      obscurrentText=!obscurrentText;
                                                    });
                                                  },
                                                  child: Icon(obscurrentText?Icons.visibility_off_outlined:Icons.visibility_outlined),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical:8.0),
                                          child: SizedBox(
                                            width: context.width*0.85,
                                            child: TextFormField(
                                              validator:(value) =>
                                              _userPasswordController.text==value?null:"Please check your password again",
                                              keyboardType: TextInputType.text,
                                              controller: _userVerifyPasswordController,
                                              obscureText: obscurrentTextVerify,
                                              decoration: InputDecoration(
                                                alignLabelWithHint: true,
                                                border: const OutlineInputBorder(
                                                  borderSide: BorderSide(width: 1),
                                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                                ),
                                                prefixIcon: const Icon(Icons.security,size: 30,),
                                                hintText: "Enter Verify Password",
                                                labelText: "VerifyPassword",
                                                suffixIcon: GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      obscurrentTextVerify=!obscurrentTextVerify;
                                                    });
                                                  },
                                                  child: Icon(obscurrentTextVerify?Icons.visibility_off_outlined:Icons.visibility_outlined),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () async {
                                      final message = await AuthService().registration(
                                        email: _userEmailController.text,
                                        password: _userPasswordController.text,
                                      );
                                      print('$message------------------');
                                      if(validEmail=='The email is already in use by another account.'){
                                      setState(() {
                                        validEmail='';
                                      });
                                      }
                                      setState(() {
                                        validPassword = message!;
                                        validEmail = message;
                                      });
                                      if(_formKey.currentState!.validate()){
                                        if (message!.contains("The account already exists for that email.") ||
                                            message.contains("The password provided is too weak.")) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(message),
                                            ),
                                          );
                                        } else if (message.contains('Success')) {
                                          Get.offAll(const SignInScreen());
                                          UserData user = UserData(
                                            displayName: _userNameController.text,
                                            email: _userEmailController.text,
                                            password: _userPasswordController.text,
                                            role: "staff",
                                          );
                                          _databaseService.adUserData(user);
                                          Fluttertoast.showToast(msg: "Success");
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: context.height * 0.06,
                                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(16.0),
                                        ),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                            offset: const Offset(1.1, 1.1),
                                            blurRadius: 10.0,
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Register Account',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            letterSpacing: 0.0,
                                            color: Color(0xFFffffff),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }

  Padding customTextField(double width,String title,IconData icon,TextEditingController _controller){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8.0),
      child: SizedBox(
        width: width*0.85,
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          controller: _controller,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            border: const OutlineInputBorder(
              borderSide: BorderSide(width: 1),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            prefixIcon: Icon(icon,size: 30,),
            hintText: "Enter $title",
            labelText: title,
          ),
        ),
      ),
    );
  }
}
