import 'package:auto_size_text/auto_size_text.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/utils/bom_handler.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/excel_handler.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/views/bom_view/bom_view.dart';
import 'package:guadalajarav2/views/dialogs/basic_text_dialog.dart';
import 'package:guadalajarav2/views/dialogs/loading_dialog.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class BomSelectionDialog extends StatefulWidget {
  static Map<int, Map<String, dynamic>?> boms = {0: null};
  static Map<int, TextEditingController> controllers = {
    0: TextEditingController(text: '1'),
  };
  final VoidCallback updateFunction;
  BomSelectionDialog({
    Key? key,
    required this.updateFunction,
  }) : super(key: key);

  @override
  State<BomSelectionDialog> createState() => _BomSelectionDialogState();
}

class _BomSelectionDialogState extends State<BomSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      width: width * 0.3,
      height: height * 0.2 + 70 * BomSelectionDialog.boms.length,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: white,
      ),
      padding: EdgeInsets.symmetric(vertical: 25),
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: width * 0.15,
                        alignment: Alignment.center,
                        child: AutoSizeText('File name'),
                      ),
                      Container(
                        width: 70,
                        alignment: Alignment.center,
                        child: AutoSizeText('Times'),
                      ),
                      Container(
                        width: width * 0.0125,
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                  Column(
                    children: BomSelectionDialog.boms.entries
                        .map(
                          (e) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: _BomRow(
                              e.value,
                              controller:
                                  BomSelectionDialog.controllers[e.key]!,
                              deleteRow: () => setState(
                                () {
                                  BomSelectionDialog.boms.remove(e.key);
                                  BomSelectionDialog.controllers.remove(e.key);
                                  if (BomSelectionDialog.boms.length == 0) {
                                    BomSelectionDialog.boms[0] = null;
                                    BomSelectionDialog.controllers[0] =
                                        TextEditingController(text: '1');
                                  }
                                },
                              ),
                              uploadFile: () async {
                                FilePickerResult? file = await pickFile();
                                if (file != null) {
                                  setState(() {
                                    BomSelectionDialog.boms[e.key] = {
                                      'key': e.key,
                                      'name': file.names[0],
                                      'times': 1,
                                      'data': file.files.single.bytes!
                                    };
                                  });
                                }
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomButton(
                text: 'Cancel',
                onPressed: () => Navigator.pop(context),
                textColor: gray.add(black, 0.5),
                color: backgroundColor,
              ),
              CustomButton(
                text: 'Add new BOM',
                height: 50,
                width: width * 0.05,
                color: blue,
                onPressed: () => setState(
                  () {
                    for (int i = 0;
                        i < BomSelectionDialog.boms.length + 1;
                        i++) {
                      if (BomSelectionDialog.boms.containsKey(i)) {
                        continue;
                      } else {
                        BomSelectionDialog.boms[i] = null;
                        BomSelectionDialog.controllers[i] =
                            TextEditingController(text: '1');
                        break;
                      }
                    }
                  },
                ),
              ),
              CustomButton(
                text: 'Update',
                onPressed: widget.updateFunction,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _BomRow extends StatefulWidget {
  final Map<String, dynamic>? bom;
  final VoidCallback uploadFile;
  final VoidCallback deleteRow;
  final TextEditingController controller;

  _BomRow(
    this.bom, {
    Key? key,
    required this.controller,
    required this.uploadFile,
    required this.deleteRow,
  }) : super(key: key);

  @override
  State<_BomRow> createState() => __BomStateRow();
}

class __BomStateRow extends State<_BomRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomButton(
            height: 50,
            text: widget.bom != null
                ? widget.bom!['name']
                : 'Click to upload file',
            textColor: gray.add(black, 0.5),
            width: width * 0.15,
            color: backgroundColor.add(black, 0.1),
            onPressed: widget.uploadFile,
          ),
          _BomTimesTextField(widget.controller),
          CustomButton(
            height: 50,
            icon: Icons.delete,
            textColor: gray.add(black, 0.5),
            width: width * 0.0125,
            color: backgroundColor.add(black, 0.1),
            onPressed: widget.deleteRow,
          ),
        ],
      ),
    );
  }
}

class _BomTimesTextField extends StatefulWidget {
  final TextEditingController controller;
  _BomTimesTextField(this.controller, {Key? key}) : super(key: key);

  @override
  State<_BomTimesTextField> createState() => __BomTimesTextFieldState();
}

class __BomTimesTextFieldState extends State<_BomTimesTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: backgroundColor.add(black, 0.1),
      ),
      child: TextField(
        controller: widget.controller,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }
}
