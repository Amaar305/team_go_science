import 'package:blue_book/shimmers/home_skeleton.dart';
import 'package:blue_book/view/utils/constants.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static String routeName = "/splash-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GridView(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          padding: kDefaultAppPadding,
          children: [
            HomeSkeleton(
              width: 120,
              height: 120,
            ),
            HomeSkeleton(
              width: 120,
              height: 120,
            ),
            HomeSkeleton(
              width: 120,
              height: 120,
            ),
            HomeSkeleton(
              width: 120,
              height: 120,
            ),
            HomeSkeleton(
              width: 120,
              height: 120,
            ),
            HomeSkeleton(
              width: 120,
              height: 120,
            ),
            HomeSkeleton(
              width: 120,
              height: 120,
            ),
            HomeSkeleton(
              width: 120,
              height: 120,
            ),
            HomeSkeleton(
              width: 120,
              height: 120,
            ),
            HomeSkeleton(
              width: 120,
              height: 120,
            ),
          ],
        ),
      ),
    );
  }
}
