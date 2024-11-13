import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/utils/GeneratePageRoute.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/views/dialogs/privacy_dialog.dart';

class MainTopBarButton extends StatefulWidget {
  final String text;
  final AJRoute? route;
  final String? downloadLink;
  final Widget? icon;

  MainTopBarButton({
    Key? key,
    this.text = 'Home',
    this.route,
    this.icon,
    this.downloadLink,
  }) : super(key: key);

  @override
  State<MainTopBarButton> createState() => _MainTopBarButtonState();
}

class _MainTopBarButtonState extends State<MainTopBarButton> {
  bool get isSelected {
    if (widget.route == AJRoute.services) {
      if (RoutesName.current == AJRoute.hardware.url ||
          RoutesName.current == AJRoute.software.url ||
          RoutesName.current == AJRoute.firmware.url ||
          RoutesName.current == AJRoute.industrial.url ||
          RoutesName.current == AJRoute.manufacture.url) {
        return true;
      }
    }

    return widget.route != null && widget.route!.url == RoutesName.current;
  }

  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: width * 0.05,
      height: height * 0.05,
      alignment: Alignment.center,
      child: Theme(
        data: ThemeData(
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: teal,
              ),
        ),
        child: InkWell(
          onHover: (value) => setState(() => isHovering = value),
          child: Row(
            children: [
              widget.icon != null ? widget.icon! : Container(),
              AutoSizeText(
                widget.text,
                style: TextStyle(
                  color: teal.add(black, 0.2),
                  fontWeight: isHovering || isSelected
                      ? FontWeight.w900
                      : FontWeight.w400,
                  decoration: isSelected ? TextDecoration.underline : null,
                  decorationColor: teal.add(black, 0.5),
                ),
              ),
            ],
          ),
          onTap: widget.route == null
              ? widget.downloadLink == null
                  ? null
                  : () => openDialog(
                        context,
                        container: PrivacyDialog(
                          widget.downloadLink!,
                        ),
                      )
              : () => openLink(context, widget.route!.url, isRoute: true),
        ),
      ),
    );
  }
}
