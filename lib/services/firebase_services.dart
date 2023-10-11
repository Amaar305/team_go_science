// create user in firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/go_science_model.dart';
import '../models/go_science_user_model.dart';
import '../view/utils/firebase_constants.dart';

class FirestoreService extends GetConnect implements GetxService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future createUserInFirestore(
      GoScienceUser bookUser, String userId) async {
    try {
      await _firestore.collection(goScienceUserCollection).doc(userId).set(bookUser.toJson());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  

  static Future uploadToFirebaseFirestore(GoScience goScience) async {
    await _firestore.collection(goScienceCollection).add(goScience.toJson());
  }
}
