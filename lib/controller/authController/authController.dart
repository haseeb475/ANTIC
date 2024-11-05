import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../model/services/authServices.dart';

class AuthController {
  Future<void> SignInController(String email, String password) async {
    email = email.toLowerCase();
    if (email.length < 3) {
      Get.snackbar(
        "Email Error",
        "Please enter correct Email",
        snackPosition: SnackPosition.TOP,
      );
    } else if (password.length < 6) {
      Get.snackbar(
        "Password Error",
        "Please enter correct Password",
        snackPosition: SnackPosition.TOP,
      );
    } else {
      await AuthServices.authInstance.login(email, password);
    }
  }

  Future<void> updatePassController(
      String oldPass, String NewPass1, String NewPass2) async {
    if (oldPass.length < 6) {
      Get.snackbar(
        "Current Password Error",
        "Please enter correct Password",
        snackPosition: SnackPosition.TOP,
      );
    } else if (NewPass1.length < 6) {
      Get.snackbar(
        "New Password Error",
        "Please enter a Password of at least 6 Characters",
        snackPosition: SnackPosition.TOP,
      );
    } else if (NewPass2.length < 6) {
      Get.snackbar(
        "New Password Error",
        "Please enter a Password of at least 6 Characters",
        snackPosition: SnackPosition.TOP,
      );
    } else if (NewPass1 != NewPass2) {
      Get.snackbar(
        "Passwords Do not Match",
        "New Passwords Do not Match",
        snackPosition: SnackPosition.TOP,
      );
    } else {
      bool success =
          await AuthServices.authInstance.updatePass(NewPass1, oldPass);
      if (success) {
        Get.snackbar(
          "Success",
          "Password Updated",
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }

  Future<void> SignUpController(
      String email, String password, String contact, String name) async {
    email = email.toLowerCase();
    if (name.length < 2) {
      Get.snackbar(
        "Name Error",
        "Please enter a Proper Name",
        snackPosition: SnackPosition.TOP,
      );
    } else if (email.length < 3) {
      Get.snackbar(
        "Email Error",
        "Please enter correct Email",
        snackPosition: SnackPosition.TOP,
      );
    } else if (contact.length != 13) {
      Get.snackbar(
        "Incorrect Contact",
        "Please enter a Proper Contact",
        snackPosition: SnackPosition.TOP,
      );
    } else if (password.length < 6) {
      Get.snackbar(
        "Password too Short",
        "Please enter a Password with at least 6 characters",
        snackPosition: SnackPosition.TOP,
      );
    } else {
      await AuthServices.authInstance.signup(email, password, name, contact);
    }
  }
}
