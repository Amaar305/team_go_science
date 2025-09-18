import 'package:blue_book/controller/auth_controller.dart';
import 'package:blue_book/models/go_science_model.dart';
import 'package:blue_book/view/screen/view_post_screen.dart';
import 'package:blue_book/view/widgets/home_widgets/grid_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants.dart';

class CategoryView extends StatelessWidget {
  CategoryView({super.key, required this.category});
  final String category;

  final controller = AuthController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: Obx(() {
        final goSciences = controller.goScienceLists
            .where((cat) => cat.category == category && cat.isPublished == true)
            .toList();

        return GridView.builder(
          padding: kDefaultAppPadding,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: goSciences.length,
          itemBuilder: (context, index) {
            GoScience goScience = goSciences[index];
            return GridCard(
              title: goScience.name,
              urlImage: goScience.images.first,
              onTap: () {
                Get.to(() => ViewScreen(blueBook: goScience));
              },
            );
          },
        );
      }),
    );
  }
}
