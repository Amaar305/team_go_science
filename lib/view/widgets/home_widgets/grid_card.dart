import 'package:blue_book/view/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GridCard extends StatelessWidget {
  const GridCard({
    super.key,
    required this.title,
    required this.urlImage,
    required this.onTap,
    this.onLongPressed,
  });
  final String title, urlImage;
  final void Function() onTap;
  final void Function()? onLongPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => onTap(),
      onLongPress: () => onLongPressed!(),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Theme.of(context).colorScheme.primary,
        child: CachedNetworkImage(
          imageUrl: urlImage,
          placeholder: (context, url) {
            return Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          },
          errorWidget: (context, url, error) {
            return const Center(
                child: Icon(Icons.image_not_supported_outlined));
          },
          imageBuilder: (context, imageProvider) {
            return Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  left: 0,
                  child: Container(
                    child: Text(
                      title,
                      style: titleTextStyle.copyWith(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    color: Colors.black26,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
// const SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Text(
//                 title,
//                 style: descriptionTextStyle,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             )