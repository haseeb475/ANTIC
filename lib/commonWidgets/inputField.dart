import 'package:antic/controller/authController/obsController.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextFormField inputField(var label, var hint, var controller, var icon,
    var obscure, var keyboardType,
    [PassHide? passHide]) {
  return TextFormField(
    onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
    obscureText: obscure,
    controller: controller,
    keyboardType: keyboardType,
    textCapitalization: TextCapitalization.sentences,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey.withOpacity(0.3),
      labelStyle: GoogleFonts.poppins(fontSize: 16),
      labelText: label,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey),
        gapPadding: 10,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.transparent),
        gapPadding: 10,
      ),
      suffixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: IconButton(
          icon: Icon(
            icon,
          ),
          onPressed: () {
            if (passHide != null) {
              passHide?.hide(!passHide.hide.value);
            }
          },
        ),
      ),
    ),
  );
}

TextFormField smallInputField(var label, var controller, var keyboardType) {
  return TextFormField(
    onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
    controller: controller,
    keyboardType: keyboardType,
    textCapitalization: TextCapitalization.sentences,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey.withOpacity(0.3),
      labelStyle: GoogleFonts.poppins(fontSize: 16),
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey),
        gapPadding: 10,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.transparent),
        gapPadding: 10,
      ),
    ),
  );
}

TextFormField paraInputField(
    var label, var controller, var keyboardType, var max) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    maxLines: max,
    textCapitalization: TextCapitalization.sentences,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey.withOpacity(0.3),
      labelStyle: GoogleFonts.poppins(fontSize: 16),
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.transparent),
        gapPadding: 10,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.transparent),
        gapPadding: 10,
      ),
    ),
  );
}
