import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/views/contact_view/contact_email/contact_email_container.dart';
import 'package:guadalajarav2/views/contact_view/contact_info.dart';
import 'package:guadalajarav2/views/footer/footer.dart';
import 'package:guadalajarav2/views/main_top_bar.dart/main_top_bar.dart';

class ContactContainer extends StatelessWidget {
  ContactContainer({Key? key}) : super(key: key);

  final TextStyle style = TextStyle(fontSize: 15);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Column(
        children: [
          MainTopBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: height * 0.7,
                    color: white,
                    padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 100.0,
                              vertical: 50,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  'Contact Us',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 37.5,
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/qr_contact.png',
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 70,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SelectableText(
                                                'AJ Electronic Design',
                                                style: style,
                                              ),
                                              SelectableText(
                                                contactInfo['address']!,
                                                style: style,
                                              ),
                                              SelectableText(
                                                contactInfo['phone']!,
                                                style: style,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () => openLink(
                                            context,
                                            'https://g.page/AJElectronicDesign?share',
                                            newWindow: true,
                                          ),
                                          child: Image.asset(
                                            'assets/images/map.png',
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: ContactEmailContainer(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
