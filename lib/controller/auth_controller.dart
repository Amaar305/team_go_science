import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/go_science_model.dart';
import '../models/go_science_user_model.dart';
import '../view/pages/dashboard/my_dashboard.dart';
import '../services/firebase_services.dart';
import '../view/utils/custom_full_screen_dialog.dart';
import '../view/utils/custom_snackbar.dart';
import '../view/screen/login_screen.dart';
import '../view/utils/firebase_constants.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  TextEditingController editingController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  TextEditingController searchController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  // String dataSource = u;

  GetStorage box = GetStorage();

  // email, password and name..
  late Rx<User?> _user;

  RxList<GoScience> goScienceLists = RxList<GoScience>([]);
  GoScienceUser? bLueBookUser;

  String userCredential() {
    return box.read("user");
  }

  late CollectionReference _collectionReference;
  RxList<String> categories = RxList<String>([]);
  @override
  void onInit() {
    super.onInit();
    _collectionReference = fire.collection(goScienceCollection);
    goScienceLists.bindStream(getAllGoScience());
    categories.bindStream(_fetchAndAddCategories());
    update();
  }

  @override
  void onReady() {
    super.onReady();

    // Casting to the value of _user to Rx value
    _user = Rx<User?>(auth.currentUser);

    // Whatever happen with user, will be notify
    _user.bindStream(auth.userChanges());

    // ever function takes a listener (Firebase user),
    // and callback method, anytime something changes, the method will be notified
    ever(_user, _initialScreensSettings);
    update();
  }

  _initialScreensSettings(User? user) async {
    if (user == null) {
      debugPrint("LOGGING");
      Get.offAll(() => LoginScreen());
    } else {
      await Future.delayed(Duration(milliseconds: 200)).whenComplete(() {
        fetchUserDetails();
      });
      debugPrint("WELCOME");
      Get.offAll(() => MyDashBoard());
      update();
    }
  }

  void register(String email, String password, String name) async {
    try {
      CustomFullScreenDialog.showDialog();
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      box.write('user', credential.user!.uid);

      await Future.delayed(const Duration(milliseconds: 200));

      await FirestoreService.createUserInFirestore(
        GoScienceUser(
            name: name,
            email: email,
            id: _user.value!.uid,
            createdAt: Timestamp.now(),
            isStaff: false,
            isAdmin: false),
        _user.value!.uid,
      ).whenComplete(() {
        CustomFullScreenDialog.cancleDialog();
        CustomSnackBar.showSnackBAr(
          context: Get.context,
          title: "User Created",
          message: "User Registered Successifully",
          backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
        );
      });
      // await fetchUserDetails();
      update();
    } on FirebaseAuthException catch (err) {
      CustomFullScreenDialog.cancleDialog();
      // debugPrint(err.message);
      CustomSnackBar.showSnackBAr(
        context: Get.context,
        title: "About user",
        message: err.message.toString(),
        backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
      );
    } catch (e) {
      CustomSnackBar.showSnackBAr(
        context: Get.context,
        title: "About user",
        message: "Something wen't wrong, try again later!",
        backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
      );
      CustomFullScreenDialog.cancleDialog();
    }
    update();
  }

  void login(String email, String password) async {
    try {
      CustomFullScreenDialog.showDialog();
      UserCredential credential = await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .whenComplete(() {
        CustomFullScreenDialog.cancleDialog();
      });

      CustomSnackBar.showSnackBAr(
        context: Get.context,
        title: "User Login",
        message: "User Login Successifully",
        backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
      );

      await box.write('user', credential.user!.uid);

      update();
    } on FirebaseAuthException catch (err) {
      log(err.message);
      var message = 'An error occurred, please check your credencials!';
      if (err.message != null) {
        message = err.message!;
      }
      if (err.code == "INVALID_LOGIN_CREDENTIALS") {
        CustomSnackBar.showSnackBAr(
          context: Get.context,
          title: "About login",
          message: "Email or password is incorrect!",
          backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
        );
      } else {
        CustomSnackBar.showSnackBAr(
          context: Get.context,
          title: "About login",
          message: message,
          backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
        );
      }
      update();
    } catch (e) {
      CustomFullScreenDialog.cancleDialog();
      CustomSnackBar.showSnackBAr(
        context: Get.context,
        title: "About login",
        message: "Something went wrong ${e.toString()}",
        backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
      );
    }
    update();
  }

  void logout() async {
    await auth.signOut();
    await box.remove("user");
    update();
  }

  final fire = FirebaseFirestore.instance;

  Future<void> fetchUserDetails() async {
    final result = await fire
        .collection(goScienceUserCollection)
        .doc(userCredential())
        .get();
    bLueBookUser = GoScienceUser.fromJson(result.data()!);
    update();
  }

  void updateName({required String name}) async {
    try {
      await fire
          .collection(goScienceUserCollection)
          .doc(userCredential())
          .update({"name": name}).whenComplete(() {
        CustomFullScreenDialog.cancleDialog();
        CustomSnackBar.showSnackBAr(
          context: Get.context,
          title: "Name updated",
          message: "Name updated successifully",
          backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
        );
      });
      await fetchUserDetails();
      update();
    } catch (e) {
      CustomFullScreenDialog.cancleDialog();
      CustomSnackBar.showSnackBAr(
        context: Get.context,
        title: "About update",
        message: "Something went wrong, try again!",
        backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
      );
    }
  }

  void updateBio({required String bio}) async {
    try {
      await fire
          .collection(goScienceUserCollection)
          .doc(userCredential())
          .update({"bio": bio}).whenComplete(() {
        CustomFullScreenDialog.cancleDialog();
        CustomSnackBar.showSnackBAr(
          context: Get.context,
          title: "Bio updated",
          message: "Bio updated successifully",
          backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
        );
      });
      await fetchUserDetails();
      update();
    } catch (e) {
      CustomFullScreenDialog.cancleDialog();
      CustomSnackBar.showSnackBAr(
        context: Get.context,
        title: "About update",
        message: "Something went wrong, try again!",
        backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
      );
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      CustomFullScreenDialog.showDialog();
      await _collectionReference
          .doc(postId)
          .delete()
          .whenComplete(() => CustomFullScreenDialog.cancleDialog());
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

  @override
  void onClose() {
    editingController.clear();
    bioController.clear();
    super.onClose();
  }

  Stream<List<GoScience>> getAllGoScience() {
    return _collectionReference
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (query) =>
              query.docs.map((item) => GoScience.fromDocument(item)).toList(),
        );
  }

  Stream<List<String>> _fetchAndAddCategories() {
    return FirebaseFirestore.instance.collection("categories").snapshots().map(
        (query) => query.docs.map((item) => item['title'].toString()).toList());
  }
}
