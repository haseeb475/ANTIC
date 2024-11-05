import 'package:antic/const/const.dart';
import 'package:antic/model/classes/patientInfoModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  final Patient patient;
  const History({super.key, required this.patient});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List userData = [];

  var dataProcessed = false.obs;
  final formatter = DateFormat('HH:mm dd/MM/yyyy');
  getRecord(String collection) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where('patientId', isEqualTo: widget.patient.id)
        .get();

    return snapshot.docs;
  }

  getHistory() async {
    List allData = [];
    // get Weight data
    var dataWeight = await getRecord('Weight');
    for (var data in dataWeight) {
      data = data.data();
      Map<String, dynamic> instance = {
        'type': 'Weight',
        'weight': data['weight'],
        'time': data['time'],
      };
      allData.add(instance);
    }

    // get BP
    var dataBP = await getRecord('BP');
    for (var data in dataBP) {
      data = data.data();
      Map<String, dynamic> instance = {
        'type': 'Blood Pressure',
        'Upper': data['upper'],
        'Lower': data['lower'],
        'Pulse Rate': data['pulseRate'],
        'time': data['time'],
      };
      allData.add(instance);
    }

    // // get pulse rate
    // var dataPulse = await getRecord('Pulse');
    // for (var data in dataPulse) {
    //   data = data.data();
    //   Map<String, dynamic> instance = {
    //     'type': 'Pulse',
    //     'Pulse': data['pulse'],
    //     'time': data['time'],
    //   };
    //   allData.add(instance);
    // }

    // get temp
    var dataTemp = await getRecord('Temperature');
    for (var data in dataTemp) {
      data = data.data();
      Map<String, dynamic> instance = {
        'type': 'Temperature',
        'Temperature': data['temp'],
        'time': data['time'],
      };
      allData.add(instance);
    }

    // oxi
    var dataOxi = await getRecord('Oxi');
    for (var data in dataOxi) {
      data = data.data();
      Map<String, dynamic> instance = {
        'type': 'Oxi',
        'SpO2': data['spo2'],
        'Pulse Rate': data['pulseRate'],
        'time': data['time'],
      };
      allData.add(instance);
    }

    allData.sort((a, b) {
      final Timestamp timestampA = a['time'];
      final Timestamp timestampB = b['time'];

      // Convert timestamps to DateTime objects.
      DateTime dateTimeA = timestampA.toDate();
      DateTime dateTimeB = timestampB.toDate();

      return dateTimeB.compareTo(dateTimeA); // Descending order.
    });

    userData = allData;
    dataProcessed(true);
  }

  @override
  void initState() {
    // TODO: implement initState
    getHistory();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${widget.patient.name.split(' ')[0]}'s History"),
      ),
      body: Obx(
        () => ListView(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          physics: BouncingScrollPhysics(),
          children: [
            if (dataProcessed.value)
              Column(children: [
                Divider(
                  color: purpleColor,
                ),
                Text(
                  'Total Records ${userData.length}',
                  style: GoogleFonts.poppins(fontSize: 16, color: purpleColor),
                ),
                Divider(
                  color: purpleColor,
                ),
                for (int i = 0; i < userData.length; i++)
                  Column(
                    children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Row(
                            children: [
                              // meta data
                              Container(
                                width: context.width * 0.4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.settings,
                                          color: purpleColor,
                                          size: 18,
                                        ),
                                        Text(
                                          ' ${userData[i]['type']}',
                                          style: GoogleFonts.poppins(),
                                        )
                                      ],
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          CupertinoIcons.time,
                                          color: purpleColor,
                                          size: 18,
                                        ),
                                        Text(
                                          ' ${formatter.format(userData[i]["time"].toDate())}',
                                          style: GoogleFonts.poppins(),
                                        )
                                      ],
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),

                              // data
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KeyValueList(userData[
                                      i]), // Add KeyValueList widget here
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5)
                    ],
                  ),
              ]),
            if (!dataProcessed.value)
              Column(
                children: [
                  SizedBox(
                    height: context.height * 0.4,
                  ),
                  Center(child: CupertinoActivityIndicator())
                ],
              )
          ],
        ),
      ),
    );
  }
}

class KeyValueList extends StatelessWidget {
  final Map<String, dynamic> dataMap;

  KeyValueList(this.dataMap);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: dataMap.entries
          .where((entry) => entry.key != 'time' && entry.key != 'type')
          .map((entry) => Text(
                '${entry.key}: ${entry.value}',
                style: GoogleFonts.poppins(fontSize: 18),
              ))
          .toList(),
    );
  }
}
