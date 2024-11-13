import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/enums/social_media.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/views/contact_view/contact_info.dart';
import 'package:guadalajarav2/views/dialogs/privacy_dialog.dart';
import 'package:guadalajarav2/views/footer/footer_column.dart';
import 'package:guadalajarav2/views/footer/footer_row.dart';

class Footer extends StatefulWidget {
  Footer({
    Key? key,
  }) : super(key: key);

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  List<String> get urlsSocialMedia => [
        SocialMedia.facebook.url + 'AJElectronicDesign/',
        SocialMedia.instagram.url + 'aj.electronic.design',
        'http://www.linkedin.com/company/aj-electronic-design/'
      ];

  List<String> get contact => [
        contactInfo['email']!,
        contactInfo['phone']!,
      ];

  List<AJRoute> get urlsAJ => [
        AJRoute.home,
        AJRoute.services,
        AJRoute.contact,
        AJRoute.login,
        AJRoute.privacy,
      ];
  List<IconData> get icons => [
        Icons.email_rounded,
        Icons.phone_rounded,
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.2,
      width: width,
      color: teal.add(black, 0.5),
      // color: black.add(teal, 0.6),
      padding: EdgeInsets.symmetric(
        vertical: height * 0.02,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: FooterColumn(
              items: urlsAJ,
              onClick: (index) {
                if (index == urlsAJ.length - 1) {
                  openDialog(
                    context,
                    container: PrivacyDialog(privacy_url),
                  );
                } else {
                  openLink(context, urlsAJ[index].url, isRoute: true);
                }
              },
            ),
          ),
          // Expanded(
          //   // child: FooterColumn(
          //   //   title: 'nuestros clientes',
          //   //   items: ['BOSCH', 'EMED', 'MABE'],
          //   // ),
          //   child: Container(),
          // ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: width * 0.4,
              height: height,
              child: FooterRow(
                title: 'aj electronic design sa de cv',
                // items: ['BOSCH', 'EMED', 'MABE'],
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: contact.map(
                          (e) {
                            int index = contact.indexOf(e);
                            return Expanded(
                              child: InkWell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AutoSizeText(
                                      e,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(color: white),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(icons[index], color: white, size: 20)
                                  ],
                                ),
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: e,
                                    ),
                                  );
                                  showToast(
                                    context,
                                    text: 'Copied to clipboard',
                                    icon: Icons.copy,
                                  );
                                },
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7.5),
                    child: Container(
                      width: 2,
                      height: height * 0.075,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            white.withOpacity(0),
                            white.withOpacity(0.5),
                            white.withOpacity(0)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => openLink(
                        context,
                        'https://g.page/AJElectronicDesign?share',
                        newTab: true,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on_rounded,
                              color: white, size: 20),
                          SizedBox(width: 5),
                          Expanded(
                            child: AutoSizeText(
                              contactInfo['address']!,
                              style: TextStyle(color: white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: width * 0.25,
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FooterRow(
                      title: 'Social Media',
                      children: SocialMedia.values
                          .map(
                            (sm) => Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.005),
                              child: IconButton(
                                onPressed: () => openLink(
                                  context,
                                  urlsSocialMedia[
                                      SocialMedia.values.indexOf(sm)],
                                  newTab: true,
                                ),
                                padding: EdgeInsets.zero,
                                icon: Container(
                                  width: 30,
                                  height: 30,
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: white),
                                  ),
                                  child: Image.asset(
                                    sm.imageURL,
                                    color: white,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onClick: (index) => openLink(
                        context,
                        urlsSocialMedia[index],
                        newTab: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.025),
                    child: AutoSizeText(
                      '© AJ Electronic Design SA.de CV. All rights reserved',
                      style: TextStyle(color: white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
