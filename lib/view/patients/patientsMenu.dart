import 'package:antic/const/const.dart';
import 'package:antic/model/classes/patientInfoModel.dart';
import 'package:antic/view/patients/addPatient.dart';
import 'package:antic/view/patients/allPatients.dart';
import 'package:antic/view/signIn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/classes/userInfoModel.dart';

class PatientsMenu extends StatefulWidget {
  const PatientsMenu({super.key});

  @override
  State<PatientsMenu> createState() => _PatientsMenuState();
}

class _PatientsMenuState extends State<PatientsMenu>
    with TickerProviderStateMixin {
  late TabController tabCont;

  @override
  void initState() {
    tabCont = TabController(length: 2, vsync: this);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Patients"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: context.height * 0.05,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                padding: EdgeInsets.all(5),
                child: TabBar(
                  controller: tabCont,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: purpleColor),
                  labelColor: Colors.white,
                  unselectedLabelColor:
                      Theme.of(context).scaffoldBackgroundColor,
                  tabs: const [
                    Tab(
                      text: "All",
                    ),
                    Tab(
                      text: "Add",
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: tabCont,
        children: [
          AllPatients(),
          AddPatient(
            patient: Patient(),
            newPatient: true,
            navigateToHome: true,
          ),
        ],
      ),
    );
  }
}
