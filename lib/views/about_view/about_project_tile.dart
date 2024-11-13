import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';

class AboutProjectTile extends StatefulWidget {
  final ImageProvider image;
  final VoidCallback onTap;
  final int likes;
  final bool liked;
  AboutProjectTile(
    this.image, {
    Key? key,
    this.liked = false,
    required this.onTap,
    this.likes = 0,
  }) : super(key: key);

  @override
  State<AboutProjectTile> createState() => _AboutProjectTileState();
}

class _AboutProjectTileState extends State<AboutProjectTile> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (value) => setState(
        () => isHovering = value,
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: widget.image,
          ),
        ),
        child: Container(
          color: isHovering ? black.withOpacity(0.4) : null,
          padding: EdgeInsets.all(20),
          child: isHovering
              ? Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          widget.liked
                              ? Icons.favorite
                              : Icons.favorite_outline_rounded,
                          color: white,
                        ),
                        onPressed: widget.onTap,
                      ),
                      AutoSizeText(
                        '${widget.likes} likes',
                        style: TextStyle(
                          color: white,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ),
      ),
    );
  }
}
