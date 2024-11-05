import 'dart:io';

import 'package:antic/const/const.dart';
import 'package:antic/model/classes/patientInfoModel.dart';
import 'package:antic/model/services/patientServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../commonWidgets/inputField.dart';
import '../../model/classes/userInfoModel.dart';
import '../navigation.dart';

class AddPatient extends StatefulWidget {
  final Patient patient;
  final bool newPatient;
  final bool navigateToHome;
  const AddPatient(
      {super.key,
      required this.patient,
      required this.newPatient,
      required this.navigateToHome});

  @override
  State<AddPatient> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController bloodType = TextEditingController();
  TextEditingController id = TextEditingController();

  var loading = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    name.text = widget.patient.name;
    age.text = widget.patient.age;
    bloodType.text = widget.patient.bloodType;
    id.text = widget.patient.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: context.height * 0.75,
          child: ListView(
            padding: EdgeInsets.all(20),
            physics: BouncingScrollPhysics(),
            children: [
              if (!widget.newPatient)
                Center(
                  child: Text(
                    'Edit',
                    style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
              SizedBox(height: 25),
              CircleAvatar(
                radius: 50,
                child: Icon(
                  CupertinoIcons.person,
                  size: 50,
                ),
              ),
              SizedBox(height: 25),
              inputField('Name', 'Enter Patient Name', name, Icons.person,
                  false, TextInputType.name),
              SizedBox(height: 10),
              inputField('Age', 'Enter Patient age', age, Icons.numbers, false,
                  TextInputType.phone),
              SizedBox(height: 10),
              inputField('Blood Type', 'Enter Patient blood type', bloodType,
                  Icons.bloodtype, false, TextInputType.text),
              SizedBox(height: 10),
              if (widget.newPatient)
                inputField('Id', 'Enter Patient Unique Id', id,
                    Icons.numbers_sharp, false, TextInputType.text),
              SizedBox(height: 20),
              Obx(
                () => InkWell(
                  onTap: () async {
                    loading(true);
                    if (name.text.trim().isEmpty ||
                        age.text.trim().isEmpty ||
                        id.text.trim().isEmpty ||
                        bloodType.text.trim().isEmpty) {
                      Get.snackbar('Empty Fields', 'Fill all the Fields');
                    } else {
                      widget.patient.name = name.text.trim();
                      widget.patient.age = age.text.trim();
                      widget.patient.id = id.text.trim();
                      widget.patient.bloodType = bloodType.text.trim();

                      bool success = await PatientServices()
                          .savePatient(widget.patient, widget.newPatient);
                      if (success) {
                        if (widget.navigateToHome) {
                          Get.offAll(
                              () => Navigation(
                                    index: 1,
                                  ),
                              transition: Transition.fade);
                        } else {
                          Get.back();
                        }
                        Get.snackbar('Success', 'Patient Added');
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
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'Save',
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
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
