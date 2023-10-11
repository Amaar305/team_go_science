import 'package:cloud_firestore/cloud_firestore.dart';

class GoScience {
  late String id;
  late String userId;
  late String name;
  late String category;
  late String habitat;
  late String description;
  late List<String> images;
  late String? videoUrl;
  late Timestamp createdAt;
  late String? longitude;
  late String? latitude;
  late bool isPublished;
  late List<String> favourites;
  late List<String> views;

  GoScience({
    required this.id,
    required this.userId,
    required this.name,
    required this.habitat,
    required this.description,
    required this.createdAt,
    required this.images,
    required this.isPublished,
    required this.category,
    required this.favourites,
    required this.views,
    this.videoUrl,
    this.longitude,
    this.latitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "name": name,
      "habitat": habitat,
      "description": description,
      "longitude": longitude,
      "latitude": latitude,
      "createdAt": createdAt,
      "images": images,
      "isPublished": isPublished,
      "category": category,
      "favourites": favourites,
      "views": views,
    };
  }

  factory GoScience.fromJson(Map<String, dynamic> json, String id) {
    return GoScience(
      id: id,
      userId: json['userId'] as String,
      name: json['name'] as String,
      habitat: json['habitat'] as String,
      description: json['description'] as String,
      createdAt: json['createdAt'] as Timestamp,
      images: (json['images'] as List<dynamic>).cast<String>(),
      videoUrl: json["videoUrl"] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      category: json['category'] as String,
      isPublished: json["isPublished"] as bool,
      favourites: (json['favourites'] as List<dynamic>).cast<String>(),
      views: (json['views'] as List<dynamic>).cast<String>(),
    );
  }

  factory GoScience.fromDocument(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final id = snapshot.id;
    return GoScience.fromJson(data, id);
  }
}
