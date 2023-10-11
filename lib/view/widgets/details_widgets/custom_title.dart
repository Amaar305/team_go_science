import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: titleTextStyle,
    );
  }
}
