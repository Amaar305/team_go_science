import 'package:blue_book/view/utils/constants.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.hintText,
    required this.pressed,
    required this.text,
    this.isUserPage,
  });
  final String hintText;
  final void Function() pressed;
  final String text;
  final bool? isUserPage;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  hintText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    // color: Colors.grey[200],
                  ),
                ),
                const Spacer(),
                if (isUserPage!)
                  GestureDetector(
                    onTap: () => pressed(),
                    child: const Icon(Icons.settings),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              text,
              style: descriptionTextStyle.copyWith(fontSize: 20),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
