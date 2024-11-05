import 'package:antic/model/services/profileInfoServices.dart';
import 'package:antic/view/signUp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../const/const.dart';
import '../controller/obsController.dart';
import '../controller/profileObsController.dart';
import '../model/classes/userInfoModel.dart';
import '../model/services/authServices.dart';
import 'changepassword.dart';

class Settings extends StatefulWidget {
  final UserProfile userProfile;

  const Settings({Key? key, required this.userProfile}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool darkMode = false;

  var darkModeController = Get.put(DarkModeController());

  var profileInfoCon = ProfileInfoServices();
  var loading = Get.put(Loading(), tag: "1");
  var loading2 = Get.put(Loading(), tag: "2");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Profile"),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: context.height * 0.02,
                  vertical: context.height * 0.02),
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      var user = profileInfoCon.getUserProfile();

                      // await Get.to(() => Information(userProfile: user),
                      //     transition: Transition.rightToLeft,
                      //     duration: Duration(milliseconds: 700));
                      // setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          widget.userProfile.name!,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(widget.userProfile.email!),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          maxRadius: 28,
                          child: widget.userProfile.imageUrl!.isEmpty
                              ? Icon(
                                  CupertinoIcons.person,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  size: 30,
                                )
                              : CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  maxRadius: 28,
                                  backgroundImage: NetworkImage(
                                      widget.userProfile.imageUrl!),
                                ),
                        ),
                        // trailing: Icon(CupertinoIcons.keyboard_arrow_right),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Settings",
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (ProfileInfoServices
                          .profileInfoServicesInstance.userProfile.role ==
                      'admin')
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        UserProfile user = UserProfile();
                        Get.to(() => SignUp(userProfile: user),
                            transition: Transition.rightToLeft);
                        // Get.to(() => Policy());
                      },
                      child: buildSetting(
                          "Add new User", CupertinoIcons.person_add),
                    ),
                  SizedBox(height: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Get.to(
                        () => ChangePassword(),
                        transition: Transition.rightToLeft,
                      );
                    },
                    child:
                        buildSetting("Change Password", CupertinoIcons.padlock),
                  ),
                  SizedBox(height: 10),
                  Obx(
                    () => Container(
                      alignment: Alignment.center,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SwitchListTile(
                        activeColor: purpleColor,
                        title: Text(
                          "Dark Mode",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        secondary: Icon(
                          CupertinoIcons.moon,
                          color: purpleColor,
                          size: 20,
                        ),
                        value: darkModeController.darkMode.value,
                        onChanged: (bool value) {
                          setState(
                            () {
                              darkModeController.darkMode.value = value;
                              if (darkModeController.darkMode.value) {
                                Get.changeThemeMode(ThemeMode.dark);
                              } else {
                                Get.changeThemeMode(ThemeMode.light);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Get.defaultDialog(
                          title: "Are you Sure?",
                          middleText: "You will be Logged out",
                          textConfirm: "Logout",
                          confirmTextColor: Colors.white,
                          buttonColor: purpleColor,
                          onConfirm: () {
                            AuthServices.authInstance.signOut();
                          });
                    },
                    child: buildSetting("Log Out", CupertinoIcons.power),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Container buildSetting(var title, var leadingIcon) {
    return Container(
      alignment: Alignment.center,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: Icon(
          leadingIcon,
          size: 20,
          color: purpleColor,
        ),
        trailing: Icon(CupertinoIcons.arrow_right),
      ),
    );
  }
}
