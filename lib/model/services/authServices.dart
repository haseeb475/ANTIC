import 'package:antic/model/services/profileInfoServices.dart';
import 'package:antic/view/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../const/firebaseConst.dart';
import '../../view/home.dart';
import '../../view/signIn.dart';

class AuthServices extends GetxController {
  static AuthServices authInstance = Get.find();
  late Rx<User?> firebaseUser;
  var loading = false.obs;
  var em;
  String? userEmail;
  late User cuser;
  var name;

  @override
  void onReady() async {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    var user = auth.currentUser;
    firebaseUser.bindStream(auth.userChanges());

    checkUser(user);
    // ever(firebaseUser, _setInitialScreen);
  }

  checkUser(User? user) async {
    if (user != null) {
      userEmail = user?.email;
      cuser = user;
      await ProfileInfoServices.profileInfoServicesInstance
          .getUserProfileFromFireStore();
      if (ProfileInfoServices.profileInfoServicesInstance.userProfile.status ==
          0) {
        await Get.offAll(
            () => Navigation(
                  index: 0,
                ),
            transition: Transition.fadeIn);
      } else {
        Get.snackbar('Deactivated', 'Your Account is deactivated by the Admin');
        signOut();
      }
    } else {
      // user is null as in user is not available or not logged in
      Get.offAll(() => SignIn(), transition: Transition.leftToRight);
    }
  }

  _setInitialScreen(User? user) async {}

  // Future<bool> updateEachPass(newPass) async {
  //   bool retVal = false;
  //
  //   await FirebaseFirestore.instance
  //       .collection('Passwords')
  //       .where('email', isEqualTo: cuser.email)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) async {
  //       await FirebaseFirestore.instance
  //           .collection("Passwords")
  //           .doc(doc.id)
  //           .update({
  //         'password': passCon.encryptPassWith(
  //             passCon.decryptPass(doc['password']), newPass)
  //       }).then((value) {});
  //
  //       // name = doc['name'];
  //     });
  //   });
  //
  //   return retVal;
  // }
  //
  Future<bool> updateUserPass(newPass) async {
    bool retVal = false;

    DocumentReference ref =
        FirebaseFirestore.instance.collection("Users").doc(cuser.uid);
    Map<String, String> data = {
      "password": newPass,
    };

    await ref.update(data).then(
      (value) {
        retVal = true;
      },
    );

    return retVal;
  }

  Future<bool> updatePass(newPassword, String oldPass) async {
    bool retVal = false;

    var credential =
        EmailAuthProvider.credential(email: cuser.email!, password: oldPass);

    try {
      await cuser.reauthenticateWithCredential(credential).then(
        (value) async {
          try {
            await cuser.updatePassword(newPassword).then(
              (value) {
                retVal = true;
                Get.back();
              },
            );
          } catch (e) {
            Get.snackbar(
              "Error",
              "Password Couldn't be updated",
              snackPosition: SnackPosition.TOP,
            );
            print(e);
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
      Get.snackbar(
        "Error",
        e.message!,
        snackPosition: SnackPosition.TOP,
      );
    }

    return retVal;
  }

  Future<void> signup(
      String email, String password, String name, String role) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (value) {
          DocumentReference ref = FirebaseFirestore.instance
              .collection("Users")
              .doc(auth.currentUser!.uid);
          Map<String, String> data = {
            "name": name,
            "email": email,
            "imageurl": "",
            "password": password,
            "role": role,
            "id": auth.currentUser!.uid
          };

          ref.set(data).then(
            (value) async {
              List x = [];
              DocumentReference ref = FirebaseFirestore.instance
                  .collection("Wishlist")
                  .doc(auth.currentUser!.uid);
              Map<String, dynamic> data = {
                "ids": x,
                "uid": auth.currentUser!.uid
              };
              ref.set(data).then(
                (value) {
                  List x = [];
                  DocumentReference ref = FirebaseFirestore.instance
                      .collection("Cart")
                      .doc(auth.currentUser!.uid);
                  Map<String, dynamic> data = {
                    "product": x,
                    "id": auth.currentUser!.uid
                  };

                  ref.set(data).then(
                    (value) {
                      var user = auth.currentUser;
                      checkUser(user);
                    },
                  );
                },
              );
            },
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
      Get.snackbar(
        "Error",
        e.message!,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      // this is temporary. you can handle different kinds of activities
      //such as dialogue to indicate what's wrong
      print(e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      bool found = true;
      // await FirebaseFirestore.instance
      //     .collection('Users')
      //     .where('email', isEqualTo: email)
      //     .get()
      //     .then(
      //   (QuerySnapshot querySnapshot) {
      //     querySnapshot.docs.forEach(
      //       (doc) {
      //         found = true;
      //       },
      //     );
      //   },
      // );

      if (found) {
        await auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then(
          (value) async {
            var user = auth.currentUser;

            checkUser(user);
          },
        );
      } else {
        Get.snackbar(
          "Error",
          "Not a User",
          snackPosition: SnackPosition.TOP,
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error",
        e.message!,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void signOut() async {
    try {
      await auth.signOut().then((value) {
        var user = auth.currentUser;

        checkUser(user);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  String? getEmail() {
    return userEmail;
  }
}
