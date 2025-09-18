import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

import '../view/utils/custom_full_screen_dialog.dart';
import '../view/utils/custom_snackbar.dart';
import '../view/utils/firebase_constants.dart';
import '../services/current_user.dart';

class EditPostController extends GetxController {
  TextEditingController? titleEditingController;
  TextEditingController? descriptionEditingController;
  TextEditingController? habitatEditingController;

  QuillController? quillController;

  String title = "";
  String description = "";
  String habitat = "";
  String location = "";

  final _firestore = FirebaseFirestore.instance;
  late CollectionReference _collectionReference;

  @override
  void onInit() {
    super.onInit();

    titleEditingController = TextEditingController();
    descriptionEditingController = TextEditingController();
    habitatEditingController = TextEditingController();
    quillController = QuillController.basic();
    _collectionReference = _firestore.collection(goScienceCollection);
    update();
  }

  void updateControllersText({
    String? title,
    String? description,
    String? habitat,
  }) {
    titleEditingController!.text = title!;
    descriptionEditingController!.text = description!;
    habitatEditingController!.text = habitat!;

    update();
  }

  void tryUpdate(String postDoc, String ownerId, content) async {
    if (CurrentLoggeedInUser.currentUserId!.uid == ownerId) {
      try {
        Map<String, dynamic> updatedBook = {
          "name": titleEditingController!.text.trim(),
          "description": content,
          "habitat": habitatEditingController!.text.trim(),
        };
        CustomFullScreenDialog.showDialog();
        await _collectionReference
            .doc(postDoc)
            .update(updatedBook)
            .whenComplete(() {
          CustomFullScreenDialog.cancleDialog();
        });
        Get.back();
      } catch (e) {
        CustomFullScreenDialog.cancleDialog();
        CustomSnackBar.showSnackBAr(
          context: Get.context,
          title: "Post updating!",
          message:
              "Couldn't update, try again later. Error code ${e.toString()}",
          backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
        );
      }
    } else {
      CustomSnackBar.showSnackBAr(
        context: Get.context,
        title: "Warning!",
        message: "Trying to update the post that wasn't your's!",
        backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
      );
    }
  }

  void quillDescription(String content) {
    var contentJson = jsonDecode(content);
    quillController = QuillController(
      document: Document.fromJson(contentJson),
      selection: const TextSelection.collapsed(offset: 0),
    );
    update();
  }
}
