import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class FooterRow extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final void Function(int index)? onClick;

  FooterRow({
    Key? key,
    required this.title,
    this.onClick,
    this.children = const [],
  }) : super(key: key);

  @override
  State<FooterRow> createState() => _FooterRowState();
}

class _FooterRowState extends State<FooterRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  child: AutoSizeText(
                    widget.title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: white,
                      fontSize: height * 0.025,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.children,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
