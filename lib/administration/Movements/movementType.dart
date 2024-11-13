import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/tools.dart';

enum MovementGType { users, inventory }

extension MovementGExtension on MovementGType {
  String get name {
    return toTitle(this.toString().split('.')[1]);
  }

  List<MovementType> get subTypes {
    List<MovementType> types = [];

    switch (this) {
      case MovementGType.users:
        types = MovementType.values.sublist(0, 3);
        break;
      case MovementGType.inventory:
        types = MovementType.values.sublist(3);
        break;
    }

    return types;
  }

  IconData get icon {
    switch (this) {
      case MovementGType.users:
        return Icons.supervised_user_circle_rounded;
      case MovementGType.inventory:
        return Icons.inventory_2_rounded;
    }
  }
}

enum MovementType {
  addedUser,
  editedUser,
  deletedUser,
  addedComponent,
  editedComponent,
  deletedComponent,
}

extension MovementExtension on MovementType {
  String get name {
    return toTitle(separateWords(this.toString().split('.')[1]));
  }
}
