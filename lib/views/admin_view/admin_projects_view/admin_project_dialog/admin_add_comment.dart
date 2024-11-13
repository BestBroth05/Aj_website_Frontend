import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class AdminAddComment extends StatefulWidget {
  final int projectId;
  final void Function(int projectId, String comment) addCommentFunct;

  AdminAddComment({
    Key? key,
    required this.projectId,
    required this.addCommentFunct,
  }) : super(key: key);

  @override
  State<AdminAddComment> createState() => _AdminAddCommentState();
}

class _AdminAddCommentState extends State<AdminAddComment> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(children: [
        Expanded(
          child: Container(
            height: 75,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: gray),
              borderRadius: BorderRadius.circular(15),
            ),
            child: AutoSizeTextField(
              expands: true,
              maxLines: null,
              minLines: null,
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter comment here...',
                hintStyle: TextStyle(fontStyle: FontStyle.italic),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CustomButton(
            height: 75,
            width: 50,
            // text: 'Send',
            icon: Icons.send,
            onPressed: controller.text.isEmpty
                ? null
                : () {
                    widget.addCommentFunct.call(
                      widget.projectId,
                      controller.text,
                    );
                    controller.clear();
                  },
          ),
        ),
      ]),
    );
  }
}
