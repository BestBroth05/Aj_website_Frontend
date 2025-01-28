import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/services_view/services_belt.dart';
import 'package:guadalajarav2/views/services_view/services_section_title.dart';
import 'package:guadalajarav2/views/services_view/services_sub_section.dart';

class SoftwareServiceSection extends StatelessWidget {
  const SoftwareServiceSection({Key? key}) : super(key: key);

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
              'Software',
              imageUrl: 'software',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: ServiceSubSection(
              'Services',
              [
                'UI/UX',
                'Web',
                'Data base',
                'Servers',
                'Cloud Computer',
                'Technology migrations',
                'Algorithms',
                'Image Processing',
                'Custom designs',
                'Prototypes and proofs of concept',
                'Mobile Apps (iOS and Android)',
              ],
              imgUrl: 'assets/images/software_services_1.png',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: ServicesBelt(
              'Development Tools',
              // imagesURLs: [
              //   'java.png',
              //   'nodejs.png',
              //   'flutter.png',
              //   'aws.png',
              //   'sql.png',
              //   'json.png',
              // ],
              urlRoot: 'software/herramientas',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: ServicesBelt(
              'Our clients',
              // imagesURLs: [
              //   'delphian.png',
              //   'ditra.png',
              //   'insight.png',
              //   'zoltek.png',
              // ],
              urlRoot: 'software/clientes',
            ),
          ),
        ],
      ),
    );
  }
}
