import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class PublishPost extends StatelessWidget {
  const PublishPost({
    Key? key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.isPublished,
    required this.date,
    required this.onTap,
    this.onLongPressed,
  }) : super(key: key);

  final String image;
  final String title;
  final String subTitle;
  final bool isPublished;
  final String date;
  final void Function() onTap;
  final void Function()? onLongPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      onLongPress: () => onLongPressed!(),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Theme.of(context).colorScheme.primary,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: CachedNetworkImage(
                    imageUrl: image,
                    placeholder: (context, url) => Container(),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.image_not_supported_outlined),
                    ),
                    imageBuilder: (context, imageProvider) => ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 110,
                      ),
                    ),
                  )),
                  const SizedBox(width: 5),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: titleTextStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          subTitle,
                          style: descriptionTextStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isPublished ? Icon(Icons.verified) : Icon(Icons.cancel),
                  Text(date, style: descriptionTextStyle)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
