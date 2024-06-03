
import 'package:flutter/material.dart';

const typeTheme = Typography.whiteMountainView;

class ThemeProvider {
  static Color buttonfirstClr = Color(0xFFA154FF);
  static Color buttonSecondClr = Color(0xFFFF3062);
  static Color buttonThirdClr = Color(0xFFFF6230);
  static Color background_first_Clr = Color(0xFF301EFF);
  static Color background_second_Clr = Color(0xFF3EF3FF);
  static Color buttonColors = Color(0xFF6161FF);
  static Color text_background = Color(0xFF22242B);
  static Color text_light_gray= Color(0xFFA7A9B1);
  static Color text_color = Color(0xFF616161);
  static Color bold_text_color = Color(0xFF2E3456);
  static Color secondary = Color(0xFF094268);
  static Color buttonborderColors = Color(0xFF8146FF);
  static Color primary = Color(0xFF8146FF);
  static Color loader_color = Color(0xFFFFFFFF);
  static Color light_primary = Color(0xFFD2BFFF);
  static const appColor = Color(0xFF8146FF);
  static const secondaryAppColor = Color(0xFF8146FF);
  static const whiteColor = Colors.white;
  static const blackColor = Color(0xFF000000);
  static const greyColor = Color(0xFF4D4F5D);
  static const backgroundColor = Color(0xFFF3F3F3);
  static const match_background_light = Color(0xFF1D1B62);
  static const match_background = Color(0xFF1D1C44);
  static const match_background_dark = Color(0xFF03031F);
  static const orangeColor = Color(0xFFFF9900);
  static const greenColor = Color(0xFF32CD32);
  static const redColor = Color(0xFFFF0000);
  static const buttonColor = Color(0xFF22242B);
  static const iconColor = Color(0xFF4D4F5D);
  static const dividerColor = Color(0xFF2F323F);
  static const matchButtonColor = Color(0xFF8146FF);
  static const chatTimeTextColor = Color(0xFF535353);
  static const transparent = Color.fromARGB(0, 0, 0, 0);
  static const titleStyle = TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.whiteColor);
}

TextTheme txtTheme = Typography.whiteMountainView.copyWith(
  bodyLarge: typeTheme.bodyLarge?.copyWith(fontSize: 16),
  bodyMedium: typeTheme.bodyLarge?.copyWith(fontSize: 14),
  displayLarge: typeTheme.bodyLarge?.copyWith(fontSize: 32),
  displayMedium: typeTheme.bodyLarge?.copyWith(fontSize: 28),
  displaySmall: typeTheme.bodyLarge?.copyWith(fontSize: 24),
  headlineMedium: typeTheme.bodyLarge?.copyWith(fontSize: 21),
  headlineSmall: typeTheme.bodyLarge?.copyWith(fontSize: 18),
  titleLarge: typeTheme.bodyLarge?.copyWith(fontSize: 16),
  titleMedium: typeTheme.bodyLarge?.copyWith(fontSize: 24),
  titleSmall: typeTheme.bodyLarge?.copyWith(fontSize: 21),
);

ThemeData light = ThemeData(fontFamily: 'regular', primaryColor: ThemeProvider.appColor, secondaryHeaderColor: ThemeProvider.secondaryAppColor, disabledColor: const Color(0xFFBABFC4), brightness: Brightness.light, hintColor: const Color(0xFF9F9F9F), cardColor: ThemeProvider.appColor, textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: ThemeProvider.appColor)), textTheme: txtTheme, colorScheme: const ColorScheme.light(primary: ThemeProvider.appColor, secondary: ThemeProvider.secondaryAppColor).copyWith(background: const Color(0xFFF3F3F3)).copyWith(error: const Color(0xFFE84D4F)));

ThemeData dark = ThemeData(fontFamily: 'regular', primaryColor: ThemeProvider.blackColor, secondaryHeaderColor: const Color(0xFF009f67), disabledColor: const Color(0xffa2a7ad), brightness: Brightness.dark, hintColor: const Color(0xFFbebebe), cardColor: Colors.black, textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: ThemeProvider.blackColor)), textTheme: txtTheme, colorScheme: const ColorScheme.dark(primary: ThemeProvider.blackColor, secondary: Color(0xFFffbd5c)).copyWith(background: const Color(0xFF343636)).copyWith(error: const Color(0xFFdd3135)));
