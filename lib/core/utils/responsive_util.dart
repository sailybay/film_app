import 'package:flutter/material.dart';

class ResponsiveUtil {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650 &&
      MediaQuery.of(context).size.width < 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  static int getCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) return 6;
    if (isTablet(context)) return 4;
    return 2;
  }

  static double getCardAspectRatio(BuildContext context) {
    if (isDesktop(context)) return 0.68;
    if (isTablet(context)) return 0.66;
    return 0.65;
  }

  static double getHorizontalPadding(BuildContext context) {
    if (isDesktop(context)) return 80;
    if (isTablet(context)) return 40;
    return 12;
  }

  static double getDetailImageHeight(BuildContext context) {
    if (isDesktop(context)) return 500;
    if (isTablet(context)) return 400;
    return 300;
  }
}
