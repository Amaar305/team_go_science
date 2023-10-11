import 'package:blue_book/view/utils/custom_full_screen_dialog.dart';
import 'package:blue_book/view/utils/custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../models/category_model.dart';
import '../view/utils/firebase_constants.dart';
import '../services/current_user.dart';

class AddCategoryController extends GetxController {
  TextEditingController? titleEditingController;
  CollectionReference? _collectionReference;
  @override
  void onInit() {
    super.onInit();
    titleEditingController = TextEditingController();
    _collectionReference = FirebaseFirestore.instance.collection(goScienceCategoryCollection);
  }

  @override
  void onClose() {
    super.onClose();
    titleEditingController!.clear();
  }

  void trySubmitCat() async {
    // Current User info
    final loggedInUser = CurrentLoggeedInUser.currentUserId;

    // Checking if Current User is not null
    if (loggedInUser != null) {
      try {
        GoSceinceCategory goSceinceCategory = GoSceinceCategory(
          title: titleEditingController!.text.trim(),
          id: Uuid().v4(),
          createdAt: Timestamp.now(),
          userId: loggedInUser.uid,
        );
        CustomFullScreenDialog.showDialog();
        await _collectionReference!
            .add(goSceinceCategory.toJson())
            .whenComplete(() {
          CustomFullScreenDialog.cancleDialog();
          Get.back();
        });
        update();
      } catch (e) {
        CustomFullScreenDialog.cancleDialog();
        CustomSnackBar.showSnackBAr(
          context: Get.context,
          title: 'Couldn\'t post!',
          message: 'Something wen\'t wrong! try again later $e',
          backgroundColor: Theme.of(Get.context!).colorScheme.primary,
        );
      }
    } else {
      CustomSnackBar.showSnackBAr(
        context: Get.context,
        title: 'Couldn\'t post!',
        message: 'Something wen\'t wrong! user is not logged in',
        backgroundColor: Theme.of(Get.context!).colorScheme.primary,
      );
    }
  }
}
