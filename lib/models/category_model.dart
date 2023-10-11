import 'package:cloud_firestore/cloud_firestore.dart';

class GoSceinceCategory {
  late String id;
  late String title;
  late Timestamp createdAt;
  late String userId;

  GoSceinceCategory({
    required this.title,
    required this.id,
    required this.createdAt,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "createdAt": createdAt,
      "userId": userId,
    };
  }

  factory GoSceinceCategory.fromJson(Map<String, dynamic> json, String id) {
    return GoSceinceCategory(
      title: json['title'] as String,
      id: json['id'] as String,
      userId: json['userId'] as String,
      createdAt: json['createdAt'] as Timestamp,
    );
  }

  factory GoSceinceCategory.fromDocument(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final id = snapshot.id;
    return GoSceinceCategory.fromJson(data, id);
  }
}
