import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../controller/auth_controller.dart';
import '../../../models/go_science_model.dart';

class SearchsController extends GetxController {
  TextEditingController? searchEditingController;
  AuthController? _authController;

  RxList<GoScience> goScienceLists = RxList([]);

  @override
  void onInit() {
    super.onInit();
    searchEditingController = TextEditingController();
    _authController = AuthController.instance;
    update();
  }

  void searchArticle() {
    goScienceLists.value = _authController!.goScienceLists
        .where(
          (data) =>
              data.name.contains(searchEditingController!.text.trim()) ||
              data.category.contains(searchEditingController!.text.trim()) ||
              data.description.contains(
                searchEditingController!.text.trim(),
              ),
        )
        .toList();
    log(searchEditingController!.text);
    update();
  }

  @override
  void onClose() {
    super.onClose();
    searchEditingController!.clear();
    // _authController!.onClose();
  }
}
