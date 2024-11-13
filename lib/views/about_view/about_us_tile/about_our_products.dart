import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/about_view/about_us_tile/product_tile.dart';

class AboutOurProducts extends StatelessWidget {
  const AboutOurProducts({Key? key}) : super(key: key);

  List<ProductTile> get products => [
        ProductTile(title: 'Products', value: '800'),
        ProductTile(title: 'Clients', value: '100'),
        ProductTile(title: 'Products', value: '800'),
        ProductTile(title: 'Products', value: '800'),
        ProductTile(title: 'Products', value: '800'),
        ProductTile(title: 'Products', value: '800'),
      ];

  int get crossAxisCount => 4;
  int get mainAxisCount => (products.length / crossAxisCount).ceil();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0 * mainAxisCount + 100,
      width: width,
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: width * 0.1),
        child: Column(
          children: List.generate(
            mainAxisCount,
            (i) => Expanded(
              child: Row(
                children: List.generate(
                  crossAxisCount,
                  (j) => (i * crossAxisCount + j) >= products.length
                      ? Container()
                      : Expanded(child: products[i * crossAxisCount + j]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
