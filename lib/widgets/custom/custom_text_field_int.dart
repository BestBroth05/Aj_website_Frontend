import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class CustomTextFieldInt extends StatefulWidget {
  final String text;
  final Function(int value) onChanged;
  final int min;
  final int max;
  CustomTextFieldInt(
    this.text, {
    Key? key,
    this.min = 0,
    this.max = 999999999,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomTextFieldInt> createState() => _CustomTextFieldIntState();
}

class _CustomTextFieldIntState extends State<CustomTextFieldInt> {
  TextEditingController controller = TextEditingController(text: '1');

  int get value => int.parse(controller.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.075,
      height: 100,
      child: Column(
        children: [
          AutoSizeText(widget.text),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: teal.add(black, 0.2),
                border: Border.all(color: teal.add(black, 0.2)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    child: InkWell(
                      onTap: () => widget.onChanged.call(
                        changeValue(value - 1),
                      ),
                      child: Center(
                        child: AutoSizeText(
                          '-',
                          style: TextStyle(color: white),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: white,
                      child: AutoSizeTextField(
                        controller: controller,
                        minFontSize: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => widget.onChanged.call(
                          changeValue(value),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    child: InkWell(
                      onTap: () => widget.onChanged.call(
                        changeValue(value + 1),
                      ),
                      child: Center(
                        child: AutoSizeText(
                          '+',
                          style: TextStyle(color: white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int changeValue(int newValue) {
    setState(() {
      if (newValue < widget.min) {
        newValue = widget.min;
      } else if (newValue > widget.max) {
        newValue = widget.max;
      }
      controller.text = '$newValue';
    });
    return value;
  }
}
