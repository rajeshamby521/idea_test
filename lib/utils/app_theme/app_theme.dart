import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  Brightness brightness = Brightness.light;
  ColorScheme cs = ColorScheme.fromSeed(
      seedColor: const Color(0xFFF8EBD8), brightness: Brightness.light);

  ThemeData darkThemeData(BuildContext context) {
    return brightness == Brightness.dark
        ? ThemeData.dark().copyWith(
            useMaterial3: false,
            scaffoldBackgroundColor: cs.background,
            colorScheme: cs,
          )
        : lightThemeData(context);
  }

  ThemeData lightThemeData(BuildContext context) {
    return ThemeData.light().copyWith(
      useMaterial3: false,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStateProperty.all<TextStyle>(
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            side: MaterialStateProperty.all<BorderSide>(
                BorderSide(color: cs.primary)),
            textStyle: MaterialStateProperty.all<TextStyle>(
                const TextStyle(fontSize: 22, fontWeight: FontWeight.w400))),
      ),
      textTheme: GoogleFonts.dmSansTextTheme(Theme.of(context).textTheme)
          .copyWith(

              ///normal text style and bold
              headlineSmall:
                  const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),

              ///like subtitle and bold
              displaySmall:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
              displayMedium:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              displayLarge:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
      primaryTextTheme: GoogleFonts.dmSansTextTheme(Theme.of(context).textTheme)
          .copyWith(
              headlineSmall: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black),
              displayMedium: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.black),

              headlineMedium: const TextStyle(color: Colors.white),displayLarge:
      const TextStyle(fontSize: 28, fontWeight: FontWeight.w500,color: Colors.black)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xFF1D1D1F),
          unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: const Color(0xFFCCCCCC).withOpacity(0.5)),
          showSelectedLabels: false,
          showUnselectedLabels: false),
      colorScheme: cs,
    );
  }
}
