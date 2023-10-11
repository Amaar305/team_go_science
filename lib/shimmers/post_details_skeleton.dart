import 'package:flutter/material.dart';

import '../view/utils/constants.dart';
import 'home_skeleton.dart';

class PostDetailsSkeleton extends StatelessWidget {
  const PostDetailsSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: kDefaultAppPadding,
      children: [
        buildHeader(),
        const SizedBox(height: 20),
        buildPostAction(),
        const SizedBox(height: 10),
        buildPostInfo(),
        const SizedBox(height: 20),
        buildDetailTitle(),
        const SizedBox(height: 20),
        buildDetailTitle(),
        const SizedBox(height: 20),
        buildDetailTitle(),
        const SizedBox(height: 20),
        buildDetailDesc(),
      ],
    );
  }
}

Widget buildHeader() {
  return AspectRatio(
    aspectRatio: 16 / 9,
    child: HomeSkeleton(
      height: 220,
      width: double.infinity,
    ),
  );
}

Widget buildPostAction() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      HomeSkeleton(
        height: 30,
        width: 100,
      ),
      HomeSkeleton(
        height: 30,
        width: 100,
      ),
    ],
  );
}

Widget buildPostInfo() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      HomeSkeleton(
        height: 20,
        width: 100,
      ),
      HomeSkeleton(
        height: 20,
        width: 100,
      ),
    ],
  );
}

Widget buildDetailTitle() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      HomeSkeleton(height: 20, width: 200),
      const SizedBox(height: 10),
      HomeSkeleton(height: 20, width: 300),
    ],
  );
}

Widget buildDetailDesc() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      HomeSkeleton(height: 20, width: 200),
      const SizedBox(height: 10),
      HomeSkeleton(height: 150, width: 300),
    ],
  );
}
