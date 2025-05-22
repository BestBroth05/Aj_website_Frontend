class Transaccionclass {
  String? idUnidad;
  String? fecha;
  String? hora;
  String? estado;
  String? ruta;
  String? unidad;
  double? latitud;
  double? longitud;
  double? tarifa;
  int? tipoTarifa;
  int? tipoDebitacion;
  String? denominaciones;

  Transaccionclass(
      {this.idUnidad,
      this.fecha,
      this.hora,
      this.estado,
      this.ruta,
      this.unidad,
      this.latitud,
      this.longitud,
      this.tarifa,
      this.tipoTarifa,
      this.tipoDebitacion,
      this.denominaciones});
}
