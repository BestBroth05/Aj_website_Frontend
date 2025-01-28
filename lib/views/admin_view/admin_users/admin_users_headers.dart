import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';

class AdminUsersHeaders extends StatelessWidget {
  final Map<String, int> headers;
  const AdminUsersHeaders(this.headers, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: teal.add(black, 0.3),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(5),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: headers.entries.map(
          (entry) {
            String key = entry.key;
            int value = entry.value;

            return Expanded(
              flex: value,
              child: Container(
                decoration: BoxDecoration(
                  border: key == 'status'
                      ? null
                      : Border(
                          right: BorderSide(
                            color: white,
                          ),
                        ),
                ),
                child: Center(
                  child: AutoSizeText(
                    key.split('_').join(' ').toTitle(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: white),
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
