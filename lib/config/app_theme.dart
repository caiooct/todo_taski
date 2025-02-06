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
  );
}
