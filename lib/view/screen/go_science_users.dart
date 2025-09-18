import 'package:blue_book/view/screen/user_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/go_science_users_controller.dart';
import '../../models/go_science_user_model.dart';
import '../utils/custom_snackbar.dart';
import '../widgets/go_science_users_widgets/user_tile.dart';

class GoScienceUsersScreen extends GetView<GoScienceUsersController> {
  const GoScienceUsersScreen({super.key});
  static const routeName = "/all-users";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Go Science Users"),
        centerTitle: true,
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
                controller.goScienceUser.sort(
                  (a, b) => b.createdAt.compareTo(a.createdAt),
                );
              } else if (value == "alpha") {
                controller.goScienceUser.sort(
                  (a, b) => a.name.compareTo(b.name),
                );
              }
            },
          ),
        ],
     
      ),
      body: Obx(
        () => ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: controller.goScienceUser.length,
          itemBuilder: (context, index) {
           
            GoScienceUser goScienceUser = controller.goScienceUser[index];
            return UserTile(
              goScienceUser: goScienceUser,
              onPressed: () => Get.to(
                () => UserViewScreen(goScienceUser: goScienceUser),
              ),
              onLongPressed: () {
                CustomSnackBar.customAlertDialoag(
                  "Staffing",
                  'You\'re going to make ${goScienceUser.name} ${goScienceUser.isStaff ? 'unStaff' : 'Staff'} ?',
                  goScienceUser.isStaff ? 'Remove' : 'Add',
                  () {
                    if (goScienceUser.isStaff) {
                      controller.makeUserStaffOrRemove(
                          goScienceUser.id, false, goScienceUser.name);
                    } else {
                      controller.makeUserStaffOrRemove(
                          goScienceUser.id, true, goScienceUser.name);
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
