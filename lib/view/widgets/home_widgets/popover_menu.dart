import 'package:flutter/material.dart';

class PopOverMenuItems extends StatelessWidget {
  const PopOverMenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1st menu option
        Container(
          height: 50,
          color: Colors.deepPurple[300],
        ),

        // 2nd menu option
        Container(
          height: 50,
          color: Colors.deepPurple[200],
          child: Text("data"),
        ),

        // 3rd menu option
        Container(
          height: 50,
          color: Colors.deepPurple[100],
        ),
      ],
    );
  }
}
