class QuoteClass {
  //ID's
  int? id_Quote;
  int? id_Customer;
  int? id_Percentages;
  //General percentages
  double? iva;
  double? isr;
  //General data
  int? quoteType;
  String? date;
  String? customerName;
  String? quoteNumber;
  String? proyectName;
  String? requestedByName;
  String? requestedByEmail;
  String? attentionTo;
  //Informative
  int? quantity;
  double? dollarSell;
  double? dollarBuy;
  String? deliverTimeInfo;
  String? currency;
  bool? conIva;
  //Components
  String? excelName;
  int? componentsMPN;
  int? componentsAvailables;
  String? componentsDeliverTime;
  double? componentsAJPercentage;
  double? digikeysAJPercentage;
  double? dhlCostComponent;
  double? componentsMouserCost;
  double? componentsIVA;
  double? componentsAJ;
  double? totalComponentsUSD;
  double? totalComponentsMXN;
  double? perComponentMXN;
  //PCB
  String? PCBName;
  String? PCBLayers;
  String? PCBSize;
  String? PCBImage;
  String? PCBColor;
  String? PCBDeliveryTime;
  double? PCBdhlCost;
  double? PCBAJPercentage;
  double? PCBReleasePercentage;
  double? PCBPurchase;
  double? PCBShipment;
  double? PCBTax;
  double? PCBRelease;
  double? PCBAJ;
  double? PCBTotalUSD;
  double? PCBTotalMXN;
  double? PCBPerMXN;
  //Assembly
  String? assemblyLayers;
  int? assemblyMPN;
  int? assemblySMT;
  int? assemblyTH;
  String? assemblyDeliveryTime;
  double? assemblyAJPercentage;
  double? assemblyDhlCost;
  double? assembly;
  double? assemblyTax;
  double? assemblyAJ;
  double? assemblyTotalMXN;
  double? perAssemblyMXN;
  QuoteClass(
      {
      //ID's
      this.id_Quote,
      this.id_Customer,
      this.id_Percentages,
      //General percentages
      this.iva,
      this.isr,
      //General data
      this.quoteType,
      this.date,
      this.customerName,
      this.quoteNumber,
      this.proyectName,
      this.requestedByName,
      this.requestedByEmail,
      this.attentionTo,
      //Informative
      this.quantity,
      this.dollarSell,
      this.dollarBuy,
      this.deliverTimeInfo,
      this.currency,
      this.conIva,
      //Components
      this.excelName,
      this.componentsMPN,
      this.componentsAvailables,
      this.componentsDeliverTime,
      this.dhlCostComponent,
      this.componentsAJPercentage,
      this.digikeysAJPercentage,
      this.componentsMouserCost,
      this.componentsIVA,
      this.componentsAJ,
      this.totalComponentsUSD,
      this.totalComponentsMXN,
      this.perComponentMXN,
      //PCB
      this.PCBName,
      this.PCBLayers,
      this.PCBSize,
      this.PCBImage,
      this.PCBColor,
      this.PCBDeliveryTime,
      this.PCBdhlCost,
      this.PCBAJPercentage,
      this.PCBReleasePercentage,
      this.PCBPurchase,
      this.PCBShipment,
      this.PCBTax,
      this.PCBRelease,
      this.PCBAJ,
      this.PCBTotalUSD,
      this.PCBTotalMXN,
      this.PCBPerMXN,
      //Assembly
      this.assemblyLayers,
      this.assemblyMPN,
      this.assemblySMT,
      this.assemblyTH,
      this.assemblyDeliveryTime,
      this.assemblyAJPercentage,
      this.assembly,
      this.assemblyTax,
      this.assemblyAJ,
      this.assemblyDhlCost,
      this.assemblyTotalMXN,
      this.perAssemblyMXN});
  Map<String, dynamic> toMap() {
    var map = {
      //ID's
      'id_Quote': id_Quote,
      'id_Customer': id_Customer,
      'id_Percentages': id_Percentages,
      //General percentages
      'IVA': iva,
      'ISR': isr,
      //General data
      'quoteType': quoteType,
      'date': date,
      'customerName': customerName,
      'quoteNumber': quoteNumber,
      'proyectName': proyectName,
      'requestedByName': requestedByName,
      'requestedByEmail': requestedByEmail,
      'attentionTo': attentionTo,
      //Informative
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
      'dhlCostComponent': dhlCostComponent,
      'componentsAJPercentage': componentsAJPercentage,
      'digikeysAJPercentage': digikeysAJPercentage,
      'componentsMouserCost': componentsMouserCost,
      'componentsIVA': componentsIVA,
      'componentsAJ': componentsAJ,
      'totalComponentsUSD': totalComponentsUSD,
      'totalComponentsMXN': totalComponentsMXN,
      'perComponentMXN': perComponentMXN,
      //PCB
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
      //Assembly
      'assemblyLayers': assemblyLayers,
      'assemblyMPN': assemblyMPN,
      'assemblySMT': assemblySMT,
      'assemblyTH': assemblyTH,
      'assemblyDeliveryTime': assemblyDeliveryTime,
      'assemblyAJPercentage': assemblyAJPercentage,
      'assembly': assembly,
      'assemblyTax': assemblyTax,
      'assemblyAJ': assemblyAJ,
      'assemblyDhlCost': assemblyDhlCost,
      'assemblyTotalMXN': assemblyTotalMXN,
      'perAssemblyMXN': perAssemblyMXN,
    };
    return map;
  }
}
