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
import 'package:http/http.dart' as http;

import '../../Quotes/Clases/DigikeyClass.dart';
import '../../Quotes/Clases/PorcentajesClass.dart';
import '../../Quotes/Clases/QuoteClass.dart';
import '../../Quotes/Clases/QuoteTableClass.dart';
import '../adminClases/CertificadoEntregaClass.dart';
import '../adminClases/CustomerClass.dart';
import '../adminClases/OrdenCompraClass.dart';
import '../adminClases/productClass.dart';
//http://ec2-3-129-169-30.us-east-2.compute.amazonaws.com:8000/
//http://192.168.0.111:8080/

class DataAccessObject {
//------------------------------API--------------------------------
  static String url =
      "http://ec2-3-129-169-30.us-east-2.compute.amazonaws.com:8000/";

// ********************************************* Customers ***************************************************** //

//--------------------------- Post Customer --------------------------
  static Future<int> postCustomer(name, email, rfc, contact, phone, lada,
      country, state, city, cp, street, logo) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}Customers/post"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'email': email,
        'rfc': rfc,
        'contact': contact,
        'phone': phone,
        'lada': lada,
        'country': country,
        'state': state,
        'city': city,
        'cp': cp,
        'street': street,
        'logo': logo
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Get Customer --------------------------
  static Future<List<CustomersClass>> getCustomer() async {
    var res = await http.get(Uri.parse("${url}Customers/get"));

    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);

      return List.generate(
          jsonData.length,
          (i) => CustomersClass(
              id_customer: jsonData[i]['id_customer'],
              name: jsonData[i]['name'],
              email: jsonData[i]['email'],
              rfc: jsonData[i]['rfc'],
              contact: jsonData[i]['contact'],
              phone: jsonData[i]['phone'],
              lada: jsonData[i]['lada'],
              country: jsonData[i]['country'],
              state: jsonData[i]['state'],
              city: jsonData[i]['city'],
              cp: jsonData[i]['cp'],
              street: jsonData[i]['street'],
              logo: jsonData[i]['logo']));
    } else if (res.statusCode == 404) {
      return List.empty();
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Delete Customer --------------------------
  static Future<int> deleteCustomer(id_customer) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}Customers/delete"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_customer': id_customer,
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Select Customer --------------------------
  static Future<List<CustomersClass>> selectCustomer(id_customer) async {
    var res = await http.post(
      Uri.parse("${url}Customers/select"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_customer': id_customer,
      }),
    );

    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      return List.generate(
          jsonData.length,
          (i) => CustomersClass(
              id_customer: jsonData[i]['id_customer'],
              name: jsonData[i]['name'],
              email: jsonData[i]['email'],
              rfc: jsonData[i]['rfc'],
              contact: jsonData[i]['contact'],
              phone: jsonData[i]['phone'],
              lada: jsonData[i]['lada'],
              country: jsonData[i]['country'],
              state: jsonData[i]['state'],
              city: jsonData[i]['city'],
              cp: jsonData[i]['cp'],
              street: jsonData[i]['street'],
              logo: jsonData[i]['logo']));
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Post Customer --------------------------
  static Future<int> updateCustomer(id_customer, name, email, rfc, contact,
      phone, lada, country, state, city, cp, street, logo) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}Customers/update"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_customer': id_customer,
        'name': name,
        'email': email,
        'rfc': rfc,
        'contact': contact,
        'phone': phone,
        'lada': lada,
        'country': country,
        'state': state,
        'city': city,
        'cp': cp,
        'street': street,
        'logo': logo
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }

// ********************************************* Orden de compra ***************************************************** //
//--------------------------- Post OC --------------------------
  static Future<int> postOC(
      OC,
      id_customer,
      fecha_inicio,
      fecha_fin,
      solicitante,
      country,
      state,
      city,
      cp,
      street,
      prioridad,
      moneda,
      descripcion,
      cantidad,
      prefijo) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}OrdenCompra/post"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'OC': OC,
        'id_customer': id_customer,
        'fecha_inicio': fecha_inicio,
        'fecha_fin': fecha_fin,
        'solicitante': solicitante,
        'country': country,
        'state': state,
        'city': city,
        'cp': cp,
        'street': street,
        'prioridad': prioridad,
        'moneda': moneda,
        'descripcion': descripcion,
        'cantidad': cantidad,
        'prefijo': prefijo
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else {
      code = res.statusCode;
      return code;
    }
  }

  //--------------------------- Get OC --------------------------
  static Future<List<OrdenCompraClass>> getOC() async {
    var res = await http.get(Uri.parse("${url}OrdenCompra/get"));

    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);

      return List.generate(
          jsonData.length,
          (i) => OrdenCompraClass(
              id_OC: jsonData[i]['id_OC'],
              id_customer: jsonData[i]['id_customer'],
              OC: jsonData[i]['OC'],
              fecha_inicio: jsonData[i]['fecha_inicio'],
              fecha_fin: jsonData[i]['fecha_fin'],
              solicitante: jsonData[i]['solicitante'],
              prioridad: jsonData[i]['prioridad'],
              pais: jsonData[i]['country'],
              estado: jsonData[i]['state'],
              ciudad: jsonData[i]['city'],
              cp: jsonData[i]['cp'],
              street: jsonData[i]['street'],
              descripcion: jsonData[i]['descripcion'],
              cantidad: jsonData[i]['cantidad'],
              prefijo: jsonData[i]['prefijo']));
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Delete OC --------------------------
  static Future<int> deleteOC(id_OC) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}OrdenCompra/delete"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_OC': id_OC,
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Select OC --------------------------
  static Future<List<OrdenCompraClass>> selectOC(id_OC) async {
    var res = await http.post(
      Uri.parse("${url}OrdenCompra/select/orden"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_OC': id_OC,
      }),
    );

    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      return List.generate(
          jsonData.length,
          (i) => OrdenCompraClass(
              id_customer: jsonData[i]['id_customer'],
              id_OC: jsonData[i]['id_OC'],
              OC: jsonData[i]['OC'],
              fecha_inicio: jsonData[i]['fecha_inicio'],
              fecha_fin: jsonData[i]['fecha_fin'],
              solicitante: jsonData[i]['solicitante'],
              prioridad: jsonData[i]['prioridad'],
              pais: jsonData[i]['pais'],
              estado: jsonData[i]['estado'],
              ciudad: jsonData[i]['ciudad'],
              cp: jsonData[i]['cp'],
              street: jsonData[i]['street'],
              moneda: jsonData[i]['moneda'],
              descripcion: jsonData[i]['descripcion'],
              cantidad: jsonData[i]['cantidad'],
              prefijo: jsonData[i]['prefijo']));
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Select OC --------------------------
  static Future<List<OrdenCompraClass>> selectOCCustomer(id_customer) async {
    var res = await http.post(
      Uri.parse("${url}OrdenCompra/select/customer"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_customer': id_customer,
      }),
    );

    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      return List.generate(
          jsonData.length,
          (i) => OrdenCompraClass(
              id_customer: jsonData[i]['id_customer'],
              id_OC: jsonData[i]['id_OC'],
              OC: jsonData[i]['OC'],
              fecha_inicio: jsonData[i]['fecha_inicio'],
              fecha_fin: jsonData[i]['fecha_fin'],
              solicitante: jsonData[i]['solicitante'],
              prioridad: jsonData[i]['prioridad'],
              pais: jsonData[i]['pais'],
              estado: jsonData[i]['estado'],
              ciudad: jsonData[i]['ciudad'],
              cp: jsonData[i]['cp'],
              street: jsonData[i]['street'],
              moneda: jsonData[i]['moneda'],
              descripcion: jsonData[i]['descripcion'],
              cantidad: jsonData[i]['cantidad'],
              prefijo: jsonData[i]['prefijo']));
    }
    //Not found
    else if (res.statusCode == 404) {
      List<OrdenCompraClass> notFound = [];
      return notFound;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Update OC --------------------------
  static Future<int> updateOC(
      id_OC,
      id_customer,
      OC,
      fecha_inicio,
      fecha_fin,
      solicitante,
      country,
      state,
      city,
      cp,
      street,
      prioridad,
      moneda,
      descripcion,
      cantidad,
      prefijo) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}OrdenCompra/update"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_OC': id_OC,
        'id_customer': id_customer,
        'OC': OC,
        'fecha_inicio': fecha_inicio,
        'fecha_fin': fecha_fin,
        'solicitante': solicitante,
        'prioridad': prioridad,
        'country': country,
        'state': state,
        'city': city,
        'cp': cp,
        'street': street,
        'moneda': moneda,
        'descripcion': descripcion,
        'cantidad': cantidad,
        'prefijo': prefijo
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }

// ********************************************* Certificado de Entrega ***************************************************** //
//--------------------------- Post Entrega --------------------------
  static Future<int> postEntrega(id_OC, certificado_entrega, fecha, direccion,
      solicitante, remitente, notes) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}Entregas/post"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_OC': id_OC,
        'certificado_entrega': certificado_entrega,
        'fecha': fecha,
        'notes': notes,
        'direccion': direccion,
        'solicitante': solicitante,
        'remitente': remitente,
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Get Entrega --------------------------
  static Future<List<ClassCertificadoEntrega>> getEntrega() async {
    var res = await http.get(Uri.parse("${url}Entregas/get"));

    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);

      return List.generate(
          jsonData.length,
          (i) => ClassCertificadoEntrega(
              id_Entrega: jsonData[i]['id_Entrega'],
              id_OC: jsonData[i]['id_OC'],
              certificadoEntrega: jsonData[i]['CertificadoEntrega'],
              Fecha: jsonData[i]['Fecha'],
              Direccion: jsonData[i]['Direccion'],
              Solicitante: jsonData[i]['Solicitante'],
              Remitente: jsonData[i]['Remitente'],
              Notes: jsonData[i]['Notes']));
    } else if (res.statusCode == 404) {
      List<ClassCertificadoEntrega> list = [];
      print("Error 404 not found");
      return list;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Delete Entrega --------------------------
  static Future<int> deleteEntrega(id_entrega) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}Entregas/delete"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_entrega': id_entrega,
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Select Entrega --------------------------
  static Future<List<ClassCertificadoEntrega>> selectEntrega(id_OC) async {
    var res = await http.post(
      Uri.parse("${url}Entregas/select"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_OC': id_OC,
      }),
    );

    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      print("Data = $jsonData");
      return List.generate(
          jsonData.length,
          (i) => ClassCertificadoEntrega(
              id_Entrega: jsonData[i]['id_Entrega'],
              id_OC: jsonData[i]['id_OC'],
              certificadoEntrega: jsonData[i]['CertificadoEntrega'],
              Fecha: jsonData[i]['Fecha'],
              Direccion: jsonData[i]['Direccion'],
              Solicitante: jsonData[i]['Solicitante'],
              Remitente: jsonData[i]['Remitente'],
              Notes: jsonData[i]['Notes']));
    } else if (res.statusCode == 404) {
      List<ClassCertificadoEntrega> notFound = [];
      return notFound;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Update Entrega --------------------------
  static Future<int> updateEntrega(id_OC, id_Entrega, CertificadoEntrega, Fecha,
      direccion, solicitante, remitente, Notes) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}Entregas/update"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_OC': id_OC,
        'id_Entrega': id_Entrega,
        'CertificadoEntrega': CertificadoEntrega,
        'fecha': Fecha,
        'direccion': direccion,
        'solicitante': solicitante,
        'remitente': remitente,
        'notes': Notes
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }

// ********************************************* Certificado de Entrega Productos ***************************************************** //
//--------------------------- Post Producto OC --------------------------
  static Future<int> postProductoOC(id_entrega, id_OC, cantidad, descripcion,
      precio_unitario, importe) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}ProductosOC/post"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_entrega': id_entrega,
        'id_OC': id_OC,
        'cantidad': cantidad,
        'descripcion': descripcion,
        'precio_unitario': precio_unitario,
        'importe': importe,
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Get ProductosOC --------------------------
  static Future<List<ProductCertificateDelivery>> getProductosOC() async {
    var res = await http.get(Uri.parse("${url}ProductosOC/get"));

    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);

      return List.generate(
          jsonData.length,
          (i) => ProductCertificateDelivery(
              id_producto: jsonData[i]['id_producto'],
              id_entrega: jsonData[i]['id_entrega'],
              id_OC: jsonData[i]['id_OC'],
              precioUnitario: jsonData[i]['precio_unitario'],
              cantidad: jsonData[i]['cantidad'],
              descripcion: jsonData[i]['descripcion'],
              importe: jsonData[i]['importe']));
    } else if (res.statusCode == 404) {
      List<ProductCertificateDelivery> list = [];
      print("Error 404 not found");
      return list;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Delete Product --------------------------
  static Future<int> deleteProductOC(id_producto) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}ProductosOC/delete"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_producto': id_producto,
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Select Prodcuto --------------------------
  static Future<List<ProductCertificateDelivery>> selectProductOC(
      id_entrega) async {
    var res = await http.post(
      Uri.parse("${url}ProductosOC/select"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_entrega': id_entrega,
      }),
    );

    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      print("Data = $jsonData");
      return List.generate(
          jsonData.length,
          (i) => ProductCertificateDelivery(
              id_producto: jsonData[i]['id_producto'],
              id_entrega: jsonData[i]['id_entrega'],
              id_OC: jsonData[i]['id_OC'],
              precioUnitario: jsonData[i]['precio_unitario'],
              cantidad: jsonData[i]['cantidad'],
              descripcion: jsonData[i]['descripcion'],
              importe: jsonData[i]['importe']));
    } else if (res.statusCode == 404) {
      List<ProductCertificateDelivery> notFound = [];
      return notFound;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Update ProductOC --------------------------
  static Future<int> updateProductOC(id_producto, id_entrega, id_OC,
      precioUnitario, cantidad, descripcion, importe) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}ProductosOC/update"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_producto': id_producto,
        'id_entrega': id_entrega,
        'id_OC': id_OC,
        'precioUnitario': precioUnitario,
        'cantidad': cantidad,
        'descripcion': descripcion,
        'importe': importe
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else if (res.statusCode != 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }
// ********************************************* Quotes ***************************************************** //

//--------------------------- Post Quote --------------------------
  static Future<int> postQuote(
      id_customer,
      id_percentages,
      iva,
      isr,
      date,
      customerName,
      quoteNumber,
      proyectName,
      requestedByName,
      requestedByEmail,
      attentionTo,
      quantity,
      dollarSell,
      dollarBuy,
      deliverTimeInfo,
      currency,
      conIva,
      excelName,
      componentsMPN,
      componentsAvailables,
      componentsDeliverTime,
      componentsAJPercentage,
      digikeysAJPercentage,
      dhlCostComponent,
      componentsMouserCost,
      componentsIva,
      componentsAJ,
      totalComponentsUSD,
      totalComponentsMXN,
      perComponentMXN,
      PCBName,
      PCBLayers,
      PCBSize,
      PCBImage,
      PCBColor,
      PCBDeliveryTime,
      PCBdhlCost,
      PCBAJPercentage,
      PCBReleasePercentage,
      PCBPurchase,
      PCBShipment,
      PCBTax,
      PCBRelease,
      PCBAJ,
      PCBTotalUSD,
      PCBTotalMXN,
      PCBPerMXN,
      assemblyLayers,
      assemblyMPN,
      assemblySMT,
      assemblyTH,
      assemblyDeliveryTime,
      assemblyAJPercentage,
      assembly,
      assemblyTax,
      assemblyAJ,
      assemblyDhlCost,
      assemblyTotalMXN,
      perAssemblyMXN) async {
    int code = 0;

    var res = await http.post(
      Uri.parse("${url}quotes/post"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        //ID's
        'id_customer': id_customer,
        'id_percentages': id_percentages,
        //General Percentages
        'iva': iva,
        'isr': isr,
        //General Data
        'date': date,
        'customerName': customerName,
        'quoteNumber': quoteNumber,
        'proyectName': proyectName,
        'requestedByName': requestedByName,
        'requestedByEmail': requestedByEmail,
        'attentionTo': attentionTo,
        //Information
        'quantity': quantity,
        'dollarSell': dollarSell,
        'dollarBuy': dollarBuy,
        'deliverTimeInfo': deliverTimeInfo,
        'currency': currency,
        'conIva': conIva,
        //Components
        'excelName': excelName,
        'componentsMPN': componentsMPN,
        'componentsAvailables': componentsAvailables,
        'componentsDeliverTime': componentsDeliverTime,
        'componentsAJPercentage': componentsAJPercentage,
        'digikeyAJPercentage': digikeysAJPercentage,
        'dhlCostComponents': dhlCostComponent,
        'componentsMauserCost': componentsMouserCost,
        'componentsIva': componentsIva,
        'componentsAJ': componentsAJ,
        'totalComponentsUSD': totalComponentsUSD,
        'totalComponentsMXN': totalComponentsMXN,
        'perComponentMXN': perComponentMXN,
        //PCB's
        'PCBName': PCBName,
        'PCBLayers': PCBLayers,
        'PCBSize': PCBSize,
        'PCBImage': PCBImage,
        'PCBColor': PCBColor,
        'PCBDeliveryTime': PCBDeliveryTime,
        'PCBdhlCost': PCBdhlCost,
        'PCBAJPercentage': PCBAJPercentage,
        'PCBReleasePercentage': PCBReleasePercentage,
        'PCBPurchase': PCBPurchase,
        'PCBShipment': PCBShipment,
        'PCBTax': PCBTax,
        'PCBRelease': PCBRelease,
        'PCBAJ': PCBAJ,
        'PCBTotalUSD': PCBTotalUSD,
        'PCBTotalMXN': PCBTotalMXN,
        'PCBPerMXN': PCBPerMXN,
        //Assembiles
        'assemblyLayers': assemblyLayers,
        'assemblyMPN': assemblyMPN,
        'assemblySMT': assemblySMT,
        'assemblyTH': assemblyTH,
        'assemblyDeliverTime': assemblyDeliveryTime,
        'assemblyAJPercentage': assemblyAJPercentage,
        'assemblyCost': assembly,
        'assemblyTax': assemblyTax,
        'assemblyAJ': assemblyAJ,
        'assemblyDhlCost': assemblyDhlCost,
        'assemblyTotalMXN': assemblyTotalMXN,
        'assemblyPerMXN': perAssemblyMXN
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else {
      return code;
    }
  }

  //--------------------------- Get Quotes by customer --------------------------
  static Future<List<QuoteClass>> getQuotesByCustomer(id_customer) async {
    var res = await http.post(
      Uri.parse("${url}quotes/select/customer"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_customer': id_customer,
      }),
    );
    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);

      return List.generate(
          jsonData.length,
          (i) => QuoteClass(
              id_Quote: jsonData[i]['id_quote'],
              id_Customer: jsonData[i]['id_customer'],
              id_Percentages: jsonData[i]['id_percentages'],
              iva: jsonData[i]['iva'],
              isr: jsonData[i]['isr'],
              date: jsonData[i]['date'],
              customerName: jsonData[i]['customerName'],
              quoteNumber: jsonData[i]['quoteNumber'],
              proyectName: jsonData[i]['proyectName'],
              requestedByName: jsonData[i]['requestedByName'],
              requestedByEmail: jsonData[i]['requestedByEmail'],
              attentionTo: jsonData[i]['attentionTo'],
              quantity: jsonData[i]['quantity'],
              dollarSell: jsonData[i]['dollarSell'],
              dollarBuy: jsonData[i]['dollarBuy'],
              deliverTimeInfo: jsonData[i]['deliverTimeInfo'],
              currency: jsonData[i]['currency'],
              conIva: jsonData[i]['conIva'],
              excelName: jsonData[i]['excelName'],
              componentsMPN: jsonData[i]['componentsMPN'],
              componentsAvailables: jsonData[i]['componentsAvailables'],
              componentsDeliverTime: jsonData[i]['componentsDeliverTime'],
              componentsAJPercentage: jsonData[i]['componentsAJPercentage'],
              digikeysAJPercentage: jsonData[i]['digikeyAJPercentage'],
              dhlCostComponent: jsonData[i]['dhlCostComponents'],
              componentsMouserCost: jsonData[i]['componentsMauserCost'],
              componentsIVA: jsonData[i]['componentsIva'],
              componentsAJ: jsonData[i]['componentsAJ'],
              totalComponentsUSD: jsonData[i]['totalComponentsUSD'],
              totalComponentsMXN: jsonData[i]['totalComponentsMXN'],
              perComponentMXN: jsonData[i]['perComponentMXN'],
              PCBName: jsonData[i]['PCBName'],
              PCBLayers: jsonData[i]['PCBLayers'],
              PCBSize: jsonData[i]['PCBSize'],
              PCBImage: jsonData[i]['PCBImage'],
              PCBColor: jsonData[i]['PCBColor'],
              PCBDeliveryTime: jsonData[i]['PCBDeliveryTime'],
              PCBdhlCost: jsonData[i]['PCBdhlCost'],
              PCBAJPercentage: jsonData[i]['PCBAJPercentage'],
              PCBReleasePercentage: jsonData[i]['PCBReleasePercentage'],
              PCBPurchase: jsonData[i]['PCBPurchase'],
              PCBShipment: jsonData[i]['PCBShipment'],
              PCBTax: jsonData[i]['PCBTax'],
              PCBRelease: jsonData[i]['PCBRelease'],
              PCBAJ: jsonData[i]['PCBAJ'],
              PCBTotalUSD: jsonData[i]['PCBTotalUSD'],
              PCBTotalMXN: jsonData[i]['PCBTotalMXN'],
              PCBPerMXN: jsonData[i]['PCBPerMXN'],
              assemblyLayers: jsonData[i]['assemblyLayers'],
              assemblyMPN: jsonData[i]['assemblyMPN'],
              assemblySMT: jsonData[i]['assemblySMT'],
              assemblyTH: jsonData[i]['assemblyTH'],
              assemblyDeliveryTime: jsonData[i]['assemblyDeliverTime'],
              assemblyAJPercentage: jsonData[i]['assemblyAJPercentage'],
              assembly: jsonData[i]['assemblyCost'],
              assemblyTax: jsonData[i]['assemblyTax'],
              assemblyAJ: jsonData[i]['assemblyAJ'],
              assemblyDhlCost: jsonData[i]["assemblyDhlCost"],
              assemblyTotalMXN: jsonData[i]['assemblyTotalMXN'],
              perAssemblyMXN: jsonData[i]['assemblyPerMXN']));
    } else if (res.statusCode == 404) {
      return List.empty();
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Get Quotes --------------------------
  static Future<List<QuoteClass>> getQuotes() async {
    var res = await http.get(Uri.parse("${url}quotes/get"));

    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);

      return List.generate(
          jsonData.length,
          (i) => QuoteClass(
              id_Quote: jsonData[i]['id_quote'],
              id_Customer: jsonData[i]['id_customer'],
              id_Percentages: jsonData[i]['id_percentages'],
              iva: jsonData[i]['iva'],
              isr: jsonData[i]['isr'],
              date: jsonData[i]['date'],
              customerName: jsonData[i]['customerName'],
              quoteNumber: jsonData[i]['quoteNumber'],
              proyectName: jsonData[i]['proyectName'],
              requestedByName: jsonData[i]['requestedByName'],
              requestedByEmail: jsonData[i]['requestedByEmail'],
              attentionTo: jsonData[i]['attentionTo'],
              quantity: jsonData[i]['quantity'],
              dollarSell: jsonData[i]['dollarSell'],
              dollarBuy: jsonData[i]['dollarBuy'],
              deliverTimeInfo: jsonData[i]['deliverTimeInfo'],
              currency: jsonData[i]['currency'],
              conIva: jsonData[i]['conIva'],
              excelName: jsonData[i]['excelName'],
              componentsMPN: jsonData[i]['componentsMPN'],
              componentsAvailables: jsonData[i]['componentsAvailables'],
              componentsDeliverTime: jsonData[i]['componentsDeliverTime'],
              componentsAJPercentage: jsonData[i]['componentsAJPercentage'],
              digikeysAJPercentage: jsonData[i]['digikeyAJPercentage'],
              dhlCostComponent: jsonData[i]['dhlCostComponents'],
              componentsMouserCost: jsonData[i]['componentsMauserCost'],
              componentsIVA: jsonData[i]['componentsIva'],
              componentsAJ: jsonData[i]['componentsAJ'],
              totalComponentsUSD: jsonData[i]['totalComponentsUSD'],
              totalComponentsMXN: jsonData[i]['totalComponentsMXN'],
              perComponentMXN: jsonData[i]['perComponentMXN'],
              PCBName: jsonData[i]['PCBName'],
              PCBLayers: jsonData[i]['PCBLayers'],
              PCBSize: jsonData[i]['PCBSize'],
              PCBImage: jsonData[i]['PCBImage'],
              PCBColor: jsonData[i]['PCBColor'],
              PCBDeliveryTime: jsonData[i]['PCBDeliveryTime'],
              PCBdhlCost: jsonData[i]['PCBdhlCost'],
              PCBAJPercentage: jsonData[i]['PCBAJPercentage'],
              PCBReleasePercentage: jsonData[i]['PCBReleasePercentage'],
              PCBPurchase: jsonData[i]['PCBPurchase'],
              PCBShipment: jsonData[i]['PCBShipment'],
              PCBTax: jsonData[i]['PCBTax'],
              PCBRelease: jsonData[i]['PCBRelease'],
              PCBAJ: jsonData[i]['PCBAJ'],
              PCBTotalUSD: jsonData[i]['PCBTotalUSD'],
              PCBTotalMXN: jsonData[i]['PCBTotalMXN'],
              PCBPerMXN: jsonData[i]['PCBPerMXN'],
              assemblyLayers: jsonData[i]['assemblyLayers'],
              assemblyMPN: jsonData[i]['assemblyMPN'],
              assemblySMT: jsonData[i]['assemblySMT'],
              assemblyTH: jsonData[i]['assemblyTH'],
              assemblyDeliveryTime: jsonData[i]['assemblyDeliverTime'],
              assemblyAJPercentage: jsonData[i]['assemblyAJPercentage'],
              assembly: jsonData[i]['assemblyCost'],
              assemblyTax: jsonData[i]['assemblyTax'],
              assemblyAJ: jsonData[i]['assemblyAJ'],
              assemblyDhlCost: jsonData[i]["assemblyDhlCost"],
              assemblyTotalMXN: jsonData[i]['assemblyTotalMXN'],
              perAssemblyMXN: jsonData[i]['assemblyPerMXN']));
    } else if (res.statusCode == 404) {
      return List.empty();
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Delete Quote --------------------------
  static Future<int> deleteQuote(id_quote) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}quotes/delete"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_quote': id_quote,
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Select Quote --------------------------
  static Future<List<QuoteClass>> selectQuote(id_quote) async {
    var res = await http.post(
      Uri.parse("${url}quotes/select"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_quote': id_quote,
      }),
    );

    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      return List.generate(
          jsonData.length,
          (i) => QuoteClass(
              id_Quote: jsonData[i]['id_quote'],
              id_Customer: jsonData[i]['id_customer'],
              id_Percentages: jsonData[i]['id_percentages'],
              iva: jsonData[i]['iva'],
              isr: jsonData[i]['isr'],
              date: jsonData[i]['date'],
              customerName: jsonData[i]['customerName'],
              quoteNumber: jsonData[i]['quoteNumber'],
              proyectName: jsonData[i]['proyectName'],
              requestedByName: jsonData[i]['requestedByName'],
              requestedByEmail: jsonData[i]['requestedByEmail'],
              attentionTo: jsonData[i]['attentionTo'],
              quantity: jsonData[i]['quantity'],
              dollarSell: jsonData[i]['dollarSell'],
              dollarBuy: jsonData[i]['dollarBuy'],
              deliverTimeInfo: jsonData[i]['deliverTimeInfo'],
              currency: jsonData[i]['currency'],
              conIva: jsonData[i]['conIva'],
              excelName: jsonData[i]['excelName'],
              componentsMPN: jsonData[i]['componentsMPN'],
              componentsAvailables: jsonData[i]['componentsAvailables'],
              componentsDeliverTime: jsonData[i]['componentsDeliverTime'],
              componentsAJPercentage: jsonData[i]['componentsAJPercentage'],
              digikeysAJPercentage: jsonData[i]['digikeysAJPercentage'],
              dhlCostComponent: jsonData[i]['dhlCostComponents'],
              componentsMouserCost: jsonData[i]['componentsMauserCost'],
              componentsIVA: jsonData[i]['componentsIva'],
              componentsAJ: jsonData[i]['componentsAJ'],
              totalComponentsUSD: jsonData[i]['totalComponentsUSD'],
              totalComponentsMXN: jsonData[i]['totalComponentsMXN'],
              perComponentMXN: jsonData[i]['perComponentMXN'],
              PCBName: jsonData[i]['PCBName'],
              PCBLayers: jsonData[i]['PCBLayers'],
              PCBSize: jsonData[i]['PCBSize'],
              PCBImage: jsonData[i]['PCBImage'],
              PCBColor: jsonData[i]['PCBColor'],
              PCBDeliveryTime: jsonData[i]['PCBDeliveryTime'],
              PCBdhlCost: jsonData[i]['PCBdhlCost'],
              PCBAJPercentage: jsonData[i]['PCBAJPercentage'],
              PCBReleasePercentage: jsonData[i]['PCBReleasePercentage'],
              PCBPurchase: jsonData[i]['PCBPurchase'],
              PCBShipment: jsonData[i]['PCBShipment'],
              PCBTax: jsonData[i]['PCBTax'],
              PCBRelease: jsonData[i]['PCBRelease'],
              PCBAJ: jsonData[i]['PCBAJ'],
              PCBTotalUSD: jsonData[i]['PCBTotalUSD'],
              PCBTotalMXN: jsonData[i]['PCBTotalMXN'],
              PCBPerMXN: jsonData[i]['PCBPerMXN'],
              assemblyLayers: jsonData[i]['assemblyLayers'],
              assemblyMPN: jsonData[i]['assemblyMPN'],
              assemblySMT: jsonData[i]['assemblySMT'],
              assemblyTH: jsonData[i]['assemblyTH'],
              assemblyDeliveryTime: jsonData[i]['assemblyDeliveryTime'],
              assemblyAJPercentage: jsonData[i]['assemblyAJPercentage'],
              assembly: jsonData[i]['assemblyCost'],
              assemblyTax: jsonData[i]['assemblyTax'],
              assemblyAJ: jsonData[i]['assemblyAJ'],
              assemblyDhlCost: jsonData[i]["assemblyDhlCost"],
              assemblyTotalMXN: jsonData[i]['assemblyTotalMXN'],
              perAssemblyMXN: jsonData[i]['assemblyPerMXN']));
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Update Quote --------------------------
  static Future<int> updateQuote(
      id_quote,
      id_customer,
      id_percentages,
      iva,
      isr,
      date,
      customerName,
      quoteNumber,
      proyectName,
      requestedByName,
      requestedByEmail,
      attentionTo,
      quantity,
      dollarSell,
      dollarBuy,
      deliverTimeInfo,
      currency,
      conIva,
      excelName,
      componentsMPN,
      componentsAvailables,
      componentsDeliverTime,
      componentsAJPercentage,
      digikeysAJPercentage,
      dhlCostComponent,
      componentsMouserCost,
      componentsIva,
      componentsAJ,
      totalComponentsUSD,
      totalComponentsMXN,
      perComponentMXN,
      PCBName,
      PCBLayers,
      PCBSize,
      PCBImage,
      PCBColor,
      PCBDeliveryTime,
      PCBdhlCost,
      PCBAJPercentage,
      PCBReleasePercentage,
      PCBPurchase,
      PCBShipment,
      PCBTax,
      PCBRelease,
      PCBAJ,
      PCBTotalUSD,
      PCBTotalMXN,
      PCBPerMXN,
      assemblyLayers,
      assemblyMPN,
      assemblySMT,
      assemblyTH,
      assemblyDeliveryTime,
      assemblyAJPercentage,
      assembly,
      assemblyTax,
      assemblyAJ,
      assemblyDhlCost,
      assemblyTotalMXN,
      perAssemblyMXN) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}quotes/update"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        //ID's
        'id_quote': id_quote,
        'id_customer': id_customer,
        'id_percentages': id_percentages,
        //General Percentages
        'iva': iva,
        'isr': isr,
        //General Data
        'date': date,
        'customerName': customerName,
        'quoteNumber': quoteNumber,
        'proyectName': proyectName,
        'requestedByName': requestedByName,
        'requestedByEmail': requestedByEmail,
        'attentionTo': attentionTo,
        //Information
        'quantity': quantity,
        'dollarSell': dollarSell,
        'dollarBuy': dollarBuy,
        'deliverTimeInfo': deliverTimeInfo,
        'currency': currency,
        'conIva': conIva,
        //Components
        'excelName': excelName,
        'componentsMPN': componentsMPN,
        'componentsAvailables': componentsAvailables,
        'componentsDeliverTime': componentsDeliverTime,
        'componentsAJPercentage': componentsAJPercentage,
        'digikeyAJPercentage': digikeysAJPercentage,
        'dhlCostComponents': dhlCostComponent,
        'componentsMauserCost': componentsMouserCost,
        'componentsIva': componentsIva,
        'componentsAJ': componentsAJ,
        'totalComponentsUSD': totalComponentsUSD,
        'totalComponentsMXN': totalComponentsMXN,
        'perComponentMXN': perComponentMXN,
        //PCB's
        'PCBName': PCBName,
        'PCBLayers': PCBLayers,
        'PCBSize': PCBSize,
        'PCBImage': PCBImage,
        'PCBColor': PCBColor,
        'PCBDeliveryTime': PCBDeliveryTime,
        'PCBdhlCost': PCBdhlCost,
        'PCBAJPercentage': PCBAJPercentage,
        'PCBReleasePercentage': PCBReleasePercentage,
        'PCBPurchase': PCBPurchase,
        'PCBShipment': PCBShipment,
        'PCBTax': PCBTax,
        'PCBRelease': PCBRelease,
        'PCBAJ': PCBAJ,
        'PCBTotalUSD': PCBTotalUSD,
        'PCBTotalMXN': PCBTotalMXN,
        'PCBPerMXN': PCBPerMXN,
        //Assembiles
        'assemblyLayers': assemblyLayers,
        'assemblyMPN': assemblyMPN,
        'assemblySMT': assemblySMT,
        'assemblyTH': assemblyTH,
        'assemblyDeliverTime': assemblyDeliveryTime,
        'assemblyAJPercentage': assemblyAJPercentage,
        'assemblyCost': assembly,
        'assemblyTax': assemblyTax,
        'assemblyAJ': assemblyAJ,
        'assemblyDhlCost': assemblyDhlCost,
        'assemblyTotalMXN': assemblyTotalMXN,
        'assemblyPerMXN': perAssemblyMXN
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }

  // ********************************************* Quotes Porcentajes ***************************************************** //
//--------------------------- Post Quotes Porcentajes --------------------------
  static Future<int> postPorcentajes(
      id_customer,
      iva,
      isr,
      dhlComponent,
      dhlPCB,
      dhlAssambly,
      liberation,
      ajComponents,
      ajDigikey,
      ajPCB,
      ajEnsamble) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}porcentajes/post"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_customer': id_customer,
        'iva': iva,
        'isr': isr,
        'dhlComponents': dhlComponent,
        'dhlPCB': dhlPCB,
        'dhlAssembly': dhlAssambly,
        'liberation': liberation,
        'ajComponents': ajComponents,
        'ajDigikey': ajDigikey,
        'ajPCB': ajPCB,
        'ajAssembly': ajEnsamble
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Select Quotes Porcentajes by Customer --------------------------
  static Future<List<PorcentajesClass>> selectPorcentajesByCustomer(
      id_customer) async {
    List<PorcentajesClass> list = [];

    var res = await http.post(
      Uri.parse("${url}porcentajes/select/customer"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_customer': id_customer,
      }),
    );

    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);

      return List.generate(
          jsonData.length,
          (i) => PorcentajesClass(
              id_porcentaje: jsonData[i]['id_porcentaje'],
              id_customer: jsonData[i]['id_customer'],
              iva: jsonData[i]['iva'],
              isr: jsonData[i]['isr'],
              dhlComponent: jsonData[i]['dhlComponents'],
              dhlPCB: jsonData[i]['dhlPCB'],
              dhlAssambly: jsonData[i]['dhlAssembly'],
              liberation: jsonData[i]['liberation'],
              ajComponents: jsonData[i]['ajComponents'],
              ajDigikey: jsonData[i]['ajDigikey'],
              ajPCB: jsonData[i]['ajPCB'],
              ajEnsamble: jsonData[i]['ajAssembly']));
    } else {
      return list;
    }
  }

  //--------------------------- Update Quotes Porcentajes --------------------------
  static Future<int> updatePorcentajes(
      id_porcentaje,
      id_customer,
      iva,
      isr,
      dhlComponent,
      dhlPCB,
      dhlAssambly,
      liberation,
      ajComponents,
      ajDigikey,
      ajPCB,
      ajEnsamble) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}porcentajes/update"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_porcentaje': id_porcentaje,
        'id_customer': id_customer,
        'iva': iva,
        'isr': isr,
        'dhlComponents': dhlComponent,
        'dhlPCB': dhlPCB,
        'dhlAssembly': dhlAssambly,
        'liberation': liberation,
        'ajComponents': ajComponents,
        'ajDigikey': ajDigikey,
        'ajPCB': ajPCB,
        'ajAssembly': ajEnsamble
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else if (res.statusCode != 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }

  // ********************************************* Quotes Digikey ***************************************************** //
//--------------------------- Post Quotes Digikey --------------------------
  static Future<int> postDigikey(id_quote, digikey, impuesto, aj) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}digikeys/post"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_quote': id_quote,
        'digikey': digikey,
        'impuesto': impuesto,
        'aj': aj
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Get Quotes Digikey --------------------------
  static Future<List<DigikeyClass>> getDigikey() async {
    var res = await http.get(Uri.parse("${url}digikeys/get"));

    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);

      return List.generate(
          jsonData.length,
          (i) => DigikeyClass(
              id_digikey: jsonData[i]['id_digikey'],
              id_quote: jsonData[i]['id_quote'],
              digikey: jsonData[i]['digikey'],
              impuesto: jsonData[i]['impuesto'],
              aj: jsonData[i]['aj']));
    } else if (res.statusCode == 404) {
      List<DigikeyClass> list = [];
      print("Error 404 not found");
      return list;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Select Digikeys by Quote --------------------------
  static Future<List<DigikeyClass>> selectDigikeysByQuote(id_quote) async {
    List<DigikeyClass> list = [];

    var res = await http.post(
      Uri.parse("${url}digikeys/select/quote"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_quote': id_quote,
      }),
    );

    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);

      return List.generate(
          jsonData.length,
          (i) => DigikeyClass(
              id_quote: jsonData[i]['id_quote'],
              digikey: jsonData[i]['digikey'],
              impuesto: jsonData[i]['impuesto'],
              aj: jsonData[i]['aj']));
    } else {
      return list;
    }
  }

  //--------------------------- Delete Quotes Digikey --------------------------
  static Future<int> deleteDigikey(id_quote) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}digikeys/delete"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_quote': id_quote,
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Update Quotes Digikey --------------------------
  static Future<int> updateDigikey(
      id_digikey, id_quote, digikey, impuesto, aj) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}digikeys/update"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_digikey': id_digikey,
        'id_quote': id_quote,
        'digikey': digikey,
        'impuesto': impuesto,
        'aj': aj
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else if (res.statusCode != 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }

  // ********************************************* Quotes Preview ***************************************************** //
//--------------------------- Post Quotes Preview --------------------------
  static Future<int> postPreview(
      id_quote, description, unitario, cantidad, total, notas) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}preview/post"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_quote': id_quote,
        'description': description,
        'unitario': unitario,
        'cantidad': cantidad,
        'total': total,
        'notas': notas
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Get Quotes Preview --------------------------
  static Future<List<QuoteTableClass>> getPreview() async {
    var res = await http.get(Uri.parse("${url}preview/get"));

    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);

      return List.generate(
          jsonData.length,
          (i) => QuoteTableClass(
              id_quotePreview: jsonData[i]['id_quotePreview'],
              id_quote: jsonData[i]['id_quote'],
              description: jsonData[i]['description'],
              unitario: jsonData[i]['unitario'],
              cantidad: jsonData[i]['cantidad'],
              total: jsonData[i]['total'],
              notas: jsonData[i]['notas']));
    } else if (res.statusCode == 404) {
      List<QuoteTableClass> list = [];
      print("Error 404 not found");
      return list;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Select Preview by Quote --------------------------
  static Future<List<QuoteTableClass>> selectPreviewByQuote(id_quote) async {
    List<QuoteTableClass> list = [];

    var res = await http.post(
      Uri.parse("${url}preview/select/quote"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_quote': id_quote,
      }),
    );

    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);

      return List.generate(
          jsonData.length,
          (i) => QuoteTableClass(
              id_quotePreview: jsonData[i]['id_quotePreview'],
              id_quote: jsonData[i]['id_quote'],
              description: jsonData[i]['description'],
              unitario: jsonData[i]['unitario'],
              cantidad: jsonData[i]['cantidad'],
              total: jsonData[i]['total'],
              notas: jsonData[i]['notas']));
    } else {
      return list;
    }
  }

  //--------------------------- Delete Quotes Preview --------------------------
  static Future<int> deletePreview(id_quote) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}preview/delete"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_quote': id_quote,
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }

  //--------------------------- Update Quotes Preview --------------------------
  static Future<int> updatePreview(id_quotePreview, id_quote, description,
      unitario, cantidad, total, notas) async {
    int code;

    var res = await http.post(
      Uri.parse("${url}preview/update"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_quotePreview': id_quotePreview,
        'id_quote': id_quote,
        'description': description,
        'unitario': unitario,
        'cantidad': cantidad,
        'total': total,
        'notas': notas
      }),
    );

    if (res.statusCode == 200) {
      code = res.statusCode;
      return code;
    } else if (res.statusCode != 200) {
      code = res.statusCode;
      return code;
    } else {
      throw res.statusCode;
    }
  }
}
