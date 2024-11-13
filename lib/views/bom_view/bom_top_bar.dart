import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/bom_part.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/utils/bom_handler.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/views/bom_view/bom_filter_button.dart';
import 'package:guadalajarav2/views/bom_view/bom_selection_dialog.dart';
import 'package:guadalajarav2/views/bom_view/bom_view.dart';
import 'package:guadalajarav2/views/dialogs/basic_text_dialog.dart';
import 'package:guadalajarav2/views/dialogs/timed_dialog.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';
import 'package:guadalajarav2/widgets/custom/custom_switch.dart';
import 'package:guadalajarav2/widgets/custom/custom_text_field_int.dart';

class BomTopBar extends StatefulWidget {
  final bool onlyMissingParts;
  final Function(bool newValue) missingPartsFilter;
  final VoidCallback? exportFunction;
  final VoidCallback? continueFunction;
  final VoidCallback updateFunction;

  BomTopBar({
    Key? key,
    required this.exportFunction,
    required this.missingPartsFilter,
    required this.onlyMissingParts,
    required this.continueFunction,
    required this.updateFunction,
  }) : super(key: key);

  @override
  State<BomTopBar> createState() => _BomTopBarState();
}

class _BomTopBarState extends State<BomTopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.075,
      color: white,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomButton(
                text: 'Return',
                color: teal.add(black, 0.3),
                onPressed: () =>
                    openLink(context, AJRoute.inventory.url, isRoute: true),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.025),
                child: CustomButton(
                  text: 'Upload File',
                  color: teal.add(black, 0.3),
                  onPressed: () {
                    openDialog(
                      context,
                      container: BomSelectionDialog(
                        updateFunction: widget.updateFunction,
                      ),
                      block: true,
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: width * 0.025),
                child: CustomButton(
                  text: 'Export File',
                  color: teal.add(black, 0.3),
                  onPressed: widget.exportFunction,
                ),
              ),
              CustomSwitch(
                text: 'Only missing',
                value: widget.onlyMissingParts,
                onChanged: widget.missingPartsFilter,
              ),
            ],
          ),
          Row(
            children: [
              // CustomTextFieldInt(
              //   'Required times',
              //   onChanged: widget.requiredTimesFunct,
              //   min: 1,
              // ),
              SizedBox(width: width * 0.075),
              CustomButton(
                text: 'Continue',
                color: teal.add(black, 0.3),
                onPressed: widget.continueFunction,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
