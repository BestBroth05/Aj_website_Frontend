class Company {
  int? id;
  String? name;
  String? img;

  Company(this.id, this.name, this.img);
}

final List<Company> getCompany = [
  Company(1, "CIU", "assets/images/ciu_logo.png"),
  Company(2, "Intel", "assets/images/intel_logo.png"),
  Company(3, "MABE", "assets/images/mabe_logo.png"),
];
