import 'package:blue_book/view/utils/method_utils.dart';
import 'package:blue_book/view/widgets/profile_widgets/profile_card.dart';
import 'package:flutter/material.dart';

import '../../models/go_science_user_model.dart';
import '../utils/constants.dart';

class UserViewScreen extends StatelessWidget {
  const UserViewScreen({super.key, required this.goScienceUser});

  final GoScienceUser goScienceUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(goScienceUser.name),
        centerTitle: true,
      ),
      body: Padding(
        padding: kDefaultAppPadding,
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.person, size: 100),
                if (goScienceUser.isStaff)
                  Positioned(
                    left: 60,
                    right: 0,
                    top: 50,
                    bottom: 0,
                    child: const Icon(
                      Icons.verified,
                      color: kPrimary,
                    ),
                  ),
              ],
            ),
            Text(
              goScienceUser.email,
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
              hintText: "username",
              pressed: () {},
              text: goScienceUser.name,
              isUserPage: false,
            ),
            ProfileCard(
              hintText: "bio",
              pressed: () {},
              text: goScienceUser.bio ?? "not set",
              isUserPage: false,
            ),
            const SizedBox(height: 10),
            Text(
              "Join on: ${MethodUtils.formatDateWithMonthAndDay(goScienceUser.createdAt)}",
              style: descriptionTextStyle,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
// keytool -genkey -v -keystore %userprofile%\upload-keystore.jks ^ -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 ^ -alias upload

