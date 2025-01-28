import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/services_view/services_belt.dart';
import 'package:guadalajarav2/views/services_view/services_section_title.dart';
import 'package:guadalajarav2/views/services_view/services_sub_section.dart';

class FirmwareServiceSection extends StatelessWidget {
  const FirmwareServiceSection({Key? key}) : super(key: key);

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
              'firmware',
              imageUrl: 'firmware',
              subtitle: 'consultancy, architecture, development',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: ServiceSubSection(
              'Services',
              [
                'Prototypes and proof of concepts',
                'Technology migrations',
                'Product development',
                'Consultancy',
                'Drivers',
                'Architecture Design',
              ],
              imgUrl: 'assets/images/firmware_services_1.png',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: ServicesBelt(
              'Processors',
              // imagesURLs: [
              //   'nxp.png',
              //   'renesas.png',
              //   'stlife.png',
              //   'texas.png',
              // ],
              urlRoot: 'firmware/Procesadores',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: ServiceSubSection(
              'Design Capabilities',
              [
                'Specification Analysis ',
                'Development code: C & embedded linux',
                'IOT (WiFi, BLE, LoRA, etc)',
                'Graphics',
                'RTOS',
                'RFID',
                'Analog',
                'Mathematical algorithms ',
                'Power',
                'Voice assistants ',
                'Communication protocols (USB, Ethernet, Profibus, etc)',
              ],
              isReversed: true,
              imgUrl: 'assets/images/firmware_services_2.png',
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
              urlRoot: 'firmware/clientes',
            ),
          ),
        ],
      ),
    );
  }
}
