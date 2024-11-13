import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/administration/user/userType.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';

class AdminUserTile extends StatefulWidget {
  final User user;
  final Map<String, int> values;
  final bool isOdd;
  final Function(User? user) changeUser;
  final bool isSelected;
  AdminUserTile(
    this.user, {
    Key? key,
    required this.values,
    required this.changeUser,
    this.isOdd = false,
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<AdminUserTile> createState() => _AdminUserTileState();
}

class _AdminUserTileState extends State<AdminUserTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.changeUser.call(
        widget.isSelected ? null : widget.user,
      ),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: widget.isSelected
              ? darkGreen
              : widget.isOdd
                  ? backgroundColor
                  : white,
        ),
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: widget.values.entries.map(
            (entry) {
              String key = entry.key;
              int flex = entry.value;
              dynamic value = widget.user.toJson()[key];

              switch (key) {
                case 'type':
                  value = UserType.values[value].name;
                  break;
                case 'isActive':
                  value = value == 1 ? 'Active' : 'Not Active';
                  break;
                case 'name':
                  value = widget.user.fullName;
                  break;
                case 'id':
                  value = '$value'.padLeft(7, '0');
                  break;
              }

              return Expanded(
                flex: flex,
                child: Container(
                  decoration: BoxDecoration(
                    border: key == 'isActive'
                        ? null
                        : Border(
                            right: BorderSide(color: gray.add(black, 0.4)),
                          ),
                  ),
                  child: Center(
                    child: AutoSizeText(
                      value.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: widget.isSelected ? white : black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
