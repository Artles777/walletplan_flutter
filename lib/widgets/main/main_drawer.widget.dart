import "package:flutter/material.dart";

class MainDrawerWidget extends StatelessWidget {
  const MainDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: Colors.white10,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white10),
        child: Text("fff"),
      ),
    );
  }
}
