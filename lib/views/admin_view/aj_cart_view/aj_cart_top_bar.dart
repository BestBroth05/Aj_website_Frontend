import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/bom_part.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/utils/bom_handler.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/views/admin_view/admin_view.dart';
import 'package:guadalajarav2/views/admin_view/aj_cart_view/aj_cart_view.dart';
import 'package:guadalajarav2/views/bom_view/bom_filter_button.dart';
import 'package:guadalajarav2/views/bom_view/bom_selection_dialog.dart';
import 'package:guadalajarav2/views/bom_view/bom_view.dart';
import 'package:guadalajarav2/views/dialogs/basic_text_dialog.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';
import 'package:guadalajarav2/widgets/custom/custom_switch.dart';
import 'package:guadalajarav2/widgets/custom/custom_text_field_int.dart';

class AJCartTopBar extends StatefulWidget {
  final bool onlyMissingParts;
  final VoidCallback uploadFunction;
  final Function(bool newValue) missingPartsFilter;
  final Function(int value) requiredTimesFunct;
  final VoidCallback? exportFunction;
  final VoidCallback? continueFunction;

  AJCartTopBar({
    Key? key,
    required this.uploadFunction,
    required this.exportFunction,
    required this.missingPartsFilter,
    required this.onlyMissingParts,
    required this.continueFunction,
    required this.requiredTimesFunct,
  }) : super(key: key);

  @override
  State<AJCartTopBar> createState() => _AJCartTopBarState();
}

class _AJCartTopBarState extends State<AJCartTopBar> {
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
                onPressed: () => openLink(
                  context,
                  AJRoute.admin.url,
                  isRoute: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.025),
                child: CustomButton(
                  text: 'Upload File',
                  color: teal.add(black, 0.3),
                  onPressed: widget.uploadFunction,
                ),
              ),
            ],
          ),
          CustomButton(
            text: 'Continue',
            color: teal.add(black, 0.3),
            onPressed: widget.continueFunction,
          ),
        ],
      ),
    );
  }
}
