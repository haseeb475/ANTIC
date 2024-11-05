import 'package:antic/model/services/authServices.dart';
import 'package:antic/model/services/profileInfoServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../commonWidgets/inputField.dart';
import '../const/const.dart';
import '../model/classes/patientInfoModel.dart';

showOxiDialogue(context, List oxi, Patient patient, String text) {
  TextEditingController spo2 = TextEditingController();
  TextEditingController pulseRate = TextEditingController();
  spo2.text = oxi[0];
  pulseRate.text = oxi[1];
  AlertDialog alertDialog = AlertDialog(
    title: Text('Oxi Meter'),
    content: Text('Patient: ${patient.name}'),
    actions: [
      // Align(
      //     alignment: Alignment.centerLeft,
      //     child: Column(
      //       children: [
      //         // // Text('--- TESTING ---'),
      //         // // Divider(),
      //         // Text(text),
      //         Divider(),
      //       ],
      //     )),
      smallInputField("Spo2", spo2, TextInputType.number),
      SizedBox(height: 10),
      smallInputField("Pulse Rate", pulseRate, TextInputType.number),
      SizedBox(height: 10),
      InkWell(
        onTap: () async {
          if (spo2.text.trim().isEmpty || pulseRate.text.trim().isEmpty) {
            Get.snackbar('Incomplete', 'Kindly fill the fields');
          } else {
            Map<String, dynamic> data = {
              "patientId": patient.id,
              "time": Timestamp.now(),
              "nurseId": ProfileInfoServices
                  .profileInfoServicesInstance.userProfile.uid,
              "spo2": spo2.text.trim(),
              "pulseRate": pulseRate.text.trim()
            };
            await FirebaseFirestore.instance
                .collection("Oxi")
                .add(data)
                .then((value) {
              Get.back();
              Get.snackbar('Success', 'Record Saved');
            });
          }
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: purpleColor,
            borderRadius: BorderRadius.circular(15),
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
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    },
  );
}

showBPDialogue(context, List oxi, Patient patient, String text) {
  TextEditingController spo2 = TextEditingController();
  TextEditingController pulseRate = TextEditingController();
  TextEditingController pulseRate2 = TextEditingController();

  spo2.text = oxi[0];
  pulseRate.text = oxi[1];
  pulseRate2.text = oxi[2];
  AlertDialog alertDialog = AlertDialog(
    title: Text('Blood Pressure'),
    content: Text('Patient: ${patient.name}'),
    actions: [
      smallInputField("Upper", spo2, TextInputType.number),
      SizedBox(height: 10),
      smallInputField("Lower", pulseRate, TextInputType.number),
      SizedBox(height: 10),
      smallInputField("PulseRate", pulseRate2, TextInputType.number),
      SizedBox(height: 10),
      InkWell(
        onTap: () async {
          if (spo2.text.trim().isEmpty ||
              pulseRate.text.trim().isEmpty ||
              pulseRate2.text.trim().isEmpty) {
            Get.snackbar('Incomplete', 'Kindly fill the fields');
          } else {
            Map<String, dynamic> data = {
              "patientId": patient.id,
              "time": Timestamp.now(),
              "nurseId": ProfileInfoServices
                  .profileInfoServicesInstance.userProfile.uid,
              "upper": spo2.text.trim(),
              "lower": pulseRate.text.trim(),
              "pulseRate": pulseRate2.text.trim()
            };
            await FirebaseFirestore.instance
                .collection("BP")
                .add(data)
                .then((value) {
              Get.back();
              Get.snackbar('Success', 'Record Saved');
            });
          }
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: purpleColor,
            borderRadius: BorderRadius.circular(15),
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
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    },
  );
}

showTempDialogue(context, String tempText, Patient patient, String text) {
  TextEditingController temp = TextEditingController();

  temp.text = tempText;
  AlertDialog alertDialog = AlertDialog(
    title: Text('Temperature'),
    content: Text('Patient: ${patient.name}'),
    actions: [
      smallInputField("Temperature", temp, TextInputType.number),
      SizedBox(height: 10),
      InkWell(
        onTap: () async {
          if (temp.text.trim().isEmpty) {
            Get.snackbar('Incomplete', 'Kindly fill the fields');
          } else {
            Map<String, dynamic> data = {
              "patientId": patient.id,
              "time": Timestamp.now(),
              "nurseId": ProfileInfoServices
                  .profileInfoServicesInstance.userProfile.uid,
              "temp": temp.text.trim(),
            };
            await FirebaseFirestore.instance
                .collection("Temperature")
                .add(data)
                .then((value) {
              Get.back();
              Get.snackbar('Success', 'Record Saved');
            });
          }
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: purpleColor,
            borderRadius: BorderRadius.circular(15),
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
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    },
  );
}

showPulseDialogue(context, String tempText, Patient patient, String text) {
  TextEditingController temp = TextEditingController();

  temp.text = tempText;
  AlertDialog alertDialog = AlertDialog(
    title: Text('Pulse Rate'),
    content: Text('Patient: ${patient.name}'),
    actions: [
      smallInputField("Pulse Rate", temp, TextInputType.number),
      SizedBox(height: 10),
      InkWell(
        onTap: () async {
          if (temp.text.trim().isEmpty) {
            Get.snackbar('Incomplete', 'Kindly fill the fields');
          } else {
            Map<String, dynamic> data = {
              "patientId": patient.id,
              "time": Timestamp.now(),
              "nurseId": ProfileInfoServices
                  .profileInfoServicesInstance.userProfile.uid,
              "pulse": temp.text.trim(),
            };
            await FirebaseFirestore.instance
                .collection("Pulse")
                .add(data)
                .then((value) {
              Get.back();
              Get.snackbar('Success', 'Record Saved');
            });
          }
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: purpleColor,
            borderRadius: BorderRadius.circular(15),
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
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    },
  );
}

showWeightDialogue(context, String tempText, Patient patient, String text) {
  TextEditingController temp = TextEditingController();

  temp.text = tempText;
  AlertDialog alertDialog = AlertDialog(
    title: Text('Weight'),
    content: Text('Patient: ${patient.name}'),
    actions: [
      smallInputField("Weight", temp, TextInputType.number),
      SizedBox(height: 10),
      InkWell(
        onTap: () async {
          if (temp.text.trim().isEmpty) {
            Get.snackbar('Incomplete', 'Kindly fill the fields');
          } else {
            Map<String, dynamic> data = {
              "patientId": patient.id,
              "time": Timestamp.now(),
              "nurseId": ProfileInfoServices
                  .profileInfoServicesInstance.userProfile.uid,
              "weight": temp.text.trim(),
            };
            await FirebaseFirestore.instance
                .collection("Weight")
                .add(data)
                .then((value) {
              Get.back();
              Get.snackbar('Success', 'Record Saved');
            });
          }
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: purpleColor,
            borderRadius: BorderRadius.circular(15),
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
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    },
  );
}

showImageOptions(BuildContext context) async {
  return showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text('Select an Option'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 1); // 1 for camera
            },
            child: const Text('Camera'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 2); // 2 for gallery
            },
            child: const Text('Gallery'),
          ),
        ],
      );
    },
  );
}
