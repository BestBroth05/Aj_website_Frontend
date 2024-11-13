import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';

class InventoryHeader extends StatelessWidget {
  final Map<String, bool?> headers;
  final void Function(String key, bool? value) sortBy;

  const InventoryHeader(
    this.headers, {
    Key? key,
    required this.sortBy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: teal.add(black, 0.3),
      child: Row(
        children: headers.entries.map(
          (e) {
            String key = e.key;
            bool? value = e.value;

            return Expanded(
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: white),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        key.toTitle(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => sortBy(
                        key,
                        value == null ? true : !value,
                      ),
                      icon: Icon(Icons.sort),
                      color: white,
                    )
                  ],
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
