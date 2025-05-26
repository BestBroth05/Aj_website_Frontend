import 'package:flutter/material.dart';
import 'package:guadalajarav2/administration/user/userType.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/main.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/views/footer/footer.dart';
import 'package:guadalajarav2/views/login/loginController.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/login/login_background.dart';
import 'package:guadalajarav2/views/login/login_text_field.dart';
import 'package:guadalajarav2/views/main_top_bar.dart/main_top_bar.dart';

import '../ArquiurbusDemo/Dashboard_ab100.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  TextEditingController userController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool willRemember = false;

  Future onPressedAction() async {
    if (await login(
      context,
      userController.text,
      passwordController.text,
    )) {
      if (userController.text == "Arquiurbus" &&
          passwordController.text == "ab100") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DashboardAb100()));
      } else {
        openLink(
          context,
          user!.type == UserType.employee || user!.type == UserType.admin
              ? AJRoute.dashboard.url
              : AJRoute.projects.url,
          isRoute: true,
        );
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MainTopBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.7,
                    child: Row(
                      children: [
                        Expanded(flex: 1, child: LoginBackground()),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Headline
                              Text(
                                '',
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    //Headline
                                    Text(
                                      '¡Welcome!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: teal.add(black, 0.2),
                                        fontSize: height * 0.05,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    //Form
                                    LoginTextField(
                                      title: 'Username',
                                      controller: userController,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    LoginTextField(
                                      title: 'Password',
                                      controller: passwordController,
                                      isSecret: true,
                                      onEnter: (_) async {
                                        if (await login(
                                          context,
                                          userController.text,
                                          passwordController.text,
                                        )) {
                                          if (userController.text ==
                                                  "Arquiurbus" &&
                                              passwordController.text ==
                                                  "ab100") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DashboardAb100()));
                                          } else {
                                            openLink(
                                              context,
                                              user!.type == UserType.employee ||
                                                      user!.type ==
                                                          UserType.admin
                                                  ? AJRoute.dashboard.url
                                                  : AJRoute.projects.url,
                                              isRoute: true,
                                            );
                                          }
                                        } else {}
                                      },
                                    ),

                                    //Button Login
                                    SizedBox(height: 20),
                                    buttonLogin()
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 40),
                                child: Text(
                                  '',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
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

  Widget buttonLogin() {
    return ElevatedButton(
      onPressed: () async =>
          await onPressedAction(), // Ejecutar la función pasada como parámetro
      style: ElevatedButton.styleFrom(
        minimumSize: Size(320, 44),
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal, // Color del texto
        //elevation: elevation, // Sombra
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            5.0,
          ), // Bordes redondeados
        ),
        padding: EdgeInsets.symmetric(
          vertical: 16.0, // Padding vertical
          horizontal: 32.0, // Padding horizontal
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Log in',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ), // El texto que se pasa al botón
        ],
      ),
    );
  }
}
