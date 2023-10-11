import 'package:cloud_firestore/cloud_firestore.dart';

class GoScienceUser {
  late String id;
  late String name;
  late String email;
  late Timestamp createdAt;
  late bool isStaff;
  late bool isAdmin;

  String? bio;

  GoScienceUser({
    required this.name,
    required this.email,
    this.bio,
    required this.id,
    required this.createdAt,
    required this.isStaff,
    required this.isAdmin,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'email': email,
      'createdAt': createdAt,
      'isStaff': isStaff,
      'isAdmin': isAdmin,
    };
  }

  factory GoScienceUser.fromDocument(DocumentSnapshot doc) {
    return GoScienceUser(
      name: doc['name'] ?? '',
      email: doc['email'] ?? '',
      id: doc.id,
      createdAt: doc['createdAt'] ?? Timestamp.now(),
      isStaff: doc['isStaff'] ?? false,
      isAdmin: doc['isAdmin'] ?? false,
      bio: doc['bio'] ?? "",
    );
  }
  factory GoScienceUser.fromJson(Map<String, dynamic> json) {
    return GoScienceUser(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      id: json['id'] ?? '',
      createdAt: json['createdAt'] ?? Timestamp.now(),
      isStaff: json['isStaff'] ?? false,
      isAdmin: json['isAdmin'] ?? false,
      bio: json['bio'] ?? "",
    );
  }
}
