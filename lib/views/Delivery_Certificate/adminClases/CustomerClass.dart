class CustomersClass {
  int? id_customer;
  int? id_Percentages;
  String? name;
  String? email;
  String? rfc;
  String? contact;
  String? phone;
  int? lada;
  String? country;
  String? state;
  String? city;
  String? street;
  int? cp;
  String? logo;
  CustomersClass(
      {this.id_customer,
      this.name,
      this.email,
      this.rfc,
      this.contact,
      this.phone,
      this.lada,
      this.country,
      this.state,
      this.city,
      this.street,
      this.cp,
      this.logo});

  Map<String, dynamic> toMap() {
    var map = {
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
      'street': street,
      'cp': cp,
      'logo': logo
    };
    return map;
  }

  CustomersClass.fromMap(Map<String, dynamic> map) {
    id_customer = map['id_customer'];
    name = map['name'];
    email = map['email'];
    rfc = map['rfc'];
    contact = map['contact'];
    phone = map['phone'];
    lada = map['lada'];
    country = map['country'];
    state = map['state'];
    city = map['city'];
    street = map['street'];
    cp = map['cp'];
    logo = map['logo'];
  }
}
