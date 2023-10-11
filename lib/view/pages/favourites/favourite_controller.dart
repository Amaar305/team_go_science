import 'package:blue_book/services/current_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../models/go_science_model.dart';

class FavouriteController extends GetxController {
  // AuthController _authController = AuthController.instance;
  final currentLoggeedInUser = CurrentLoggeedInUser.currentUserId!.uid;

  RxList<GoScience> favourites = RxList([]);

  @override
  void onInit() {
    super.onInit();
    // searchArticle();
    favourites.bindStream(_favArticles());
  }

  Stream<List<GoScience>> _favArticles() {
    return FirebaseFirestore.instance
        .collection("go_science")
        .where("favourites", arrayContainsAny: [currentLoggeedInUser])
        .snapshots()
        .map((query) =>
            query.docs.map((item) => GoScience.fromDocument(item)).toList());
  }
}
