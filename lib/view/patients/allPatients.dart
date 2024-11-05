import 'package:antic/commonWidgets/inputField.dart';
import 'package:antic/model/classes/patientInfoModel.dart';
import 'package:antic/model/services/patientServices.dart';
import 'package:antic/view/patients/addPatient.dart';
import 'package:antic/view/patients/history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../commonWidgets/networkImage.dart';

class AllPatients extends StatefulWidget {
  const AllPatients({super.key});

  @override
  State<AllPatients> createState() => _AllPatientsState();
}

class _AllPatientsState extends State<AllPatients> {
  TextEditingController search = TextEditingController();
  var searchText = "".obs;

  void _onSearchTextChanged() {
    searchText.value = search.text.toLowerCase();
  }

  @override
  void initState() {
    // TODO: implement initState
    search.text = "";
    search.addListener(_onSearchTextChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            SizedBox(height: 5),
            inputField("Search", 'Search Patients', search,
                CupertinoIcons.search, false, TextInputType.text),
            Container(
              height: context.height * 0.65,
              child: Obx(
                () => FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('Patients')
                      .where('lowerName',
                          isGreaterThanOrEqualTo: searchText.value.trim())
                      .where('lowerName',
                          isLessThan: searchText.value.trim() + 'z')
                      .get(),
                  builder: (context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Column(
                        children: [
                          Center(
                            child: CupertinoActivityIndicator(),
                          )
                        ],
                      );
                    } else if (snapshot.data!.docs.length < 1) {
                      return Center(child: Text('No Patients Found'));
                    } else if (snapshot.hasData) {
                      var data = snapshot.data!.docs;

                      return ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          // SizedBox(height: 5),
                          // Center(
                          //   child: Text(
                          //     'All Patients | ${data.length}',
                          //     overflow: TextOverflow.ellipsis,
                          //     style: GoogleFonts.poppins(
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.w600,
                          //       color: Theme.of(context).primaryColor,
                          //     ),
                          //   ),
                          // ),
                          for (var client in data!)
                            Column(
                              children: [
                                SizedBox(height: 10),
                                buildPatient(context, client),
                              ],
                            ),
                        ],
                      );
                    } else {
                      return const Text('An Error Occurred');
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Material buildPatient(BuildContext context, client) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          Patient patient = Patient();
          patient.name = client['name'];
          patient.age = client['age'];
          patient.id = client['id'];
          patient.bloodType = client['bloodType'];

          Get.to(() => History(
                patient: patient,
              ));
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          alignment: Alignment.center,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.person),
                  )),
              SizedBox(width: 10),
              Container(
                constraints: BoxConstraints(maxWidth: context.width * 0.4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: '${client['name']}',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          // softWrap: false,
                          '${client['name']}',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      constraints:
                          BoxConstraints(maxWidth: context.width * 0.5),
                      child: Material(
                        type: MaterialType.transparency,
                        child: Row(
                          children: [
                            Text(
                              ' Age: ${client['age']}',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bloodtype,
                          size: 15,
                        ),
                        SizedBox(width: 5),
                        Container(
                          constraints:
                              BoxConstraints(maxWidth: context.width * 0.4),
                          child: Text(
                            '${client['bloodType']}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  Patient patient = Patient();
                  patient.name = client['name'];
                  patient.age = client['age'];
                  patient.id = client['id'];
                  patient.bloodType = client['bloodType'];

                  Get.to(
                      () => AddPatient(
                            patient: patient,
                            newPatient: false,
                            navigateToHome: true,
                          ),
                      transition: Transition.rightToLeft);
                },
                icon: Icon(CupertinoIcons.pen),
                padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Delete Confirmation"),
                        content: Text("Do you want to delete this Patient?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          ),
                          TextButton(
                            child: Text("Confirm"),
                            onPressed: () async {
                              await PatientServices()
                                  .deletePatient(client['id']);
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(CupertinoIcons.delete),
                padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
