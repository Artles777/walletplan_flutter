import "package:flutter/material.dart";

class TransactionsDaySectionDividerWidget extends StatelessWidget {
  const TransactionsDaySectionDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.7,
      indent: 16,
      endIndent: 16,
      color: Colors.indigo.withValues(alpha: 0.09),
    );
  }
}
