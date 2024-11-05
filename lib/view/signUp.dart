import 'dart:io';

import 'package:antic/const/const.dart';
import 'package:antic/model/services/profileInfoServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../commonWidgets/inputField.dart';
import '../model/classes/userInfoModel.dart';

class SignUp extends StatefulWidget {
  final UserProfile userProfile;
  const SignUp({super.key, required this.userProfile});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController name = TextEditingController();
  TextEditingController role = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  var loading = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    name.text = widget.userProfile.name!;
    role.text = widget.userProfile.role!;
    id.text = widget.userProfile.uid!;
    email.text = widget.userProfile.email!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('New User'),
      ),
      body: SafeArea(
        child: Container(
          // height: context.height * 0.75,
          child: ListView(
            padding: EdgeInsets.all(20),
            physics: BouncingScrollPhysics(),
            children: [
              CircleAvatar(
                radius: 50,
                child: Icon(
                  CupertinoIcons.person,
                  size: 50,
                ),
              ),
              SizedBox(height: 30),
              inputField('Name', 'Enter Name', name, Icons.person, false,
                  TextInputType.name),
              SizedBox(height: 10),
              inputField('Email', 'Enter Email Address', email, Icons.email,
                  false, TextInputType.emailAddress),
              SizedBox(height: 10),
              inputField('Id', 'Enter Work id', id, Icons.numbers, false,
                  TextInputType.text),
              SizedBox(height: 10),
              inputField('Password', 'Choose a password', password,
                  Icons.password, false, TextInputType.visiblePassword),
              SizedBox(height: 20),
              Obx(
                () => InkWell(
                  onTap: () async {
                    loading(true);
                    if (name.text.trim().isEmpty ||
                            email.text.trim().isEmpty ||
                            id.text.trim().isEmpty ||
                            password.text.isEmpty
                        // ||
                        // role.text.trim().isEmpty
                        ) {
                      Get.snackbar('Empty Fields', 'Fill all the Fields');
                    } else {
                      widget.userProfile.name = name.text.trim();
                      widget.userProfile.role = role.text.trim();
                      widget.userProfile.uid = id.text.trim();
                      widget.userProfile.email =
                          email.text.trim().toLowerCase();

                      bool success = await ProfileInfoServices()
                          .saveUser(widget.userProfile, password.text);

                      if (success) {
                        Get.back();
                        Get.snackbar('Success', 'User Added');
                      }
                    }

                    loading(false);
                  },
                  child: loading.value
                      ? CupertinoActivityIndicator(
                          radius: 12,
                        )
                      : Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: purpleColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Save',
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
