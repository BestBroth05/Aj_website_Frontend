// ------------------ Product ------------------ //

class ProductCertificateDelivery {
  int? id_producto;
  int? id_entrega;
  int? id_OC;
  int? id_quote;
  double? precioUnitario;
  int? cantidad;
  String? descripcion;
  double? importe;
  String? image;
  String? type;
  ProductCertificateDelivery(
      {this.id_producto,
      this.id_entrega,
      this.id_OC,
      this.id_quote,
      this.precioUnitario,
      this.cantidad,
      this.descripcion,
      this.importe,
      this.image,
      this.type});
  Map<String, dynamic> toMap() {
    var map = {
      'id_producto': id_producto,
      'id_entrega': id_entrega,
      'id_OC': id_OC,
      'id_quote': id_quote,
      'precioUnitario': precioUnitario,
      'cantidad': cantidad,
      'descripcion': descripcion,
      'importe': importe,
      'image': image,
      'type': type
    };
    return map;
  }

  ProductCertificateDelivery.fromMap(Map<String, dynamic> map) {
    id_producto = map['id_producto'];
    id_entrega = map['id_entrega'];
    id_OC = map['id_OC'];
    id_quote = map['id_quote'];
    precioUnitario = map['precioUnitario'];
    cantidad = map['cantidad'];
    descripcion = map['descripcion'];
    importe = map['importe'];
    image = map['image'];
    type = map['type'];
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
