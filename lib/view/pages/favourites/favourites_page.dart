// import 'package:flutter/cupertino.dart';
import 'package:blue_book/view/pages/favourites/favourite_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../controller/auth_controller.dart';
import '../../../services/current_user.dart';
import '../../../models/go_science_model.dart';
import '../../screen/view_post_screen.dart';
import '../../utils/constants.dart';
import '../../utils/custom_full_screen_dialog.dart';
import '../../widgets/home_widgets/grid_card.dart';

class FavouritesPage extends GetView<FavouriteController> {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourites"),
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
                controller.favourites.sort(
                  (a, b) => b.createdAt.compareTo(a.createdAt),
                );
              } else if (value == "alpha") {
                controller.favourites.sort(
                  (a, b) => a.name.compareTo(b.name),
                );
              }
            },
          ),
        
        ],
      ),
      body: Obx(
        () => GridView.builder(
          padding: kDefaultAppPadding,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: controller.favourites.length,
          itemBuilder: (context, index) {
            GoScience blueBook = controller.favourites[index];
            final currentUser = CurrentLoggeedInUser.currentUserId!.uid;
            return GridCard(
              title: blueBook.name,
              urlImage: blueBook.images.first,
              onTap: () {
                Get.to(() => ViewScreen(blueBook: blueBook));
                // Get.to(() => CurvedBar());
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
                  });
                }
              },
            );
          },
        ),
      ),
    );
  }
}
