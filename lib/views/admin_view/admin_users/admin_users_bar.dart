import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/views/admin_view/admin_users/admin_new_user.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class AdminUsersBar extends StatefulWidget {
  final Function(User newUser) createNewUser;
  AdminUsersBar({
    Key? key,
    required this.createNewUser,
  }) : super(key: key);

  @override
  State<AdminUsersBar> createState() => _AdminUsersBarState();
}

class _AdminUsersBarState extends State<AdminUsersBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height * 0.075,
      padding: EdgeInsets.symmetric(horizontal: width * 0.005),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
        color: teal.add(black, 0.3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => openLink(
              context,
              AJRoute.admin.url,
              isRoute: true,
            ),
            iconSize: 30,
            icon: Icon(Icons.chevron_left_rounded, color: white),
          ),
          CustomButton(
            text: 'New User',
            color: teal,
            onPressed: () => openDialog(
              context,
              container: AdminNewUser(
                createNewUser: widget.createNewUser,
              ),
              block: true,
            ),
          ),
        ],
      ),
    );
  }
}
