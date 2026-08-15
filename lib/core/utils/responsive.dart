import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// Utility untuk menentukan tipe layar.
///
/// Digunakan agar UI tidak memaksakan layout mobile
/// ketika aplikasi dijalankan pada Web atau Windows.
class Responsive {
  Responsive._();

  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < AppConstants.mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return width >= AppConstants.mobileBreakpoint &&
        width < AppConstants.desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= AppConstants.desktopBreakpoint;
  }

  static double contentWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= AppConstants.desktopBreakpoint) {
      return 1200;
    }

    if (width >= AppConstants.tabletBreakpoint) {
      return 1000;
    }

    return width;
  }
}
