import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static TextTheme get _textTheme => GoogleFonts.urbanistTextTheme();

  static final ThemeData theme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
    textTheme: _textTheme,
  ).copyWith(
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.blue,
      actionTextColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: _textTheme.labelLarge?.copyWith(color: AppColors.mutedAzure),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.blue10),
        side: WidgetStateProperty.all(BorderSide.none),
        textStyle: WidgetStateProperty.all(_textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
        foregroundColor: WidgetStatePropertyAll(AppColors.blue),
        iconColor: WidgetStatePropertyAll(AppColors.blue),
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
    dialogTheme: DialogThemeData(backgroundColor: Colors.white),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(foregroundColor: WidgetStateProperty.all(AppColors.blue)),
    ),
  );
}
