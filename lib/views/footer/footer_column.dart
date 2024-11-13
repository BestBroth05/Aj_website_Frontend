import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/GeneratePageRoute.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class FooterColumn extends StatefulWidget {
  final List<AJRoute> items;
  final void Function(int index)? onClick;

  FooterColumn({
    Key? key,
    this.onClick,
    this.items = const [],
  }) : super(key: key);

  @override
  State<FooterColumn> createState() => _FooterColumnState();
}

class _FooterColumnState extends State<FooterColumn> {
  int hoverValue = -1;

  int get selected {
    for (int i = 0; i < widget.items.length; i++) {
      if (widget.items[i].url == RoutesName.current) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.1,
      padding: EdgeInsets.symmetric(horizontal: width * 0.025),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                widget.items.length,
                (index) => Expanded(
                  child: InkWell(
                    onHover: (value) => setState(
                      () => value ? hoverValue = index : hoverValue = -1,
                    ),
                    onTap: widget.onClick != null
                        ? () => widget.onClick!.call(index)
                        : null,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        widget.items[index].name.toTitle(),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: white,
                          decoration: selected == index
                              ? TextDecoration.underline
                              : null,
                          fontWeight: index == hoverValue
                              ? FontWeight.w900
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
