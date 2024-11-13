import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class BannerSlider extends StatefulWidget {
  final int value;
  final int amount;
  final void Function(int value)? onClick;
  BannerSlider({
    Key? key,
    this.onClick,
    this.value = 0,
    this.amount = 4,
  }) : super(key: key);

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.5,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: height * 0.0125),
          child: Container(
            height: height * 0.05,
            width: width * 0.175,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                widget.amount,
                (index) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: width * 0.025,
                  height: height * 0.01,
                  child: Theme(
                    data: ThemeData(
                      colorScheme: ThemeData().colorScheme.copyWith(
                            primary: blue,
                          ),
                    ),
                    child: TextButton(
                      child: Container(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: widget.value == index
                            ? blue
                            : black.withOpacity(0.15),
                      ),
                      onPressed: widget.onClick != null
                          ? () => widget.onClick!.call(index)
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
