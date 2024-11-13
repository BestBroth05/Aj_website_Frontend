import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tag extends Widget {
  final String? img;
  final VoidCallback? onTap;
  const Tag({
    Key? key,
    this.img,
    this.onTap,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        child: FittedBox(
          child: Container(
            margin: EdgeInsets.only(right: 6, bottom: 6),
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Image(
              image: AssetImage(img!),
              height: 150,
              width: 150,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Element createElement() {
    // TODO: implement createElement
    throw UnimplementedError();
  }
}
