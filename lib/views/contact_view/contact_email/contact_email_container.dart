import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/email_handler.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/views/contact_view/contact_email/contact_text_field.dart';
import 'package:guadalajarav2/views/contact_view/contact_container.dart';
import 'package:guadalajarav2/views/dialogs/sending_email.dart';
import 'package:guadalajarav2/views/dialogs/timed_dialog.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class ContactEmailContainer extends StatefulWidget {
  ContactEmailContainer({Key? key}) : super(key: key);

  @override
  State<ContactEmailContainer> createState() => _ContactEmailContainerState();
}

class _ContactEmailContainerState extends State<ContactEmailContainer> {
  TextEditingController nameController = TextEditingController(
      // text: 'Sebastian Woolfolk',
      );
  TextEditingController emailController = TextEditingController(
      // text: 'sebastian.woolfolk',
      );
  TextEditingController phoneController = TextEditingController(
      // text: 'sebastian.woolfolk',
      );
  TextEditingController textController = TextEditingController(
      // text: 'hi, please send info',
      );

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ContactTextField(nameController, text: 'Name *'),
      ),
      Expanded(
        child: Row(
          children: [
            Expanded(
              child: ContactTextField(
                emailController,
                text: 'Email *',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ContactTextField(phoneController, text: 'Phone'),
            )
          ],
        ),
      ),
      Expanded(
        flex: 3,
        child: ContactTextField(
          textController,
          text: 'Message *',
          expands: true,
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: CustomButton(
            text: 'Send',
            color: teal.add(black, 0.2),
            onPressed: () async {
              if (verifyTextfields()) {
                openDialog(context, container: SendingEmailDialog());
                bool sended = await sendEmail(
                  email: emailController.text,
                  name: nameController.text,
                  text: textController.text,
                  phone: phoneController.text,
                );
                Navigator.pop(context);
                if (sended) {
                  openDialog(
                    context,
                    container: TimedDialog(
                      text:
                          'Thank you for contacting us\nSoon someone will be in touch with you',
                    ),
                  );
                } else {
                  openDialog(
                    context,
                    container: TimedDialog(
                      text:
                          'There was a problem sending the message.\nSorry for the inconvenience',
                    ),
                  );
                }
              } else {
                openDialog(
                  context,
                  container: TimedDialog(
                    text: 'Please provide a Name, Email and a Message',
                  ),
                );
              }
            },
          ),
        ),
      ),
    ]);
  }

  bool verifyTextfields() {
    List<TextEditingController> controllers = [
      nameController,
      emailController,
      textController,
    ];

    for (TextEditingController controller in controllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }

    return true;
  }
}
