import 'package:flutter/material.dart';
import 'package:guadalajarav2/administration/user/userType.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/views/login/loginScreen.dart';
import 'package:guadalajarav2/main.dart';

class RoutesName {
  static const String PROJECTS = '/Projects';
  // ignore: non_constant_identifier_names
  static const String FINANCE = '/Finance';
  // ignore: non_constant_identifier_names
  static const String ADMIN = '/Administration';

  static String current = AJRoute.home.url;

  static String getCurrent() {
    if (current == AJRoute.login.url) {
      return current;
    } else {
      String toReturn = current.substring(1);
      return toReturn;
    }
  }

  static List<String> getMainMenuRoutes() {
    return [
      AJRoute.dashboard.url,
      //AJRoute.arquiurbus.url,
      AJRoute.inventory.url,
      AJRoute.admin.url,
      AJRoute.bom.url,
      AJRoute.bom.url,
      AJRoute.dashboard.url,
      AJRoute.inventory.url,
      AJRoute.projects.url,
      AJRoute.admin.url,
      AJRoute.adminCart.url,
      AJRoute.adminProjects.url,
      AJRoute.adminUsers.url,
    ];
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (token == null &&
        RoutesName.getMainMenuRoutes().contains(settings.name)) {
      return _GeneratePageRoute(
        widget: LoginScreen(),
        routeName: AJRoute.login.url,
      );
    } else {
      Widget widget = Container();

      RoutesName.current = settings.name!;

      List<AJRoute> permittedRoutes = [];

      if (user == null) {
        permittedRoutes = UserType.guest.permittedRoutes;
      } else {
        permittedRoutes = user!.type.permittedRoutes;
      }
      bool found = false;
      AJRoute? route;
      for (AJRoute r in AJRoute.values) {
        if (r.url == settings.name) {
          found = true;
          if (permittedRoutes.contains(r)) {
            route = r;
          }
          break;
        }
      }

      if (found) {
        if (route == null) {
          route = AJRoute.notPermitted;
        }
      } else {
        route = AJRoute.notFound;
      }

      if (route == AJRoute.login && user != null && token != null) {
        if (user!.type == UserType.admin || user!.type == UserType.employee) {
          route = AJRoute.dashboard;
        } else {
          route = AJRoute.projects;
        }
      }
      widget = route.view;
      RoutesName.current = route.url;

      return _GeneratePageRoute(widget: widget, routeName: RoutesName.current);
    }
  }
}

class _GeneratePageRoute extends PageRouteBuilder {
  final Widget widget;
  final String routeName;
  _GeneratePageRoute({required this.widget, required this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          // transitionDuration: Duration(milliseconds: 500),
          // transitionsBuilder: (BuildContext context,
          //     Animation<double> animation,
          //     Animation<double> secondaryAnimation,
          //     Widget child) {
          //   return SlideTransition(
          //     textDirection: TextDirection.rtl,
          //     position: Tween<Offset>(
          //       begin: Offset(1.0, 0.0),
          //       end: Offset.zero,
          //     ).animate(animation),
          //     child: child,
          //   );
          // },
        );
}
