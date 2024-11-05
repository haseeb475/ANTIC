import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../commonWidgets/inputField.dart';
import '../../const/const.dart';
import '../controller/authController/authController.dart';
import '../controller/authController/obsController.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var currentPassword = TextEditingController();
  var newPassword = TextEditingController();
  var confirmPassword = TextEditingController();

  var authCon = AuthController();

  var passHide1 = Get.put(PassHide(), tag: "1");
  var passHide2 = Get.put(PassHide(), tag: "2");
  var passHide3 = Get.put(PassHide(), tag: "3");

  var loading = Get.put(Loading());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.height * 0.0095,
            vertical: context.height * 0.0095,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: BackButton(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.height * 0.02,
              vertical: context.height * 0.02,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Create New Password',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 21,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Obx(
                  () => inputField(
                      'Current Password',
                      'Enter your Current Password',
                      currentPassword,
                      Icons.password,
                      passHide1.hide.value,
                      TextInputType.visiblePassword,
                      passHide1),
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(
                  () => inputField(
                      'New Password',
                      'Enter new Password',
                      newPassword,
                      Icons.password,
                      passHide2.hide.value,
                      TextInputType.visiblePassword,
                      passHide2),
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(
                  () => inputField(
                      'Confirm Password',
                      'Enter new Passsword Again',
                      confirmPassword,
                      Icons.password,
                      passHide3.hide.value,
                      TextInputType.visiblePassword,
                      passHide3),
                ),
                SizedBox(
                  height: 15,
                ),
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
                              "Confirm",
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
                              await authCon.updatePassController(
                                  currentPassword.text,
                                  newPassword.text,
                                  confirmPassword.text);
                              loading.isLoading(false);
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
