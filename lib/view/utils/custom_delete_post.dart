import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants.dart';

Future<dynamic> CustomAlertDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Warning!", style: titleTextStyle),
      content: Text(
        'Are you sure you want to delete this post?! if you delete it you may not undo it.',
        style: descriptionTextStyle,
        maxLines: 2,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                'Cancle',
                style: descriptionTextStyle.copyWith(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: Text(
                'Delete',
                style: descriptionTextStyle.copyWith(color: Colors.black),
              ),
            ),
          ],
        )
      ],
    ),
  );
}
