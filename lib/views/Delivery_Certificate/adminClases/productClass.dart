// ------------------ Product ------------------ //

class ProductCertificateDelivery {
  int? id_producto;
  int? id_entrega;
  int? id_OC;
  double? precioUnitario;
  int? cantidad;
  String? descripcion;
  double? importe;
  ProductCertificateDelivery(
      {this.id_producto,
      this.id_entrega,
      this.id_OC,
      this.precioUnitario,
      this.cantidad,
      this.descripcion,
      this.importe});
  Map<String, dynamic> toMap() {
    var map = {
      'id_producto': id_producto,
      'id_entrega': id_entrega,
      'id_OC': id_OC,
      'precioUnitario': precioUnitario,
      'cantidad': cantidad,
      'descripcion': descripcion,
      'importe': importe,
    };
    return map;
  }

  ProductCertificateDelivery.fromMap(Map<String, dynamic> map) {
    id_producto = map['id_producto'];
    id_entrega = map['id_entrega'];
    id_OC = map['id_OC'];
    precioUnitario = map['precioUnitario'];
    cantidad = map['cantidad'];
    descripcion = map['descripcion'];
    importe = map['importe'];
  }
}

class TotalProduct {
  String? string;
  String? int;
  TotalProduct({this.string, this.int});
  Map<String, dynamic> toMap() {
    var map = {
      'string': string,
      'int': int,
    };
    return map;
  }

  TotalProduct.fromMap(Map<String, dynamic> map) {
    string = map['string'];
    int = map['int'];
  }
}
