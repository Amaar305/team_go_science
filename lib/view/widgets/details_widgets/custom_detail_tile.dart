import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class CustomDetailTile extends StatelessWidget {
  const CustomDetailTile({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: descriptionTextStyle,
    );
  }
}
