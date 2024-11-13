import 'package:guadalajarav2/administration/Movements/movementType.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/main.dart';

class Movement {
  late final String date;
  late final String time;
  late final int userId;
  late final String username;
  late final String description;
  late final MovementType subtype;
  late final MovementGType type;

  Movement(this.date, this.time, this.userId, this.description, this.type,
      this.subtype, this.username);

  Movement.fromUser({
    required String date,
    required String time,
    required MovementType type,
    required User userAffected,
  }) {
    this.date = date;
    this.time = time;
    this.username = user!.username;
    this.userId = user!.id;
    this.type = MovementGType.users;
    this.subtype = type;
    switch (type) {
      case MovementType.addedUser:
        this.description = 'Added user: ${userAffected.username}';
        break;
      case MovementType.editedUser:
        this.description = 'Edited user: ${userAffected.username}';
        break;
      case MovementType.deletedUser:
        this.description = 'Deleted user: ${userAffected.username}';
        break;
      default:
        break;
    }
  }
  Movement.fromInventory({
    required String date,
    required String time,
    required MovementType type,
    required Product productAffected,
  }) {
    this.date = date;
    this.time = time;
    this.username = user!.username;
    this.userId = user!.id;
    this.type = MovementGType.inventory;
    this.subtype = type;
    switch (type) {
      case MovementType.addedComponent:
        this.description = 'Added Component: ${productAffected.mpn}';
        break;
      case MovementType.editedComponent:
        this.description = 'Edited Component: ${productAffected.mpn}';
        break;
      case MovementType.deletedComponent:
        this.description = 'Deleted Component: ${productAffected.mpn}';
        break;
      default:
        break;
    }
  }

  Movement.fromJson(Map<String, dynamic> json) {
    this.date = json['date'];
    this.time = json['time'];
    this.userId = json['userId'];
    this.username = json['username'];
    this.description = json['description'];
    this.subtype = MovementType.values[json['subtype']];
    this.type = MovementGType.values[json['type']];
  }

  Map<String, dynamic> toJson() {
    return {
      'date': this.date,
      'time': this.time,
      'userId': this.userId,
      'username': this.username,
      'description': this.description,
      'subtype': MovementType.values.indexOf(this.subtype),
      'type': MovementGType.values.indexOf(this.type),
    };
  }

  @override
  String toString() {
    return '[Movement] ' +
        '[$date $time] ${subtype.name} by user $username , $description';
  }
}
