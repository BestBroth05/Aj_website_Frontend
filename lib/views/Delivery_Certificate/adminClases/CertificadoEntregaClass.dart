// ------------------ Certificado de entrega Class ------------------ //

class ClassCertificadoEntrega {
  int? id_Entrega;
  int? id_OC;
  String? certificadoEntrega;
  String? Fecha;
  String? Direccion;
  String? Solicitante;
  String? Remitente;
  String? Notes;
  ClassCertificadoEntrega(
      {this.id_Entrega,
      this.id_OC,
      this.certificadoEntrega,
      this.Fecha,
      this.Direccion,
      this.Solicitante,
      this.Remitente,
      this.Notes});
  Map<String, dynamic> toMap() {
    var map = {
      'id_Entrega': id_Entrega,
      'id_OC': id_OC,
      'certificadoEntrega': certificadoEntrega,
      'Fecha': Fecha,
      'Direccion': Direccion,
      'Solicitante': Solicitante,
      'Remitente': Remitente,
      'Notes': Notes
    };
    return map;
  }

  ClassCertificadoEntrega.fromMap(Map<String, dynamic> map) {
    id_Entrega = map['id_Entrega'];
    id_OC = map['id_OC'];
    certificadoEntrega = map['certificadoEntrega'];
    Fecha = map['Fecha'];
    Direccion = map['Direccion'];
    Solicitante = map['Solicitante'];
    Remitente = map['Remitente'];
    Notes = map['Notes'];
  }
}
