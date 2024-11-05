import 'package:antic/commonWidgets/inputField.dart';
import 'package:antic/const/const.dart';
import 'package:antic/model/classes/patientInfoModel.dart';
import 'package:antic/model/services/patientServices.dart';
import 'package:antic/view/patients/addPatient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../commonWidgets/networkImage.dart';

class SelectPatient extends StatefulWidget {
  const SelectPatient({super.key});

  @override
  State<SelectPatient> createState() => _SelectPatientState();
}

class _SelectPatientState extends State<SelectPatient> {
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
              height: context.height * 0.75,
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: InkWell(
          onTap: () async {
            await Get.to(() => AddPatient(
                  patient: Patient(),
                  newPatient: true,
                  navigateToHome: false,
                ));
            setState(() {});
          },
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                color: purpleColor, borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: Text(
              'Add New Patient',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).scaffoldBackgroundColor),
            )),
          ),
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
          Get.back(result: patient);
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
                constraints: BoxConstraints(maxWidth: context.width * 0.5),
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
            ],
          ),
        ),
      ),
    );
  }
}
