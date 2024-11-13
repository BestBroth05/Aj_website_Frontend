import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/views/footer/footer.dart';
import 'package:guadalajarav2/views/main_top_bar.dart/main_top_bar.dart';
import 'package:guadalajarav2/views/services_view/firmware_service_section.dart';
import 'package:guadalajarav2/views/services_view/hardware_service_section.dart';
import 'package:guadalajarav2/views/services_view/industrial_service_section.dart';
import 'package:guadalajarav2/views/services_view/manufacture_service_section.dart';
import 'package:guadalajarav2/views/services_view/software_service_section.dart';

class ServicesView extends StatefulWidget {
  final AJRoute service;

  ServicesView(this.service, {Key? key}) : super(key: key);

  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {
  Map<AJRoute, Widget> services = {
    AJRoute.hardware: HardwareServiceSection(),
    AJRoute.firmware: FirmwareServiceSection(),
    AJRoute.software: SoftwareServiceSection(),
    AJRoute.industrial: IndustrialServiceSection(),
    AJRoute.manufacture: ManufactureServiceSection(),
  };

  AJRoute selected = AJRoute.hardware;

  TextStyle sideMenuStyle = TextStyle(color: teal.add(black, 0.8));

  @override
  void initState() {
    super.initState();
    Widget? s = services[widget.service];
    if (s != null) {
      selected = widget.service;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      child: Column(
        children: [
          MainTopBar(),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 8,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.1,
                              ),
                              child: services[selected]!,
                            ),
                          ),
                        ],
                      ),
                      Footer(),
                    ],
                  ),
                ),
                Container(
                  height: height,
                  padding: EdgeInsets.only(left: 50, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        'Services',
                        maxLines: 1,
                        minFontSize: 1,
                        style: sideMenuStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: services.keys
                            .map(
                              (e) => TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: AutoSizeText(
                                  e.name.toTitle(),
                                  style: sideMenuStyle.copyWith(
                                    fontWeight: selected == e
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    decoration: selected == e
                                        ? TextDecoration.underline
                                        : null,
                                  ),
                                ),
                                onPressed: () => setState(
                                  () => openLink(
                                    context,
                                    e.url,
                                    isRoute: true,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
