// ignore_for_file: file_names

/*! **********************************************************************************************
*   2024 AJ Electronic Design  (All Rights Reserved)
*   NOTICE:  All information contained herein is, and remains the property of AJ Electronic Design.
*            The intellectual and technical concepts contained here, are proprietary to
*            AJ Electronic Design and may be covered by U.S. and Foreign Patents, patents in
*            process, and are protected by trade secret or copyright law.
*            Dissemination of this information or reproduction of this material is strictly
*            forbidden unless prior written permission is obtained from AJ Electronic Design.
*
* @file    calibration.dart
* @author  AJ Electronic Design
* last change:
*     $Author: AJ Electronic Design $
*     $Date: 02-07-24 12:37:00 CST (Wed, Feb 07 2024) $
*     $Revision: 21 $
*     $URL: http://www.aj-electronic-design.com/ $
*     $Client: EMED
* @brief

**************************************************************************************************/
import 'dart:convert';
import 'package:guadalajarav2/views/ArquiurbusDemo/TransaccionClass.dart';
import 'package:http/http.dart' as http;
//http://ec2-3-129-169-30.us-east-2.compute.amazonaws.com:8000/
//http://192.168.0.112:8080/

class DataAccessObjectArquiurbus {
//------------------------------API--------------------------------
  static String url =
      "http://ec2-3-129-169-30.us-east-2.compute.amazonaws.com:8080/";

// ********************************************* Transacciones ***************************************************** //

  //--------------------------- Get Transacciones --------------------------
  static Future<List<Transaccionclass>> getTransacciones() async {
    var res = await http.get(Uri.parse("${url}debitacion/get"));

    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);

      return List.generate(
          jsonData.length,
          (i) => Transaccionclass(
              idUnidad: jsonData[i]['idUnidad'],
              fecha: jsonData[i]['fecha'],
              hora: jsonData[i]['hora'],
              estado: jsonData[i]['estado'],
              ruta: jsonData[i]['ruta'],
              unidad: jsonData[i]['unidad'],
              latitud: jsonData[i]['latitud'],
              longitud: jsonData[i]['longitud'],
              tarifa: jsonData[i]['tarifa'],
              tipoTarifa: jsonData[i]['tipoTarifa'],
              tipoDebitacion: jsonData[i]['tipoDebitacion'],
              denominaciones: jsonData[i]['denominacion']));
    } else if (res.statusCode == 404) {
      return List.empty();
    } else {
      throw res.statusCode;
    }
  }
}
