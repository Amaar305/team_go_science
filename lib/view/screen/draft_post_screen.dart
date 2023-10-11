import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../controller/draft_controller.dart';
import '../../models/go_science_model.dart';
import '../utils/custom_snackbar.dart';
import '../utils/method_utils.dart';
import '../widgets/draft_widgets/post_widget.dart';
import 'view_post_screen.dart';

class DraftPostScreen extends StatefulWidget {
  DraftPostScreen({super.key});

  @override
  State<DraftPostScreen> createState() => _DraftPostScreenState();
}

class _DraftPostScreenState extends State<DraftPostScreen> {
  final DraftPostController control = Get.find();

  final AuthController controller = AuthController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Draft"),
      ),
      body: Obx(() {
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: controller.goScienceLists.length,
          itemBuilder: (context, index) {
            GoScience blueBook = controller.goScienceLists[index];
            // control.postUserInfo(blueBook.user);
            return PublishPost(
              image: blueBook.images.first,
              title: blueBook.name,
              subTitle: blueBook.habitat,
              date: MethodUtils.formatDate(blueBook.createdAt),
              isPublished: blueBook.isPublished,
              onTap: () => Get.to(() => ViewScreen(blueBook: blueBook)),
              onLongPressed: () {
                CustomSnackBar.customAlertDialoag(
                  "Publish",
                  'You\'re going to ${blueBook.isPublished ? 'Unpublish' : 'Publish'} this post!',
                  blueBook.isPublished ? 'Unpublish' : 'Publish',
                  () {
                    if (blueBook.isPublished) {
                      control.publishPost(blueBook.id, false);
                    } else {
                      control.publishPost(blueBook.id, true);
                    }
                  },
                );
              },
            );
          },
        );
      }),
    );
  }
}
