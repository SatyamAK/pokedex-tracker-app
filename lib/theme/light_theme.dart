import 'package:flutter/material.dart';
import 'package:pokedex_tracker/constants/color.dart';

ThemeData lightTheme(BuildContext context) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor
    ),
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: Theme.of(context).colorScheme.error,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        color: appBarTextColor,
      ),
      iconTheme: const IconThemeData(
        color: appBarTextColor
      ),
      elevation: 0
    ),
    tabBarTheme: const TabBarTheme(
      unselectedLabelColor: unselectedTabColor,
      labelColor: appBarTextColor,
      indicatorColor: appBarTextColor
    ),
    listTileTheme: const ListTileThemeData(
      titleTextStyle: TextStyle(
        color: displayTextColor,
        fontSize: 16,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 1,
      shadowColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)), 
        side: BorderSide(width: 0.5)
      )
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontSize: 16
      ),
      bodySmall: TextStyle(
        fontSize: 14
      ),
      titleMedium: TextStyle(
        fontSize: 12
      )
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.error),
        iconColor: const MaterialStatePropertyAll(appBarTextColor)
      )
    )
  );
}