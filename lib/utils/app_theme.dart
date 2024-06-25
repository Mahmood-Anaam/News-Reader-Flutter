
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color orangeWeb = Color(0xFFf59400);
  static const Color white = Color(0xFFf5f5f5);
  static const Color lightGrey = Color(0xFFd2d7df);
  static const Color primaryColor = Color(0xFF880d1e);
  static const Color blue = Colors.blue;
}


class Themes {
  static final appTheme = ThemeData.light().copyWith(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.lightGrey,
    buttonTheme: const ButtonThemeData(buttonColor: AppColors.orangeWeb),
    appBarTheme: ThemeData.light().appBarTheme.copyWith(
      backgroundColor: AppColors.primaryColor,
      elevation: 3.0,
      centerTitle: true,
      foregroundColor: AppColors.white,
      iconTheme: const IconThemeData(color: AppColors.white),
      titleTextStyle: ThemeData.light().appBarTheme.titleTextStyle?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),

    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.orangeWeb),

  );
}
