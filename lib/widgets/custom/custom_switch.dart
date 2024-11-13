import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';

class CustomSwitch extends StatefulWidget {
  final String? text;
  final bool value;
  final Function(bool value) onChanged;
  CustomSwitch({
    Key? key,
    this.text,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.text != null ? 200 : 100,
      child: Column(
        children: [
          widget.text != null
              ? Expanded(
                  child: AutoSizeText(
                    widget.text!,
                    textAlign: TextAlign.end,
                  ),
                )
              : Container(),
          Expanded(
            child: Switch(
              onChanged: widget.onChanged,
              value: widget.value,
              activeColor: teal.add(black, 0.2),
            ),
          ),
        ],
      ),
    );
  }
}
