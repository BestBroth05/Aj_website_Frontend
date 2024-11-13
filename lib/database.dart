import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:guadalajarav2/administration/Movements/movement.dart';
import 'package:guadalajarav2/administration/Movements/movementType.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/administration/user/userPermissions.dart';
import 'package:guadalajarav2/inventory/classes/capacitor.dart';
import 'package:guadalajarav2/inventory/classes/connector.dart';
import 'package:guadalajarav2/inventory/classes/discreteSemiconductor.dart';
import 'package:guadalajarav2/inventory/classes/display.dart';
import 'package:guadalajarav2/inventory/classes/inductor.dart';
import 'package:guadalajarav2/inventory/classes/integratedCircuit.dart';
import 'package:guadalajarav2/inventory/classes/led.dart';
import 'package:guadalajarav2/inventory/classes/mechanic.dart';
import 'package:guadalajarav2/inventory/classes/microcontroller.dart';
import 'package:guadalajarav2/inventory/classes/miscellaneous.dart';
import 'package:guadalajarav2/inventory/classes/optocoupler.dart';
import 'package:guadalajarav2/inventory/classes/pcb.dart';
import 'package:guadalajarav2/inventory/classes/powerSupply.dart';
import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/inventory/classes/protectionCircuit.dart';
import 'package:guadalajarav2/inventory/classes/resistor.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/inventory/inventoryListView.dart';
import 'package:guadalajarav2/main.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:http/http.dart' as http;

String address = 'http://ec2-3-129-169-30.us-east-2.compute.amazonaws.com:8000';

String addressInventory = '$address/Inventory';
String addressUsers = '$address/Users';
String addressLogin = '$address/Login';
String addressPermissions = '$address/Users/Permissions';
String addressMovements = '$address/Movements';

Future<bool> connectToDatabase() async {
  isSearchingSearchBar = false;
  final response = await http.get(
    Uri.parse('$addressInventory'),
    headers: {"Access-Control-Allow-Origin": "*"},
  );

  int code = response.statusCode;

  bool couldConnect = true;

  switch (code) {
    case 200:
      break;

    default:
      print('[SERVER] Something went wrong. Status code: $code');
      couldConnect = false;
  }

  return couldConnect;
}

Future<List<Product>> searchProductsByCategoryInDatabase(
  Category category,
) async {
  if (!(await connectToDatabase())) {
    return [];
  }

  // print('[DATABASE] Loading Components');

  final response = await http.get(
    Uri.parse('$addressInventory/Products/${category.databaseName}'),
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "$token",
    },
  );

  if (response.statusCode == 200) {
    List<Product> components = getComponents(category, response.body);
    return components;
  } else {
    return [];
  }
}

Future<List<Product>> searchProductByMPNInDatabase(String? mpn) async {
  if (mpn == null) {
    return [];
  }
  if (!(await connectToDatabase())) {
    return [];
  }

  List<Product> components = [];

  for (Category category in Category.values) {
    final response = await http.post(
      Uri.parse('$addressInventory/Search/${category.databaseName}'),
      headers: <String, String>{
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          'mpn': {
            'value': mpn,
            'type': 'string',
          }
        },
      ),
    );

    components.addAll(getComponents(category, response.body));
  }
  if (components.length > 0) {
    return components;
  }

  return [];
}

Future<bool> editQuantityOfComponentInDatabase(Product product) async {
  if (!(await connectToDatabase())) {
    return false;
  }

  String mpn = product.mpn!;
  int quantity = product.quantity!;

  Map<String, dynamic> filters = {};
  filters.putIfAbsent('quantity', () => {'value': quantity, 'type': 'int'});
  filters.putIfAbsent('lastEdited',
      () => {'value': DateTime.now().toString(), 'type': 'string'});
  filters.putIfAbsent('mpn', () => {'value': mpn, 'type': 'string'});

  final response = await http.post(
    Uri.parse('$addressInventory/Edit/${product.category!.databaseName}'),
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(filters),
  );
  // print(response.body);
  // print(product.toJson());

  bool couldAdd = true;

  if (response.statusCode != 200) {
    couldAdd = false;
  }

  return couldAdd;
}

Future<bool> editComponent(Map<String, String> keys, Product product) async {
  if (!(await connectToDatabase())) {
    return false;
  }
  Map<String, dynamic> values = product.toJson();
  Map<String, dynamic> filters = {};

  for (String key in values.keys) {
    filters.putIfAbsent(key, () => {'value': values[key], 'type': keys[key]});
  }

  // values.putIfAbsent('category', () => product.category!.databaseName);
  // print(category.databaseName);
  final response = await http.post(
    Uri.parse('$addressInventory/Edit/${product.category!.databaseName}'),
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(filters),
  );
  // print(response.body);
  // print(product.toJson());

  bool couldAdd = true;

  if (response.statusCode != 200) {
    couldAdd = false;
  } else {
    Movement movement = Movement.fromInventory(
      date: getDate(),
      time: getTime(),
      productAffected: product,
      type: MovementType.editedComponent,
    );
    await addMovementToDatabase(movement);
  }

  return couldAdd;
}

Future<bool> addNewComponent(Product product, Category category) async {
  if (!(await connectToDatabase())) {
    return false;
  }

  // print(category.databaseName);
  final response = await http.post(
    Uri.parse('$addressInventory/Products/${category.databaseName}'),
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(product.toJson()),
  );
  // print(response.statusCode);
  // print(product.toJson());

  bool couldAdd = true;

  if (response.statusCode != 200) {
    couldAdd = false;
  } else {
    Movement movement = Movement.fromInventory(
      date: getDate(),
      time: getTime(),
      productAffected: product,
      type: MovementType.addedComponent,
    );
    await addMovementToDatabase(movement);
  }

  return couldAdd;
}

Future<List<Product>> searchProductsByFiltersInDatabase(
  Category category,
  Map<String, dynamic> filters,
) async {
  if (!(await connectToDatabase())) {
    return [];
  }

  final response = await http.post(
    Uri.parse('$addressInventory/Search/${category.databaseName}'),
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(filters),
  );
  // print(response.body);
  List<Product> components = getComponents(category, response.body);

  return components;
}

Future<Map<String, Map<String, dynamic>>> searchProductsByBOMSInDatabase(
    Map<String, String> mpns) async {
  final response = await http.post(
    Uri.parse('$addressInventory/BOM'),
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(mpns),
  );
  // print(response.body);
  // Map<String, Map<String, dynamic>> quantities =
  //     getMPNQuantities(jsonDecode(response.body));
  Map<String, Map<String, dynamic>> quantities =
      getMPNValues(jsonDecode(response.body));
  return quantities;
}

Future<bool> removeComponentsbyBOMInDatabase(
  List<List<dynamic>> products, {
  bool alreadyLinked = false,
}) async {
  if (!(await connectToDatabase())) {
    return false;
  } else {
    Map<String, int> values = Map.fromIterable(
      products,
      key: (p) => p[0].toString(),
      value: alreadyLinked ? (p) => p[1] : (p) => p[1] - p[2],
    );

    final response = await http.post(
      Uri.parse('$addressInventory/BOMRemove'),
      headers: <String, String>{
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(values),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

Future<bool> deleteComponentInDatabase(Product product) async {
  if (!await connectToDatabase()) {
    return false;
  } else {
    Map<String, String> filters = {'mpn': product.mpn!};
    final response = await http.post(
      Uri.parse('$addressInventory/Delete/${product.category!.databaseName}'),
      headers: <String, String>{
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(filters),
    );

    if (response.statusCode == 200) {
      Movement movement = Movement.fromInventory(
        date: getDate(),
        time: getTime(),
        productAffected: product,
        type: MovementType.deletedComponent,
      );
      await addMovementToDatabase(movement);
      return true;
    } else {
      return false;
    }
  }
}

List<Product> getComponents(Category category, dynamic body) {
  List<dynamic> componentsJson = json.decode(body);
  List<Product> components = [];
  for (dynamic json in componentsJson) {
    // print(json);
    switch (category) {
      case Category.capacitors:
        components.add(Capacitor.fromJson(json));
        break;
      case Category.connectors:
        components.add(Connector.fromJson(json));
        break;
      case Category.discrete_semiconductors:
        components.add(DiscreteSemiconductor.fromJson(json));
        break;
      case Category.displays:
        components.add(Display.fromJson(json));
        break;
      case Category.inductors:
        components.add(Inductor.fromJson(json));
        break;
      case Category.integrated_circuits:
        components.add(IntegratedCircuit.fromJson(json));
        break;
      case Category.leds:
        components.add(Led.fromJson(json));
        break;
      case Category.mechanics:
        components.add(Mechanic.fromJson(json));
        break;
      case Category.microcontrollers:
        components.add(Microcontroller.fromJson(json));
        break;
      case Category.miscellaneous:
        components.add(Miscellaneous.fromJson(json));
        break;
      case Category.optocouplers:
        components.add(Optocoupler.fromJson(json));
        break;
      case Category.pcbs:
        components.add(Pcb.fromJson(json));
        break;
      case Category.power_supplies:
        components.add(PowerSupply.fromJson(json));
        break;
      case Category.protection_circuits:
        components.add(ProtectionCircuit.fromJson(json));
        break;
      case Category.resistors:
        components.add(Resistor.fromJson(json));
        break;
    }
  }
  return components;
}

Map<String, Map<String, dynamic>> getMPNQuantities(List<dynamic> body) {
  Map<String, Map<String, dynamic>> quantities = {};

  for (dynamic mpn in body) {
    quantities.putIfAbsent(
      mpn['mpn'],
      () => {
        'quantity': mpn['quantity'],
        'unitPrice': mpn['unitPrice'],
      },
    );
  }

  return quantities;
}

Map<String, Map<String, dynamic>> getMPNValues(List<dynamic> body) {
  Map<String, Map<String, dynamic>> mpns = {};

  for (dynamic mpn in body) {
    mpns.putIfAbsent(
      mpn['mpn'],
      () => mpn,
    );
  }

  return mpns;
}

Future<List<User>> getAllUsersInDatabase() async {
  if (!(await connectToDatabase())) {
    return [];
  } else {
    final response = await http.get(Uri.parse('$addressUsers'), headers: {
      'Authorization': "$token",
    });
    List<User> users = [];
    if (response.statusCode == 200) {
      users = getUsersFromBody(response.body);
    }

    return users;
  }
}

Future<bool> addUsersToDatabase(User _user) async {
  if (!(await connectToDatabase())) {
    return false;
  } else {
    final response = await http.post(
      Uri.parse('$addressUsers/Add'),
      headers: <String, String>{
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(_user.toJson()),
    );

    // print(response.body);
    // print(product.toJson());

    if (response.statusCode != 200) {
      return false;
    } else {
      // Movement movement = Movement.fromUser(
      //   date: getDate(),
      //   time: getTime(),
      //   userAffected: _user,
      //   type: MovementType.addedUser,
      // );
      // await addMovementToDatabase(movement);
      return true;
    }
  }
}

Future<bool> editUserInDatabase(User _user) async {
  if (!(await connectToDatabase())) {
    return false;
  } else {
    final response = await http.post(
      Uri.parse('$addressUsers/Edit'),
      headers: <String, String>{
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(_user.toJson()),
    );

    // print(response.body);
    // print(product.toJson());

    if (response.statusCode != 200) {
      return false;
    } else {
      Movement movement = Movement.fromUser(
        date: getDate(),
        time: getTime(),
        userAffected: _user,
        type: MovementType.editedUser,
      );
      await addMovementToDatabase(movement);
      return true;
    }
  }
}

Future<bool> deleteUserInDatabase(User _user) async {
  if (!(await connectToDatabase())) {
    return false;
  } else {
    final response = await http.post(
      Uri.parse('$addressUsers/Delete'),
      headers: <String, String>{
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(_user.toJson()),
    );

    // print(response.body);
    // print(product.toJson());

    if (response.statusCode != 200) {
      return false;
    } else {
      Movement movement = Movement.fromUser(
        date: getDate(),
        time: getTime(),
        userAffected: _user,
        type: MovementType.deletedUser,
      );
      await addMovementToDatabase(movement);
      return true;
    }
  }
}

List<User> getUsersFromBody(dynamic body) {
  List<User> users = [];

  // List<dynamic> bodyList = [];
  dynamic bodyList = json.decode(body);

  // print('$bodyList ${bodyList.runtimeType}');

  for (dynamic json in bodyList) {
    // print(json);
    users.add(User.fromJson(json));
  }

  return users;
}

Future<String?> getUserInDatabase(
    BuildContext context, String username, String password) async {
  if (!(await connectToDatabase())) {
    return null;
  } else {
    final response = await http.post(
      Uri.parse('$addressLogin'),
      headers: <String, String>{
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      // print(jsonDecode(response.body)['token']);
      return jsonDecode(response.body)['token'];
    } else {
      return null;
    }
  }
}

Future<bool> removeTokenFromDatabase(BuildContext context, String token) async {
  if (!(await connectToDatabase())) {
    return false;
  } else {
    final response = await http.delete(
      Uri.parse('$addressLogin'),
      headers: <String, String>{
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      // print(jsonDecode(response.body)['token']);
      return true;
    } else {
      return false;
    }
  }
}

Future<User?> getUserFromToken() async {
  final response = await http.get(
    Uri.parse('$addressLogin'),
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "$token",
    },
  );

  if (response.statusCode == 200) {
    List<User> users = getUsersFromBody(response.body);
    // print(users);
    if (users.length > 0) {
      user = users[0];
      // print('[WEBSITE] Active User: $user');
      // user.permissions = await getPermissions(user);
      return user;
    } else {
      return null;
    }
  } else {
    return null;
  }
}

Future<List<UserPermission>> getPermissions(User user) async {
  final response = await http.post(
    Uri.parse('$addressPermissions'),
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "$token",
    },
    body: jsonEncode({'id': user.id}),
  );

  // print(response.body);

  if (response.statusCode == 200) {
    return getPermissionsFromBody(response.body);
  }

  return [];
}

Future<bool> updatePermissions(User user, BuildContext context) async {
  Map<String, dynamic> body = {'id': user.id};

  for (UserPermission permission in UserPermission.values) {
    int value = user.permissions.contains(permission) ? 1 : 0;
    body.putIfAbsent(permission.name, () => value);
  }

  final response = await http.patch(
    Uri.parse('$addressPermissions'),
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "$token",
    },
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

List<UserPermission> getPermissionsFromBody(dynamic body) {
  List<UserPermission> permissions = [];

  List<dynamic> bodyList = json.decode(body);
  for (dynamic json in bodyList) {
    Map<String, dynamic> body = json;
    for (UserPermission permission in UserPermission.values) {
      String name = permission.name;
      if (body[name] == 1) {
        permissions.add(permission);
      }
    }
  }

  return permissions;
}

Future<bool> addMovementToDatabase(Movement movement) async {
  if (!(await connectToDatabase())) {
    return false;
  } else {
    final response = await http.post(
      Uri.parse('$addressMovements'),
      headers: <String, String>{
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(movement.toJson()),
    );

    bool couldAdd = true;

    if (response.statusCode != 200) {
      couldAdd = false;
    }

    return couldAdd;
  }
}

Future<List<Movement>> getAllMovements(BuildContext context) async {
  final response = await http.get(
    Uri.parse('$addressMovements'),
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  List<Movement> moves = [];

  if (response.statusCode == 200) {
    moves = getMovementsFromBody(response.body);
  }
  return moves;
}

Future<List<Movement>> getMovementsFiltered(
  BuildContext context,
  Map<String, dynamic> filters,
) async {
  final response = await http.post(
    Uri.parse('$addressMovements/Filtered/'),
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(filters),
  );

  List<Movement> moves = [];

  if (response.statusCode == 200) {
    moves = getMovementsFromBody(response.body);
  }
  return moves;
}

List<Movement> getMovementsFromBody(dynamic body) {
  List<Movement> _movements = [];

  List<dynamic> bodyList = json.decode(body);

  for (dynamic json in bodyList) {
    _movements.add(Movement.fromJson(json));
  }

  return _movements.reversed.toList();
}
