import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../screen/add_category_screen.dart';
import '../../screen/category_view_screen.dart';
import '../../screen/create_post_screen.dart';
import '../../screen/draft_post_screen.dart';
import '../../screen/go_science_users.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            const Icon(
              Icons.person,
              size: 40,
            ),
            // const SizedBox(height: 30),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),

            // Navigation Buttons
            Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      onTap: () {
                        Get.back();
                      },
                      leading: const Icon(Icons.home),
                      title: const Text(
                        'HOME',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    GetBuilder<AuthController>(
                      builder: (control) {
                        if (control.bLueBookUser != null) {
                          if (control.bLueBookUser!.isStaff) {
                            return ListTile(
                              onTap: () =>
                                  Get.toNamed(CreateArticleScreen.routeName),
                              leading: const Icon(Icons.create),
                              title: const Text(
                                'POST',
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    GetBuilder<AuthController>(
                      builder: (control) {
                        if (control.bLueBookUser != null) {
                          if (control.bLueBookUser!.isStaff) {
                            return ListTile(
                              onTap: () =>
                                  Get.toNamed(AddCategoryScreen.routeName),
                              leading: const Icon(Icons.add),
                              title: const Text(
                                'ADD CATEGORY',
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    GetBuilder<AuthController>(
                      builder: (control) {
                        if (control.bLueBookUser != null) {
                          if (control.bLueBookUser!.isAdmin) {
                            return ListTile(
                              onTap: () => Get.to(() => DraftPostScreen()),
                              leading: const Icon(Icons.create),
                              title: const Text(
                                'DRAFT',
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    GetBuilder<AuthController>(
                      builder: (control) {
                        if (control.bLueBookUser != null) {
                          if (control.bLueBookUser!.isAdmin) {
                            return ListTile(
                              onTap: () =>
                                  Get.toNamed(GoScienceUsersScreen.routeName),
                              leading: const Icon(Icons.person),
                              title: const Text(
                                'Users',
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    ExpansionTile(
                      title: const Text(
                        "CATEGORIES",
                        style: TextStyle(fontSize: 20),
                      ),
                      children: AuthController.instance.categories
                          .map((cat) => ListTile(
                                onTap: () =>
                                    Get.to(() => CategoryView(category: cat)),
                                title: Text(
                                  cat,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ))
                          .toList(),
                      controlAffinity: ListTileControlAffinity.leading,
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                ListTile(
                  onTap: () {
                    AuthController.instance.logout();
                  },
                  leading: const Icon(Icons.logout),
                  title: const Text(
                    'LOGOUT',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
