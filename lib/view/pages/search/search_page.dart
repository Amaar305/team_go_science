import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/go_science_model.dart';
import '../../screen/view_post_screen.dart';
import '../../utils/constants.dart';
import '../../utils/method_utils.dart';
import '../../widgets/draft_widgets/post_widget.dart';
import 'search_controller.dart';

class SearchPage extends GetView<SearchsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Search"),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Padding(
              padding: kDefaultAppPadding,
              child: TextFormField(
                controller: controller.searchEditingController,
                onChanged: (value) {
                  controller.searchArticle();
                },
                // onSaved: (newValue) => _searchController.searchArticle(),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  fillColor: Theme.of(context).colorScheme.primary,
                  filled: true,
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  hintText: "Search..",
                ),
              ),
            ),
          ),
        ),
        body: Obx(
          () {
            return ListView.builder(
              itemCount: controller.goScienceLists.length,
              itemBuilder: (context, index) {
                GoScience goScience = controller.goScienceLists[index];
                return PublishPost(
                  image: goScience.images.first,
                  title: goScience.name,
                  subTitle: goScience.habitat,
                  isPublished: goScience.isPublished,
                  date: MethodUtils.formatDate(goScience.createdAt),
                  onTap: () => Get.to(() => ViewScreen(blueBook: goScience)),
                  onLongPressed: () {},
                );
              },
            );
          },
        ));
  }
}
