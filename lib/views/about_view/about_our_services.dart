import 'package:flutter/material.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/views/about_view/about_us_service_tile.dart';

class AboutOurServices extends StatefulWidget {
  AboutOurServices({Key? key}) : super(key: key);

  @override
  State<AboutOurServices> createState() => _AboutOurServicesState();
}

class _AboutOurServicesState extends State<AboutOurServices> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AboutUsServiceTile(
                  'hardware',
                  imagePath: 'hardware',
                  onTap: () => openLink(
                    context,
                    AJRoute.hardware.url,
                    isRoute: true,
                  ),
                ),
                AboutUsServiceTile(
                  'firmware',
                  imagePath: 'firmware',
                  onTap: () => openLink(
                    context,
                    AJRoute.firmware.url,
                    isRoute: true,
                  ),
                ),
                AboutUsServiceTile(
                  'software',
                  imagePath: 'software',
                  onTap: () => openLink(
                    context,
                    AJRoute.software.url,
                    isRoute: true,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 150 * 2 + 300 * 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AboutUsServiceTile(
                    'industrial design',
                    imagePath: 'industrial_design',
                    onTap: () => openLink(
                      context,
                      AJRoute.industrial.url,
                      isRoute: true,
                    ),
                  ),
                  AboutUsServiceTile(
                    'manufacture',
                    imagePath: 'manufacture',
                    onTap: () => openLink(
                      context,
                      AJRoute.manufacture.url,
                      isRoute: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
