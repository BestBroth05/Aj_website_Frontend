enum ProductStatus { active, obsolete }

extension StatusExtension on ProductStatus {
  String get name {
    return this.toString().split('.')[1];
  }
}
