/* **********************************************************************************************
*   2025 AJ Electronic Design  (All Rights Reserved)
*   NOTICE:  All information contained herein is, and remains the property of AJ Electronic Design.
*            The intellectual and technical concepts contained here, are proprietary to
*            AJ Electronic Design and may be covered by U.S. and Foreign Patents, patents in
*            process, and are protected by trade secret or copyright law.
*            Dissemination of this information or reproduction of this material is strictly
*            forbidden unless prior written permission is obtained from AJ Electronic Design.
*
* @file    login_screen.dart
* @author  AJ Electronic Design
* last change:
*     $Author: Brayan Olivares $
*     $Date: 2025-05-05 10:59:00 -0500 (Mon, 05 May 2025) $
*     $Version 1.0:  $
*     $URL: http://www.aj-electronic-design.com/ $
*
* @brief

************************************************************************************************* */

class StatusClass {
  final int? id;
  final String email;
  final String name;
  final String? type;
  final int userType;
  final String? password;
  final bool? state;
  final int? userCreation;
  final String? dateCreation;
  final int? userEdit;
  final String? dateEdit;
  final String? token; // ← token opcional

  StatusClass({
    this.id,
    required this.email,
    required this.name,
    this.type,
    required this.userType,
    this.password,
    this.state,
    this.userCreation,
    this.dateCreation,
    this.userEdit,
    this.dateEdit,
    this.token,
  });
  factory StatusClass.fromJson(
    Map<String, dynamic> json, {
    String? token,
  }) {
    String? typeString;

    if (json['TipoUsuario'] == 1) {
      typeString = "administrador";
    } else {
      typeString = "instalador";
    }
    return StatusClass(
      id: json['ID'],
      name: json['Nombre'],
      email: json['Correo'],
      type: typeString,
      userType: json['TipoUsuario'],
      password: json['Contraseña'],
      state: json['Estado'],
      userCreation: json['CreacionUsuario'],
      dateCreation: json['CreacionFechaHora'],
      userEdit: json['EdicionUsuario'],
      dateEdit: json['EdicionFechaHora'],
      token: token,
    );
  }
}
