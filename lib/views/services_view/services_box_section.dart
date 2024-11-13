import 'package:flutter/material.dart';
import 'package:guadalajarav2/views/services_view/services_box.dart';

class ServicesBoxSection extends StatelessWidget {
  final List<List<String>> texts;

  const ServicesBoxSection(this.texts, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        texts.length,
        (y) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              texts[y].length,
              (x) => ServiceBox(texts[y][x]),
            ),
          ),
        ),
      ),
    );
  }
}
