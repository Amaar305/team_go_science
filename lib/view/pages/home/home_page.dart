import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../controller/auth_controller.dart';
import '../../../services/current_user.dart';
import '../../../models/go_science_model.dart';
import '../../screen/view_post_screen.dart';
import '../../utils/constants.dart';
import '../../utils/custom_full_screen_dialog.dart';
import '../../widgets/home_widgets/app_drawer.dart';
import '../../widgets/home_widgets/grid_card.dart';
// import 'home_controller.dart';

class HomePage extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appName,
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        // backgroundColor: Colors.white,
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.sort,
              color: Colors.white,
            ),
            underline: Container(),
            items: [
              DropdownMenuItem(
                value: 'alpha',
                child: Container(
                  child: const Row(
                    children: [
                      Icon(Icons.sort_by_alpha_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Name')
                    ],
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'date',
                child: Container(
                  child: const Row(
                    children: [
                      Icon(Icons.date_range),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Date added')
                    ],
                  ),
                ),
              ),
            ],
            onChanged: (value) {
              if (value == "date") {
                controller.goScienceLists.sort(
                  (a, b) => b.createdAt.compareTo(a.createdAt),
                );
              } else if (value == "alpha") {
                controller.goScienceLists.sort(
                  (a, b) => a.name.compareTo(b.name),
                );
              }
            },
          ),
        ],
      ),
      body: Obx(
        () {
          final sortList = controller.goScienceLists
              .where((published) => published.isPublished)
              .toList();
          // log(sortList.length);
          return GridView.builder(
            physics: BouncingScrollPhysics(),
            padding: kDefaultAppPadding,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: sortList.length,
            itemBuilder: (context, index) {
              GoScience blueBook = sortList[index];
              final currentUser = CurrentLoggeedInUser.currentUserId!.uid;
              return GridCard(
                title: blueBook.name,
                urlImage: blueBook.images.first,
                onTap: () {
                  Get.to(() => ViewScreen(blueBook: blueBook));
                  
                },
                onLongPressed: () {
                  // Checking if the currentUser own the article
                  if (currentUser == blueBook.userId) {
                    log(blueBook.id);

                    // Dleting the article
                    CustomFullScreenDialog.showAlertDialog(() async {
                      Get.back();
                      toast(' Article deleted');
                      await AuthController.instance.deletePost(blueBook.id);
                    },);
                  }
                },
              );
            },
          );
        },
      ),
      drawer: HomeDrawer(),
    );
  }
}
