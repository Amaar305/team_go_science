import 'dart:convert';

import 'package:blue_book/models/go_science_model.dart';
import 'package:blue_book/models/go_science_user_model.dart';
import 'package:blue_book/view/utils/constants.dart';
import 'package:blue_book/view/utils/custom_full_screen_dialog.dart';
import 'package:blue_book/view/utils/custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class ViewScreenController extends GetxController {
  int activeIndex = 0;
  GoScienceUser? goScienceUser;
  GoScience? goScience;
  final _firestore = FirebaseFirestore.instance;

  QuillController? quillController;

  // int likeCount = 0;
  var isLiked = false;

  int viewCount = 0;
  var isViewed = false;

  void updateviewCount(int count) {
    this.viewCount = count;
    update();
  }

  void updateisViewed(bool isViewed) {
    this.isViewed = isViewed;
    update();
  }

  // void updateLikedCount(int count) {
  //   likeCount = count;
  //   update();
  // }

  void updateisLiked(bool isLiked) {
    this.isLiked = isLiked;
    update();
  }

  // void likeCountDecrease() {
  //   likeCount--;
  //   update();
  // }

// Get information of the user who made the post
  void postUserInfo(String userId) async {
    try {
      final result = await _firestore.collection("users").doc(userId).get();
      goScienceUser = GoScienceUser.fromJson(result.data()!);
      update();
    } catch (e) {
      log(e.toString());
    }
    update();
  }

  void quillDescription(String content) {
    var contentJson = jsonDecode(content);
    quillController = QuillController(
      document: Document.fromJson(contentJson),
      selection: const TextSelection.collapsed(offset: 0),
    );
    update();
  }

// update carousel active index
  void updateIndex(int index) {
    this.activeIndex = index;
    update();
  }

  void updateView(String id, bool isViewed, String userId) async {
    try {
      if (!isViewed) {
        await _firestore.collection("go_science").doc(id).update({
          "favourites": FieldValue.arrayUnion(
            [userId],
          )
        }).whenComplete(() => getArticle(id));
      }
      update();
    } catch (e) {
      log(e.toString());
    }
    update();
  }

  void getArticle(String postId) async {
    try {
      final result =
          await _firestore.collection("go_science").doc(postId).get();
      goScience = GoScience.fromDocument(result);
      update();
    } catch (e) {
      log(e.toString());
    }
    update();
  }

  void addOrRemovePostToFavorite(bool add, String postId, String userId) async {
    try {
      CustomFullScreenDialog.showDialog();
      if (add) {
        await _firestore.doc(postId).update({
          'favourites': FieldValue.arrayUnion(
            [userId],
          )
        }).whenComplete(() => CustomFullScreenDialog.cancleDialog());
        // likeCountDecrease();
        updateisLiked(false);
        toast("Article added");
        update();
      } else {
        await _firestore.collection("go_science").doc(postId).update({
          "favourites": FieldValue.arrayRemove(
            [userId],
          )
        }).whenComplete(() => CustomFullScreenDialog.cancleDialog());
        toast("Article removed");
        updateisLiked(true);
        update();
      }
    } catch (e) {
      CustomFullScreenDialog.cancleDialog();
      CustomSnackBar.showSnackBAr(
        context: Get.context,
        title: "Error",
        message: "Somrthing went wrong! try again later",
        backgroundColor: kPrimary,
      );
    }
  }
}
