import 'package:blue_book/shimmers/home_skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget buildImage(String urlImage, int index) => AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: CachedNetworkImage(
          imageUrl: urlImage,
          placeholder: (context, url) {
            return HomeSkeleton();
          },
          errorWidget: (context, url, error) {
            return const Center(
              child: Icon(Icons.image_not_supported_outlined),
            );
          },
          imageBuilder: (context, imageProvider) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                image: imageProvider,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          },
        ),
      ),
    );
