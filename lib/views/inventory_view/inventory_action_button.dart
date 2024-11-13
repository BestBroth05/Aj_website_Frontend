import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';

class InventoryActionButton extends StatefulWidget {
  final VoidCallback onTap;
  final Widget icon;
  InventoryActionButton({
    Key? key,
    required this.onTap,
    this.icon = const Icon(Icons.edit),
  }) : super(key: key);

  @override
  _InventoryActionButtonState createState() => _InventoryActionButtonState();
}

class _InventoryActionButtonState extends State<InventoryActionButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: 25,
        height: 25,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: gray,
          borderRadius: BorderRadius.circular(5),
        ),
        child: widget.icon,
      ),
    );
  }
}
