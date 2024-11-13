import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/services_view/services_belt.dart';
import 'package:guadalajarav2/views/services_view/services_section_title.dart';
import 'package:guadalajarav2/views/services_view/services_sub_section.dart';

class IndustrialServiceSection extends StatelessWidget {
  const IndustrialServiceSection({Key? key}) : super(key: key);

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
              'Industrial',
              imageUrl: 'industrial_design',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: ServiceSubSection(
              'Services',
              [
                'Administration and Direction of the design project. ',
                'Design research and detection of opportunities and needs.',
                'Product at the concept level.',
                'Product at the level of functional models MVP.',
                'Product at the manufacturing level.',
                'Mechanical solutions.',
                'Design of molds and production tools.',
                'Simulations and analysis of finite elements.',
                '3D modeling.',
                'Materials and production technologies for design and manufacturing.',
                'National and international providers.',
                'Digital manufacturing and large format rapid prototyping.',
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            // child: ServicesBelt(
            //   'Development Tools',

            //   urlRoot: 'software_design_tools',
            // ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            // child: ServicesBelt(
            //   'Some of our clients',
            //   imagesURLs: [
            //     'delphian.png',
            //     'ditra.png',
            //     'insight.png',
            //     'zoltek.png',
            //   ],
            //   urlRoot: 'hardware_clients',
            // ),
          ),
        ],
      ),
    );
  }
}
