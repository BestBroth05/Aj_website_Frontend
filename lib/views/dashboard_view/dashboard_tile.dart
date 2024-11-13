import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';

class DashboardTile extends StatefulWidget {
  final double height;
  final double width;
  final double? heightEnlarged;
  final Color backgroundColor;
  final Widget primaryWidget;
  final Widget? enlargedWidget;
  DashboardTile({
    Key? key,
    required this.primaryWidget,
    this.enlargedWidget,
    this.height = 100,
    this.heightEnlarged,
    this.width = 100,
    this.backgroundColor = Colors.red,
  }) : super(key: key);

  @override
  _DashboardTileState createState() => _DashboardTileState();
}

class _DashboardTileState extends State<DashboardTile> {
  bool isEnlarged = false;

  double get enlargedHeight =>
      widget.heightEnlarged != null ? widget.heightEnlarged! : widget.height;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: isEnlarged ? enlargedHeight + widget.height : widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(4.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Column(
          children: [
            widget.enlargedWidget == null || !isEnlarged
                ? Expanded(child: widget.primaryWidget)
                : widget.primaryWidget,
            widget.enlargedWidget != null && isEnlarged
                ? Expanded(
                    child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: widget.enlargedWidget!,
                  ))
                : Container(),
            TextButton(
              child: Icon(
                isEnlarged ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: widget.backgroundColor == white ? black : white,
              ),
              onPressed: () => setState(
                () => isEnlarged = !isEnlarged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
