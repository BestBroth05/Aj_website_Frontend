import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/alert.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/inventory/inventoryListView.dart';
import 'package:guadalajarav2/utils/styles.dart';
import 'package:guadalajarav2/utils/tools.dart';

class EditQuanity extends StatefulWidget {
  final Product product;
  final Function(int? value)? onChanged;

  EditQuanity({required this.product, this.onChanged});

  @override
  _EditQuantityState createState() => _EditQuantityState();
}

class _EditQuantityState extends State<EditQuanity> {
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.text = '${widget.product.quantity}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.2,
      height: height * 0.2,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: AutoSizeText(
                  'MPN: ${widget.product.mpn}\nEdit Quantity',
                  textAlign: TextAlign.center,
                  style: subtitleEdit,
                  maxLines: 2,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Divider(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: AutoSizeTextField(
                wrapWords: false,
                controller: controller,
                // expands: true,
                textAlignVertical: TextAlignVertical.center,
                // minLines: null,
                // maxLines: null,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  fillColor: lightGrey,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: backgroundColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: backgroundColor,
                    ),
                  ),
                  focusColor: darkGrey,
                ),
                onSubmitted: (String value) {
                  String equation = value.replaceAll(
                    new RegExp(r"\s+"),
                    "",
                  );
                  int sum = 0;
                  bool isValid = true;
                  for (String s in equation.split('+')) {
                    if (s.contains('-')) {
                      String s1 = s.split('-')[0];
                      int? toAdd = int.tryParse(s1);
                      if (toAdd != null) {
                        sum += toAdd;
                      } else {
                        isValid = false;
                        break;
                      }
                      for (String s2 in s.split('-').sublist(1)) {
                        int? toRest = int.tryParse(s2);
                        if (toRest != null) {
                          sum -= toRest;
                        } else {
                          isValid = false;
                          break;
                        }
                      }
                    } else {
                      int? toAdd = int.tryParse(s);
                      if (toAdd != null) {
                        sum += toAdd;
                      } else {
                        isValid = false;
                        break;
                      }
                    }
                    if (!isValid) {
                      break;
                    }
                  }
                  if (!isValid) {
                    controller.text = '';
                  } else {
                    controller.text = '$sum';
                  }
                },
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: ElevatedButton(
                        child: Text('Confirm'),
                        onPressed: widget.onChanged != null
                            ? () => widget.onChanged!.call(
                                  int.tryParse(controller.text),
                                )
                            : null,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
