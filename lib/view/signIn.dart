import 'package:antic/controller/authController/obsController.dart';
import 'package:antic/model/services/authServices.dart';
import 'package:antic/view/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../commonWidgets/inputField.dart';
import '../const/const.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var emailController = TextEditingController();
  var passController = TextEditingController();

  // var authCon = AuthController();

  var passHide = Get.put(PassHide());
  var loading = Get.put(Loading());

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Lets Sign In"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: context.height * 0.02,
                vertical: context.height * 0.02),
            child: Column(
              children: [
                SizedBox(height: 30),
                Image.asset('./assets/images/logo.png'),
                SizedBox(height: 30),
                inputField("Email", "Enter your Email", emailController,
                    Icons.email, false, TextInputType.emailAddress),
                SizedBox(height: 10),
                Obx(
                  () => inputField(
                      "Password",
                      "Enter your Password",
                      passController,
                      Icons.password,
                      passHide.hide.value,
                      TextInputType.visiblePassword,
                      passHide),
                ),
                SizedBox(height: 30),
                Obx(
                  () => loading.isLoading.value
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(purpleColor),
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: TextButton(
                            child: Text(
                              "Sign In",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                purpleColor,
                              ),
                            ),
                            onPressed: () async {
                              loading.isLoading(true);
                              if (emailController.text.trim().isNotEmpty &&
                                  passController.text.isNotEmpty) {
                                await AuthServices.authInstance.login(
                                    emailController.text.trim(),
                                    passController.text);
                              } else {
                                Get.snackbar('Incorrect',
                                    'Please provide correct credentials');
                              }
                              loading.isLoading(false);
                            },
                          ),
                        ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildHorLine(double wid) {
    return SizedBox(
      height: 1,
      width: wid,
      child: Container(
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
