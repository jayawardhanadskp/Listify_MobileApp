import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppFonts {
  static TextStyle titleFont = GoogleFonts.openSans(fontSize: 30, color: Colors.white);
  static TextStyle normal = GoogleFonts.poppins(
    fontSize: 20,
  );
  static TextStyle bodyText1white = GoogleFonts.poppins(
      fontSize: 16, color: const Color.fromRGBO(255, 255, 255, 1));
  static TextStyle bodyText1pink =
      GoogleFonts.poppins(fontSize: 16, color: AppColors.yellow);
}
