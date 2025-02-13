import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../ui/app_widget.dart';

abstract final class ShowSnackBarHelper {
  static void showSuccessSnackBar(String text, {SnackBarAction? action}) {
    if (scaffoldKey.currentState == null) return;
    scaffoldKey.currentState!.removeCurrentSnackBar();
    scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          text,
          style: TextTheme.of(scaffoldKey.currentState!.context).bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 40),
        duration: const Duration(seconds: 2),
        action: action,
      ),
    );
  }

  static void showErrorSnackBar(String text) {
    if (scaffoldKey.currentState == null) return;
    scaffoldKey.currentState!.removeCurrentSnackBar();
    scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        backgroundColor: AppColors.fireRed,
        behavior: SnackBarBehavior.floating,
        content: Text(
          text,
          style: TextTheme.of(scaffoldKey.currentState!.context).bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 40),
        showCloseIcon: true,
      ),
    );
  }
}
