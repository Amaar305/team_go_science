import 'dart:io';

import 'package:blue_book/services/current_user.dart';
import 'package:blue_book/services/firebase_services.dart';
import 'package:blue_book/view/utils/custom_full_screen_dialog.dart';
import 'package:blue_book/view/utils/custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
// import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/go_science_model.dart';
import '../view/utils/firebase_constants.dart';
import '../view/utils/method_utils.dart';

class ArticleController extends GetxController {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  QuillController? quillController;

  String selecteCategory = '';

  TextEditingController? titleEditingController;
  TextEditingController? descriptionEditingController;
  TextEditingController? habitatEditingController;
  TextEditingController? longitudeEditingController;
  TextEditingController? latitudeEditingController;

  ImagePicker? picker;

  File? pickedImagePath;

  final List<String> _images = [];
  RxList<String> categories = RxList<String>([]);

  bool? isUploaded = false;

  void _uploadCompleted() {
    isUploaded = true;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    titleEditingController = TextEditingController();
    descriptionEditingController = TextEditingController();
    habitatEditingController = TextEditingController();
    longitudeEditingController = TextEditingController();
    latitudeEditingController = TextEditingController();

    categories.bindStream(_fetchAndAddCategories());
    quillController = QuillController.basic();

    picker = ImagePicker();
    update();
  }

  @override
  void onClose() {
    super.onClose();
    titleEditingController!.clear();
    descriptionEditingController!.clear();
    habitatEditingController!.clear();
    isUploaded = false;
  }

  Stream<List<String>> _fetchAndAddCategories() {
    return _firebaseFirestore.collection(goScienceCategoryCollection).snapshots().map(
        (query) => query.docs.map((item) => item['title'].toString()).toList());
  }

  void updateCategory(String cat) {
    selecteCategory = cat;
    log(selecteCategory);
    update();
  }

// Select multilple images
  void selectMultiplesImages() async {
    try {
      CustomFullScreenDialog.showDialog();
      // pick multiple images
      final List<XFile> images = await picker!
          .pickMultiImage(
        imageQuality: 70,
      )
          .whenComplete(() {
        // uploading and sending images one by one
        CustomFullScreenDialog.cancleDialog();
      });

      // Loop through all the selected images
      for (var i in images) {
        log("Image Path: ${i.path} Is the image Path");

        await uploadingImages(File(i.path), _images)
            .whenComplete(() => _uploadCompleted());
      }
      pickedImagePath = File(images.first.path);
      update();
    } catch (e) {
      log(e.toString());
      CustomFullScreenDialog.cancleDialog();
      CustomSnackBar.showSnackBAr(
        context: Get.context,
        title: "Image picker",
        message: "Something went wrong",
        backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
      );
    }
    update();
  }

  void submitPost(String content) async {
    // Getting user info
    final loggedInUser = CurrentLoggeedInUser.currentUserId;

    CustomFullScreenDialog.showDialog();
    // Checking if user is logged in
    if (loggedInUser == null || content.isEmpty) {
      CustomFullScreenDialog.cancleDialog();
      CustomSnackBar.showSnackBAr(
        context: Get.context,
        title: "Warning!",
        message: "The user doesn't logged in, or description is empty",
        backgroundColor: Theme.of(Get.context!).colorScheme.primary,
      );
    } else {
      // else?, checking if user has selected any image
      if (_images.isNotEmpty) {
        // If images are not empty, let's upload the post
        GoScience goScience = GoScience(
          favourites: [],
          views: [],
          id: MethodUtils.generatedId,
          userId: loggedInUser.uid,
          name: titleEditingController!.text.trim(),
          habitat: habitatEditingController!.text.trim(),
          description: content,
          createdAt: Timestamp.now(),
          images: _images,
          isPublished: false,
          category: selecteCategory,
        );
        try {
          await FirestoreService.uploadToFirebaseFirestore(goScience)
              .whenComplete(() {
            CustomFullScreenDialog.cancleDialog();
            Get.back();
          });
        } catch (e) {
          CustomFullScreenDialog.cancleDialog();
          CustomSnackBar.showSnackBAr(
            context: Get.context,
            title: "Warning!",
            message: "Something wen't wrong, try again later!",
            backgroundColor: Theme.of(Get.context!).colorScheme.primary,
          );
        }
      } else {
        CustomSnackBar.showSnackBAr(
          context: Get.context,
          title: "Images empty",
          message: "You haven't select any image!",
          backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
        );
      }
    }
  }

  static Future<void> uploadingImages(File file, List<String> images) async {
    // getting image file extension
    final ext = file.path.split('.').last;
    // storage file ref with path
    final ref = FirebaseStorage.instance.ref().child(
        "images/${DateTime.now().millisecondsSinceEpoch.toString()}.$ext");

    // uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: "image/$ext"))
        .then((p0) {
      log("Data Transferred: ${p0.bytesTransferred / 1000} kb");
    });

    // updating image in firestore
    final imageUrl = await ref.getDownloadURL();
    images.add(imageUrl);
    // CustomFullScreenDialog.cancleDialog();
  }
}
