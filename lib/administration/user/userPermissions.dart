import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/utils/GeneratePageRoute.dart';

enum UserPermission {
  viewInventory,
  viewUsers,
  viewProjects,
}

extension UserPermissionsExtension on UserPermission {
  String get name {
    return this.toString().split('.')[1];
  }

  List<String> get routes {
    List<String> _routes = [AJRoute.dashboard.url];

    switch (this) {
      case UserPermission.viewInventory:
        _routes += [AJRoute.inventory.url];
        break;
      case UserPermission.viewUsers:
        _routes += [RoutesName.ADMIN];
        break;
      case UserPermission.viewProjects:
        _routes += [RoutesName.PROJECTS];
        break;
    }
    return _routes;
  }
}
