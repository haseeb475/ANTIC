import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

import '../classes/userInfoModel.dart';
import 'authServices.dart';

class ProfileInfoServices extends GetxController {
  static ProfileInfoServices profileInfoServicesInstance = Get.find();

  UserProfile userProfile = UserProfile();

  UserProfile getUserProfile() {
    return userProfile;
  }

  Future<UserProfile> getUserProfileFromFireStore() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: AuthServices.authInstance.cuser.email)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach(
          (doc) {
            var tokenData = doc.data() as Map;
            userProfile.name = doc['name'];
            userProfile.email = doc['email'];
            userProfile.imageUrl = doc['imageurl'];
            userProfile.role = doc['role'];
            userProfile.uid = doc['id'];
            if (tokenData.containsKey('status')) {
              userProfile.status = tokenData['status'];
            } else {
              userProfile.status = 0;
            }
          },
        );
      },
    );

    return userProfile;
  }

  uploadProfilePic(String url) async {
    var fileName = basename(url);
    var des =
        'images/profilePics/${AuthServices.authInstance.cuser.uid}/$fileName';
    Reference ref = FirebaseStorage.instance.ref().child(des);
    await ref.putFile(File(url));
    String profileLink = await ref.getDownloadURL();
    return profileLink;
  }

  Future<UserProfile> getUser(String id) async {
    UserProfile userProfile = UserProfile();

    await FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: id)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach(
          (doc) {
            userProfile.name = doc['name'];
            userProfile.email = doc['email'];
            userProfile.imageUrl = doc['imageurl'];
            userProfile.role = doc['role'];
            userProfile.uid = doc['id'];
          },
        );
      },
    );

    return userProfile;
  }

  static register(String email, String password) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error",
        e.message!,
        snackPosition: SnackPosition.TOP,
      );

      return false;
      // Do something with exception. This try/catch is here to make sure
      // that even if the user creation fails, app.delete() runs, if is not,
      // next time Firebase.initializeApp() will fail as the previous one was
      // not deleted.
    }

    await app.delete();
    return true;
  }

  saveUser(UserProfile user, String pass) async {
    UserProfile databaseUser = await getUser(user.uid);
    if (databaseUser.uid != "") {
      Get.snackbar(
          'Error', "Work Id already exists for the user ${databaseUser.email}");
      return false;
    }
    try {
      bool val = await register(user.email, pass);
      if (val) {
        await saveUserProfile(user, true);
      }
      return val;
      // await FirebaseAuth.instance
      //     .createUserWithEmailAndPassword(email: user.email, password: pass)
      //     .then((value) {
      // });
    } on FirebaseAuthException catch (e) {
      print(e.message);
      Get.snackbar(
        "Error",
        e.message!,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    return false;
  }

  Future<bool> saveUserProfile(UserProfile userProfile,
      [bool create = false]) async {
    bool success = false;
    DocumentReference ref =
        FirebaseFirestore.instance.collection("Users").doc(userProfile.uid);
    Map<String, dynamic> data = userProfile.toMap();

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
}
