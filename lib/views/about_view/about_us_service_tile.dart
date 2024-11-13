import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';

class AboutUsServiceTile extends StatefulWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;
  AboutUsServiceTile(
    this.title, {
    Key? key,
    required this.onTap,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<AboutUsServiceTile> createState() => _AboutUsServiceTileState();
}

class _AboutUsServiceTileState extends State<AboutUsServiceTile> {
  double size = 150;

  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (value) => setState(() => isHovering = value),
      child: Container(
        height: size,
        width: size,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: white,
          boxShadow: [
            BoxShadow(
              color: teal.add(black, isHovering ? 0.3 : 0.7).withOpacity(0.4),
              blurRadius: isHovering ? 10 : 5,
              spreadRadius: isHovering ? 0.5 : 0.25,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AutoSizeText(
              widget.title.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset(
              'assets/images/' + widget.imagePath + '.png',
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
