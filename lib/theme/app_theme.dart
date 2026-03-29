import "package:flutter/material.dart";

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: "PT Sans",
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
  );
}
