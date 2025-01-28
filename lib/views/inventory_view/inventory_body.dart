import 'package:flutter/material.dart';
import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/views/inventory_view/inventory_part_tile.dart';

class InventoryBody extends StatefulWidget {
  final ScrollController scrollController;
  final Map<String, dynamic> units;

  static List<Product> parts = [];

  InventoryBody({
    Key? key,
    required this.scrollController,
    required this.units,
  }) : super(key: key);

  @override
  State<InventoryBody> createState() => _InventoryBodyState();
}

class _InventoryBodyState extends State<InventoryBody> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      itemCount: InventoryBody.parts.length,
      itemBuilder: (context, index) => InventoryPartTile(
        InventoryBody.parts[index],
        isOdd: index % 2 != 0,
        units: widget.units,
        updateParts: (components) => setState(
          () => InventoryBody.parts = components,
        ),
      ),
    );
  }
}
