import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<T?> showTextDialog<T>(BuildContext context,
        {required String title, required String value}) =>
    showDialog<T>(
        context: context,
        builder: (context) => TextDialogWidget(title: title, value: value));

class TextDialogWidget extends StatefulWidget {
  final String title;
  final String value;
  TextDialogWidget({super.key, required this.title, required this.value});

  @override
  State<TextDialogWidget> createState() => _TextDialogWidgetState();
}

class _TextDialogWidgetState extends State<TextDialogWidget> {
  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.title),
        content: widget.title == "Descripcion"
            ? TextField(
                controller: controller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(border: OutlineInputBorder()),
              )
            : TextField(
                controller: controller,
                decoration: InputDecoration(border: OutlineInputBorder()),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ]),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: Text("Done"))
        ],
      );
}
