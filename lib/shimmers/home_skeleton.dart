import 'package:flutter/material.dart';

import '../view/utils/constants.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key, this.height, this.width});
  final double? height, width;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kPrimary.withOpacity(0.20),
      ),
    );
  }
}
