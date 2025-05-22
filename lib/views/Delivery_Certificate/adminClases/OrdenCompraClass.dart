class OrdenCompraClass {
  int? id_customer;
  int? id_OC;
  String? OC;
  String? fecha_inicio;
  String? fecha_fin;
  String? solicitante;
  String? prioridad;
  String? pais;
  String? estado;
  String? ciudad;
  String? street;
  int? cp;
  String? moneda;
  String? descripcion;
  int? cantidad;
  String? prefijo;
  double? precioUnitario;
  OrdenCompraClass(
      {this.id_customer,
      this.id_OC,
      this.OC,
      this.fecha_inicio,
      this.fecha_fin,
      this.solicitante,
      this.prioridad,
      this.pais,
      this.estado,
      this.ciudad,
      this.street,
      this.cp,
      this.moneda,
      this.descripcion,
      this.cantidad,
      this.prefijo,
      this.precioUnitario});

  Map<String, dynamic> toMap() {
    var map = {
      'id_customer': id_customer,
      'id_OC': id_OC,
      'OC': OC,
      'fecha_inicio': fecha_inicio,
      'fecha_fin': fecha_fin,
      'solicitante': solicitante,
      'prioridad': prioridad,
      'pais': pais,
      'estado': estado,
      'ciudad': ciudad,
      'street': street,
      'cp': cp,
      'moneda': moneda,
      'descripcion': descripcion,
      'cantidad': cantidad,
      'prefijo': prefijo,
      'precioUnitario': precioUnitario
    };
    return map;
  }

  OrdenCompraClass.fromMap(Map<String, dynamic> map) {
    id_customer = map['id_customer'];
    id_OC = map['id_OC'];
    OC = map['OC'];
    fecha_inicio = map['fecha_inicio'];
    fecha_fin = map['fecha_fin'];
    solicitante = map['solicitante'];
    prioridad = map['prioridad'];
    pais = map['pais'];
    estado = map['estado'];
    ciudad = map['ciudad'];
    street = map['street'];
    cp = map['cp'];
    moneda = map['moneda'];
    descripcion = map['descripcion'];
    cantidad = map['cantidad'];
    prefijo = map['prefijo'];
    precioUnitario = map['precioUnitario'];
  }
}
