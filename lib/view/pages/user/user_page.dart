import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../utils/constants.dart';
import '../../widgets/create_widgets/create_form.dart';
import '../../widgets/profile_widgets/profile_card.dart';

class UserPage extends StatelessWidget {
  final AuthController controller = Get.find();
  static const routeName = '/user-page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.logout(),
        label: Icon(Icons.logout),
      ),
      body: Padding(
        padding: kDefaultAppPadding,
        child: GetBuilder<AuthController>(builder: (controll) {
          if (controll.bLueBookUser != null) {
            return ListView(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                const Icon(Icons.person, size: 72),
                Text(
                  controll.bLueBookUser!.email,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    'My Details',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 10),
                ProfileCard(
                  isUserPage: true,
                  hintText: 'username',
                  pressed: () {
                    controll.editingController.text =
                        controller.bLueBookUser!.name;
                    Get.bottomSheet(
                      Container(
                        padding: kDefaultAppPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MyTextField(
                              hintText: 'Username',
                              controller: controll.editingController,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                controll.updateName(
                                  name: controll.editingController.text,
                                );
                              },
                              child: const Text("Update", style: kTextStyle),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  text: controll.bLueBookUser!.name,
                ),
                ProfileCard(
                  isUserPage: true,
                  hintText: 'bio',
                  pressed: () {
                    controll.bioController.text =
                        controller.bLueBookUser!.bio ?? "not set";
                    Get.bottomSheet(
                      Container(
                        padding: kDefaultAppPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MyTextField(
                              hintText: 'Bio',
                              controller: controll.bioController,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                controll.updateBio(
                                    bio: controll.bioController.text);
                              },
                              child: const Text(
                                "Update",
                                style: kTextStyle,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  text: controll.bLueBookUser!.bio ?? "not set",
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
