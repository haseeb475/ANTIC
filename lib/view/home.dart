import 'package:antic/commonWidgets/inputField.dart';
import 'package:antic/const/const.dart';
import 'package:antic/controller/extraction/textExtraction.dart';
import 'package:antic/model/classes/patientInfoModel.dart';
import 'package:antic/model/classes/textExtraction.dart';
import 'package:antic/view/patients/selectPatient.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/ImageController.dart';
import '../controller/dialogues.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var picController = Get.put(ImageController());
  TextExtraction textExtraction = TextExtraction();

  var showLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'A N T I C',
              style: GoogleFonts.montserrat(color: purpleColor),
            ),
            // backgroundColor: purpleColor,
          ),
          body: ListView(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            physics: BouncingScrollPhysics(),
            children: [
              // weight
              InkWell(
                onTap: () async {
                  //   await picController.changeImage(context);
                  //   print('Picked');
                  //   String text = await textExtraction
                  //       .getText(picController.picPath.toString());
                  //   HandleExtraction handle = HandleExtraction();
                  //   String weight = handle.handleWeight(text);
                  //   showWeightDialogue(context, weight);
                },
                child: InkWell(
                  onTap: () async {
                    var value = await Get.to(() => SelectPatient());
                    if (value is Patient) {
                      int option = await showImageOptions(context);
                      if (option == 1) {
                        await picController.changeImageCamera(context);
                      } else {
                        await picController.changeImage(context);
                      }
                      if (picController.picPath.value != "") {
                        setState(() {
                          showLoading(true);
                        });

                        String text = await textExtraction
                            .getText2(picController.picPath.toString());
                        setState(() {
                          showLoading(false);
                        });
                        HandleExtraction handle = HandleExtraction();
                        String temp = handle.handleTemp(text);
                        if (temp == '') {
                          Get.snackbar('Alert',
                              "Image quality wasn't optimal, Enter manually");
                        }
                        showWeightDialogue(context, temp, value, text);
                      }
                      picController.picPath.value = "";
                    }
                  },
                  child: renderOption(
                      title: 'Moniter Weight', icon: Icons.monitor_weight),
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                  onTap: () async {
                    var value = await Get.to(() => SelectPatient());
                    if (value is Patient) {
                      int option = await showImageOptions(context);
                      if (option == 1) {
                        await picController.changeImageCamera(context);
                      } else {
                        await picController.changeImage(context);
                      }
                      if (picController.picPath.value != "") {
                        setState(() {
                          showLoading(true);
                        });

                        String text = await textExtraction
                            .getText2(picController.picPath.toString());
                        setState(() {
                          showLoading(false);
                        });

                        HandleExtraction handle = HandleExtraction();
                        List bp = handle.handleBloodPressure(text);
                        if (bp.length != 3) {
                          bp = ['', '', ''];

                          Get.snackbar('Alert',
                              "Image quality wasn't optimal, Enter manually");
                        }
                        showBPDialogue(context, bp, value, text);
                      }
                      picController.picPath.value = "";
                    }
                  },
                  child: renderOption(
                      title: 'Blood Pressure', icon: Icons.bloodtype)),
              SizedBox(height: 10),
              InkWell(
                  onTap: () async {
                    var value = await Get.to(() => SelectPatient());
                    if (value is Patient) {
                      int option = await showImageOptions(context);
                      if (option == 1) {
                        await picController.changeImageCamera(context);
                      } else {
                        await picController.changeImage(context);
                      }
                      if (picController.picPath.value != "") {
                        setState(() {
                          showLoading(true);
                        });

                        String text = await textExtraction
                            .getText2(picController.picPath.toString());
                        setState(() {
                          showLoading(false);
                        });
                        HandleExtraction handle = HandleExtraction();
                        List oxi = handle.handleOxi(text);
                        if (oxi.length != 2) {
                          oxi = ['', ''];

                          Get.snackbar('Alert',
                              "Image quality wasn't optimal, Enter manually");
                        }
                        showOxiDialogue(context, oxi, value, text);
                      }
                      picController.picPath.value = "";
                    }
                  },
                  child: renderOption(
                      title: 'Oxi Meter', icon: Icons.monitor_heart)),
              SizedBox(height: 10),

              InkWell(
                  onTap: () async {
                    var value = await Get.to(() => SelectPatient());
                    if (value is Patient) {
                      int option = await showImageOptions(context);
                      if (option == 1) {
                        await picController.changeImageCamera(context);
                      } else {
                        await picController.changeImage(context);
                      }
                      if (picController.picPath.value != "") {
                        setState(() {
                          showLoading(true);
                        });

                        String text = await textExtraction
                            .getText2(picController.picPath.toString());
                        print(text);
                        setState(() {
                          showLoading(false);
                        });
                        HandleExtraction handle = HandleExtraction();
                        String temp = handle.handleTemp(text);
                        if (temp == '') {
                          Get.snackbar('Alert',
                              "Image quality wasn't optimal, Enter manually");
                        }
                        showTempDialogue(context, temp, value, text);
                      }
                      picController.picPath.value = "";
                    }
                  },
                  child: renderOption(
                      title: 'Temperature', icon: Icons.thermostat)),
            ],
          ),
        ),
        if (showLoading.value)
          Container(
            height: context.height,
            width: context.width,
            color: Colors.grey.withOpacity(0.5),
          ),
        if (showLoading.value)
          Center(
            child: CupertinoActivityIndicator(),
          )
      ],
    );
  }
}

class renderOption extends StatelessWidget {
  final String title;
  final IconData icon;
  const renderOption({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.width * 0.4,
      width: context.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: purpleColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 40,
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.montserrat(fontSize: 18, color: Colors.white),
          )
        ],
      ),
    );
  }
}

class renderOption2 extends StatelessWidget {
  final String title;
  final IconData icon;
  const renderOption2({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.width * 0.4,
      width: context.width * 0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: purpleColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 40,
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.montserrat(fontSize: 18, color: Colors.white),
          )
        ],
      ),
    );
  }
}
