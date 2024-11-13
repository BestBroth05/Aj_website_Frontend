import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/administration/user/userType.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/main.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/views/footer/footer.dart';
import 'package:guadalajarav2/views/login/loginController.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/login/login_background.dart';
import 'package:guadalajarav2/views/login/login_text_field.dart';
import 'package:guadalajarav2/views/main_top_bar.dart/main_top_bar.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  TextEditingController userController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool willRemember = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Container(
          //   width: width * 0.95,
          //   height: height * 0.95,
          //   child: Card(
          //     elevation: 5,
          //     child: LoginMinimalist(),
          //   ),
          // ),
          MainTopBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.7,
                    child: Row(
                      children: [
                        Expanded(flex: 4, child: LoginBackground()),
                        // Expanded(
                        //   flex: 2,
                        //   child: Padding(
                        //     padding:
                        //         EdgeInsets.symmetric(horizontal: width * 0.025),
                        //     child: Image.asset('assets/images/logo.png'),
                        //   ),
                        // ),
                        // Container(
                        //   width: width * 0.001,
                        //   height: height * 0.5,
                        //   decoration: BoxDecoration(gradient: fadedVertical),
                        // ),
                        Expanded(
                          flex: 6,
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(vertical: height * 0.1),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.175),
                              child: Column(
                                children: [
                                  AutoSizeText(
                                    'Welcome',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: teal.add(black, 0.2),
                                      fontSize: height * 0.05,
                                    ),
                                    minFontSize: 10,
                                    maxLines: 2,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: height * 0.1,
                                      bottom: height * 0.025,
                                    ),
                                    child: LoginTextField(
                                      title: 'Username',
                                      controller: userController,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: height * 0.025,
                                      bottom: height * 0.05,
                                    ),
                                    child: LoginTextField(
                                      title: 'Password',
                                      controller: passwordController,
                                      isSecret: true,
                                      onEnter: (_) async {
                                        if (await login(
                                          context,
                                          userController.text,
                                          passwordController.text,
                                        )) {
                                          openLink(
                                            context,
                                            user!.type == UserType.employee ||
                                                    user!.type == UserType.admin
                                                ? AJRoute.dashboard.url
                                                : AJRoute.projects.url,
                                            isRoute: true,
                                          );
                                        } else {}
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.025),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // CustomButton(
                                        //   text: 'Return',
                                        //   elevated: true,
                                        //   color: white,
                                        //   textColor: gray.add(black, 0.2),
                                        //   onPressed: () => openLink(
                                        //     context,
                                        //     AJRoute.home.url,
                                        //     isRoute: true,
                                        //   ),
                                        // ),
                                        Expanded(
                                          child: CustomButton(
                                            text: 'Log in',
                                            elevated: true,
                                            onPressed: () async {
                                              if (await login(
                                                context,
                                                userController.text,
                                                passwordController.text,
                                              )) {
                                                openLink(
                                                  context,
                                                  user!.type ==
                                                              UserType
                                                                  .employee ||
                                                          user!.type ==
                                                              UserType.admin
                                                      ? AJRoute.dashboard.url
                                                      : AJRoute.projects.url,
                                                  isRoute: true,
                                                );
                                              } else {}
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
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
