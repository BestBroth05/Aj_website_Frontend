import 'package:flutter/material.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

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
