//2025 Version

// ignore: avoid_web_libraries_in_flutter
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/administration/user/userType.dart';
import 'package:guadalajarav2/utils/GeneratePageRoute.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/utils/SuperGlobalVariables/ObjVar.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/Places.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? token;
User? user;
late SharedPreferences prefs;
MyPlace? myPlaceGlobal;

void main() async {
  prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('token')) {
    token = prefs.getString('token');
    user = await getUserFromToken();
    if (user == null) {
      token = null;
      prefs.remove('token');
      user = User(
        type: UserType.guest,
        name: '',
        lastName: '',
        email: '',
        username: '',
        password: '',
        registerDate: '',
      );
    }
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    currentUser.width = MediaQuery.of(context).size.width;
    currentUser.height = MediaQuery.of(context).size.height;
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        fontFamily: 'Nunito',
        // backgroundColor: darkNight,
        colorScheme: ThemeData().colorScheme.copyWith(
              secondary: blue,
              primary: green,
            ),
      ),
      debugShowCheckedModeBanner: false,
      builder: (context, child) => HomePage(
        child: child!,
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: RoutesName.current,
    );
  }
}

class HomePage extends StatelessWidget {
  final Widget child;

  const HomePage({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return MainPage(
      child: child,
    );
  }
}

MainState? mainState;

class MainPage extends StatefulWidget {
  final Widget child;

  const MainPage({
    required this.child,
  });
  @override
  MainState createState() => MainState();
}

class MainState extends State<MainPage> {
  @override
  void initState() {
    super.initState();

    mainState = this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingButton,
      body: Center(
        child: widget.child,
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Widget? floatingButton;

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
//