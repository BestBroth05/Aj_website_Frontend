import 'package:flutter/material.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/views/main_top_bar.dart/main_top_bar_button.dart';

class MainTopBar extends StatefulWidget {
  MainTopBar({Key? key}) : super(key: key);

  @override
  State<MainTopBar> createState() => _MainTopBarState();
}

class _MainTopBarState extends State<MainTopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.1,
      decoration: BoxDecoration(
        color: white,
        border: Border(
          bottom: BorderSide(
            color: green,
          ),
        ),
      ),
      child: Row(
        children: [
          //   ShaderMask(
          //     blendMode: BlendMode.color,
          //     shaderCallback: (bounds) =>
          //         LinearGradient(colors: [teal, teal]).createShader(bounds),
          //     child: Image.asset(
          //       'assets/images/AJletras.png',
          //       color: white,
          //     ),
          //   ),
          Container(
            height: height,
            width: width * 0.1,
            padding: EdgeInsets.all(5),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: height * 0.02,
              splashRadius: height * 0.01,
              icon: Image.asset('assets/images/logo.png'),
              onPressed: () => openLink(context, main_url),
            ),

            // child: CustomButton(
            //   text: 'Upload BOM',
            //   onPressed: () async {},
            // ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MainTopBarButton(text: 'Home', route: AJRoute.home),
                MainTopBarButton(text: 'Our Services', route: AJRoute.services),
                MainTopBarButton(text: 'Contact', route: AJRoute.contact),
                MainTopBarButton(text: 'Privacy', downloadLink: privacy_url),
                MainTopBarButton(
                  text: 'Log In',
                  route: AJRoute.login,
                  icon: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child:
                        Icon(Icons.person_outline, color: teal.add(black, 0.2)),
                  ),
                ),
                // MainTopBarButton(text: 'Log in', route: AJRoute.login),
              ],
            ),
          ),

          SizedBox(width: width * 0.1),
        ],
      ),
    );
  }
}
