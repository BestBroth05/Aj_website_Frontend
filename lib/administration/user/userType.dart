import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/utils/tools.dart';

enum UserType {
  admin,
  employee,
  client,
  guest,
}

extension UserTypeExtension on UserType {
  String get name {
    return toTitle(this.toString().split('.')[1]);
  }

  List<AJRoute> get permittedRoutes {
    List<AJRoute> routes = [
      AJRoute.home,
      AJRoute.about,
      AJRoute.login,
      AJRoute.contact,
      AJRoute.privacy,
      AJRoute.services,
      AJRoute.software,
      AJRoute.hardware,
      AJRoute.firmware,
      AJRoute.industrial,
      AJRoute.manufacture,
      AJRoute.notFound,
    ];
    switch (this) {
      case UserType.admin:
        routes.addAll(AJRoute.values);
        break;
      case UserType.employee:
        routes.addAll([
          AJRoute.bom,
          AJRoute.dashboard,
          AJRoute.inventory,
          AJRoute.projects,
        ]);
        break;
      case UserType.client:
        routes.addAll([
          AJRoute.projects,
        ]);
        break;
      case UserType.guest:
        break;
    }

    return routes;
  }
}
