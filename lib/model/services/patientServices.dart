import 'package:antic/model/classes/patientInfoModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PatientServices {
  getPatient(String id) async {
    Patient patient = Patient();

    await FirebaseFirestore.instance
        .collection('Patients')
        .where('id', isEqualTo: id)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach(
          (doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            patient.fromMap(data);
          },
        );
      },
    );

    return patient;
  }

  Future<bool> savePatientProfile(Patient patient, create) async {
    bool success = false;
    DocumentReference ref =
        FirebaseFirestore.instance.collection("Patients").doc(patient.id);
    Map<String, dynamic> data = patient.toMap();
    data['lowerName'] = patient.name.toLowerCase();

    if (create) {
      await ref.set(data).then(
        (value) {
          success = true;
        },
      );
    } else {
      await ref.update(data).then(
        (value) {
          success = true;
        },
      );
    }
    return success;
  }

  savePatient(Patient patient, newPatient) async {
    bool success = false;
    bool allowCreation = false;
    Patient databasePatient = Patient();

    if (newPatient) {
      databasePatient = await getPatient(patient.id);
    }

    // for new patients only
    if (newPatient) {
      if (databasePatient.id != "") {
        Get.snackbar('Error', 'Patient id exists for ${databasePatient.name}');
      } else {
        allowCreation = true;
      }
    }

    // for updating only
    if (!newPatient) {
      allowCreation = true;
    }

    if (allowCreation) {
      success = await savePatientProfile(patient, newPatient);
    }
    return success;
  }

  deletePatient(String id) async {
    bool success = false;
    DocumentReference ref =
        FirebaseFirestore.instance.collection("Patients").doc(id);

    ref.delete().then((value) => {success = true});

    return success;
  }
}
