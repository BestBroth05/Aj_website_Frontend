class DigikeyClass {
  int? id_digikey;
  int? id_quote;
  double? digikey;
  double? impuesto;
  double? aj;
  DigikeyClass(
      {this.id_digikey, this.id_quote, this.digikey, this.impuesto, this.aj});
  Map<String, dynamic> toMap() {
    var map = {
      'id_digikey': id_digikey,
      'id_quote': id_quote,
      'digikey': digikey,
      'impuesto': impuesto,
      'aj': aj
    };
    return map;
  }

  DigikeyClass.fromMap(Map<String, dynamic> map) {
    id_digikey = map['id_digikey'];
    id_quote = map['id_quote'];
    digikey = map['digikey'];
    impuesto = map['impuesto'];
    aj = map['aj'];
  }
}
