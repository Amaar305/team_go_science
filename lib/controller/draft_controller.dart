import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/go_science_user_model.dart';
import '../view/utils/custom_full_screen_dialog.dart';
import '../view/utils/custom_snackbar.dart';

class DraftPostController extends GetxController {
  GoScienceUser? bookUser;
  final _firestore = FirebaseFirestore.instance;

  void postUserInfo(String userId) async {
    try {
      final result = await _firestore.collection("users").doc(userId).get();
      bookUser = GoScienceUser.fromJson(result.data()!);
      update();
    } catch (e) {
      log(e.toString());
    }
    update();
  }

  void publishPost(String postDoc, bool publishedOrNot) async {
    try {
      CustomFullScreenDialog.showDialog();
      await FirebaseFirestore.instance
          .collection("go_science")
          .doc(postDoc)
          .update({"isPublished": publishedOrNot}).whenComplete(
              () => CustomFullScreenDialog.cancleDialog());
      update();
    } catch (e) {
      CustomFullScreenDialog.cancleDialog();
      CustomSnackBar.showSnackBAr(
        context: Get.context,
        title: "Error",
        message: "Couldn't complete your request",
        backgroundColor: Theme.of(Get.context!).colorScheme.primary,
      );
      update();
    }
  }
}
