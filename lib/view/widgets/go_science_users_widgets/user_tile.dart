import 'package:flutter/material.dart';

import '../../../models/go_science_user_model.dart';
import '../../utils/constants.dart';
import '../../utils/method_utils.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.goScienceUser,
    this.onLongPressed, required this.onPressed,
  });
  final GoScienceUser goScienceUser;
  final void Function()? onLongPressed;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      height: MediaQuery.of(context).size.height * 0.12,
      width: double.maxFinite,
      child: InkWell(
        onLongPress: () => onLongPressed!(),
        onTap: () => onPressed(),
        borderRadius: BorderRadius.circular(10),
        child: Card(
          color: kPrimary,
          clipBehavior: Clip.antiAlias,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (goScienceUser.isStaff)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Icon(
                    Icons.verified,
                    color: Colors.white,
                    size: 12.0,
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: SizedBox(),
                ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: kSecondary,
                  child: Center(
                    child: Text(goScienceUser.name[0]),
                  ),
                ),
                title: Text(
                  goScienceUser.name,
                  style: descriptionTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  MethodUtils.formatDate(goScienceUser.createdAt),
                  style: titleTextStyle.copyWith(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
