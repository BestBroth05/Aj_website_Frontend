import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/services_view/services_belt.dart';
import 'package:guadalajarav2/views/services_view/services_box_section.dart';
import 'package:guadalajarav2/views/services_view/services_section_title.dart';
import 'package:guadalajarav2/views/services_view/services_sub_section.dart';

class HardwareServiceSection extends StatelessWidget {
  const HardwareServiceSection({Key? key}) : super(key: key);

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
              'hardware',
              imageUrl: 'hardware',
              subtitle: 'consultancy, design, production',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: ServiceSubSection(
              'Services',
              [
                'Custom design',
                'Prototypes and proof of concepts',
                'Technology migrations',
                'Product development',
                'Design consultancy ',
                'Component selection',
                'Documentation',
                'Contact with suppliers',
              ],
              imgUrl: 'assets/images/hardware_services_1.png',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: ServicesBoxSection([
              ['component selection', 'libraries', 'eschematic capture'],
              ['placement', 'layout', 'fabrication files'],
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: ServicesBelt(
              'Design Tools',
              urlRoot: 'hardware/herramientas',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: ServiceSubSection(
              'Design Capabilities',
              [
                'Multilayer design, up tp 14 layers',
                'AC High Voltage',
                'SMPS',
                'Analog signals sensing and mixing signals',
                'High-Speed',
                'Impedance Control',
                '“Length-Match”',
                'HDI design',
                'BGA Breakout',
                'RF Antenas',
                'EMC',
                'Rigid, Flex, Rigid-Flex PCB',
                'Adaptable designs to fit in enclousures',
                'Fixtures',
                'ICT',
                'PCB panelize',
              ],
              isReversed: true,
              imgUrl: 'assets/images/hardware_services_2.png',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: ServicesBelt(
              'Some of our clients',
              urlRoot: 'hardware/clientes',
            ),
          ),
        ],
      ),
    );
  }
}
