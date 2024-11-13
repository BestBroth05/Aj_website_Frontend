import 'package:flutter/material.dart';
import 'package:guadalajarav2/alert.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/inventory/addNewComponent.dart';
import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/inventory/editQuantity.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/inventory/enums/enumCurrent.dart';
import 'package:guadalajarav2/inventory/enums/enumFarads.dart';
import 'package:guadalajarav2/inventory/enums/enumHenry.dart';
import 'package:guadalajarav2/inventory/enums/enumMounting.dart';
import 'package:guadalajarav2/inventory/enums/enumOhm.dart';
import 'package:guadalajarav2/inventory/enums/enumTemperature.dart';
import 'package:guadalajarav2/inventory/enums/enumValueUnit.dart';
import 'package:guadalajarav2/inventory/enums/enumVoltage.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/bom_view/bom_header.dart';
import 'package:guadalajarav2/views/dialogs/basic_text_dialog.dart';
import 'package:guadalajarav2/views/inventory_view/inventory_action_button.dart';
import 'package:guadalajarav2/views/inventory_view/inventory_body.dart';
import 'package:guadalajarav2/views/inventory_view/inventory_header.dart';

class InventoryTable extends StatefulWidget {
  final Category category;
  static Map<String, int> header = {};

  InventoryTable({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<InventoryTable> createState() => _InventoryTableState();
}

class _InventoryTableState extends State<InventoryTable> {
  Map<String, dynamic> units = {
    'voltage': VoltageUnit.v,
    'temperature': TemperatureUnit.c,
    'value': ValueUnit.farad.name,
    'farad': FaradsUnit.f,
    'henry': HenryUnit.h,
    'ohm': OhmUnit.ohm,
    'power': 'decimal',
    'voltagereverse': VoltageUnit.v,
    'voltagebreakdown': VoltageUnit.v,
    'voltageclamping': VoltageUnit.v,
    'current': CurrentUnit.a,
  };

  List<bool?> values = List.generate(30, (index) => null);

  double get inventoryWidth => InventoryTable.header.length * 150;

  ScrollController scrollController = ScrollController(initialScrollOffset: 0);
  ScrollController verticalScrollController =
      ScrollController(initialScrollOffset: 0);
  ScrollController actionVerticalController =
      ScrollController(initialScrollOffset: 0);

  @override
  void initState() {
    super.initState();

    verticalScrollController.addListener(() {
      actionVerticalController.jumpTo(verticalScrollController.offset);
    });
    actionVerticalController.addListener(() {
      verticalScrollController.jumpTo(actionVerticalController.offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    units['value'] = widget.category == Category.capacitors
        ? ValueUnit.farad.name
        : widget.category == Category.inductors
            ? ValueUnit.henry.name
            : widget.category == Category.resistors
                ? ValueUnit.ohm.name
                : null;

    Map<String, bool?> headers = InventoryTable.header.map(
      (key, value) {
        int index = InventoryTable.header.keys.toList().indexOf(key);
        return MapEntry(key, values[index]);
      },
    );

    return Row(
      children: [
        Expanded(
          flex: 94,
          child: Scrollbar(
            thumbVisibility: true,
            controller: scrollController,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              child: SizedBox(
                width: inventoryWidth,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InventoryHeader(
                        headers,
                        sortBy: sortBy,
                      ),
                    ),
                    // Expanded(
                    //   flex: 1,
                    //   child: BomHeader(
                    //     InventoryTable.header,
                    //     units: units,
                    //     width: inventoryWidth,
                    //     changesMade: (key, value) => setState(
                    //       () {
                    //         if (key == 'value') {
                    //           units[units[key]] = value;
                    //         } else {
                    //           units[key] = value;
                    //         }
                    //       },
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      flex: 9,
                      child: InventoryBody(
                        units: units,
                        scrollController: verticalScrollController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: white),
                    ),
                  ),
                  child: BomHeader(
                    {'actions': 1},
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: black, width: 2),
                    ),
                  ),
                  child: ListView.builder(
                    controller: actionVerticalController,
                    itemCount: InventoryBody.parts.length,
                    itemBuilder: (context, index) => Container(
                      height: 75,
                      color: index % 2 == 0 ? white : backgroundColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InventoryActionButton(
                            onTap: () => openDialog(
                              context,
                              container: NewComponentScreen(
                                category: widget.category,
                                product: InventoryBody.parts[index],
                                updateParts: (components) => setState(
                                  () => InventoryBody.parts = components,
                                ),
                              ),
                            ),
                            icon: Icon(
                              Icons.edit,
                              size: 20,
                              color: white,
                            ),
                          ),
                          InventoryActionButton(
                            onTap: () => openDialog(
                              context,
                              container: EditQuanity(
                                product: InventoryBody.parts[index],
                                onChanged: (value) => changeQuantity(
                                  InventoryBody.parts[index],
                                  value,
                                ),
                              ),
                            ),
                            icon: Icon(
                              Icons.add,
                              size: 20,
                              color: white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void sortBy(String key, bool? value) {
    print('$key $value');
  }

  void changeQuantity(Product product, int? value) async {
    openDialog(context, container: BasicTextDialog('Loading...'));

    if (value != null) {
      product.quantity = value;
      if (await editQuantityOfComponentInDatabase(product)) {
        Navigator.pop(context);
        Navigator.pop(context);
        containerDialog(
          context,
          true,
          AlertNotification(
              icon: Icons.check_rounded, color: green, str: 'Quantity edited'),
          0.5,
        );
        setState(() {});
      } else {
        Navigator.pop(context);
        containerDialog(
          context,
          true,
          AlertNotification(
              icon: Icons.check_rounded,
              color: red,
              str: 'There was an error\nTry again...'),
          0.5,
        );
      }
    } else {
      Navigator.pop(context);
      containerDialog(
        context,
        true,
        AlertNotification(
            icon: Icons.check_rounded, color: red, str: 'Value Invalid'),
        0.5,
      );
    }
  }
}
