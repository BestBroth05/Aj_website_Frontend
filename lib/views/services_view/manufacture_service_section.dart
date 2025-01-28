import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/services_view/services_belt.dart';
import 'package:guadalajarav2/views/services_view/services_box_section.dart';
import 'package:guadalajarav2/views/services_view/services_section_title.dart';
import 'package:guadalajarav2/views/services_view/services_sub_section.dart';

class ManufactureServiceSection extends StatelessWidget {
  const ManufactureServiceSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.8,
      // decoration: BoxDecoration(
      //   border: Border.symmetric(
      //     vertical: BorderSide(color: gray),
      //   ),
      // ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: ServiceSectionTitle(
              'manufacture',
              imageUrl: 'manufacture',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: ServiceSubSection(
              'Services',
              [
                'Prototype, low volume, partial assembly.',
                'SMT and TH assembly',
                'Quick prototype assembly',
                'Bring Up',
                'Purchase of materials',
                'Custom oven profiles',
                'Visual and electrical inspection',
                'Programming',
                'Tests with Fixture',
                'Packaging and national & international shipments',
                'Design consultancy',
              ],
              imgUrl: 'assets/images/manufacture_services_1.png',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: ServicesBoxSection([
              ['paste application', 'component placement', 'baked'],
              ['visual inspection', 'cleaning', 'packaging'],
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: ServiceSubSection(
              'Other Services',
              [
                'Inventory Control',
                'Custom import',
                'Repair',
                'Product Assembly',
              ],
              isReversed: true,
              imgUrl: 'assets/images/manufacture_services_2.png',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: ServicesBelt(
              'Some of our clients',
              // imagesURLs: [
              //   'delphian.png',
              //   'ditra.png',
              //   'insight.png',
              //   'zoltek.png',
              // ],
              urlRoot: 'manufacture/clientes',
            ),
          ),
        ],
      ),
    );
  }
}
