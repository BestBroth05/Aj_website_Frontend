class Mpn {
  final String mpn;
  int? _quantity;
  double? _unitPrice;

  Mpn({required this.mpn});

  set quantity(int? value) {
    _quantity = value;
  }

  set unitPrice(double? value) {
    _unitPrice = value;
  }

  int get quantity => _quantity == null ? 0 : _quantity!;
  double get unitPrice => _unitPrice == null ? 0 : _unitPrice!;

  String get quantityString =>
      _quantity == null ? 'N/A' : _quantity!.toString();
  String get unitPriceString =>
      _unitPrice == null ? 'N/A' : _unitPrice!.toStringAsFixed(2);

  @override
  String toString() {
    // TODO: implement toString
    return '$mpn\nQ: $quantityString    \$:$unitPriceString';
  }
}
