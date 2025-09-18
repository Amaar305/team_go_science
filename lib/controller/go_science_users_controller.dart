import 'package:blue_book/view/utils/constants.dart';
import 'package:blue_book/view/utils/custom_full_screen_dialog.dart';
import 'package:blue_book/view/utils/custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/go_science_user_model.dart';

class GoScienceUsersController extends GetxController {
  RxList<GoScienceUser> goScienceUser = RxList([]);

  late CollectionReference _collectionReference;

  @override
  void onInit() {
    super.onInit();
    _collectionReference = FirebaseFirestore.instance.collection('users');
    goScienceUser.bindStream(_streamAllGoScienceUsers());
  }

// Stream all users and fetch them all, excluding "amarrameen2003@gmail.com" user this email
  Stream<List<GoScienceUser>> _streamAllGoScienceUsers() {
    return _collectionReference
        // .orderBy("createdAt", descending: true)
        .where("email", isNotEqualTo: "amarrameen2003@gmail.com")
        .snapshots()
        .map((query) => query.docs
            .map((user) => GoScienceUser.fromDocument(user))
            .toList());
  }

// Make a user staff, or remove a user from being staff
  void makeUserStaffOrRemove(String userId, bool add, String name) async {
    try {
      CustomFullScreenDialog.showDialog();
      if (add) {
        await _collectionReference
            .doc(userId)
            .update({"isStaff": true}).whenComplete(() {
          CustomFullScreenDialog.cancleDialog();
          toast("$name is a staff now");
        });
      } else {
        await _collectionReference
            .doc(userId)
            .update({"isStaff": false}).whenComplete(() {
          CustomFullScreenDialog.cancleDialog();
          toast("$name is not longer a staff now");
        });
      }
    } catch (e) {
      CustomFullScreenDialog.cancleDialog();
      CustomSnackBar.showSnackBAr(
        context: Get.context,
        title: "Error",
        message: "Couldn't finish your request, please try again later!",
        backgroundColor: kPrimary,
      );
    }
  }
}
