// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/main.dart';
import 'package:guadalajarav2/utils/GeneratePageRoute.dart';
import 'package:guadalajarav2/views/about_view/about_view.dart';

// String get main_url => 'http://www.aj-electronic-design.com';
String get main_url => '/';
String get privacy_url =>
    'https://drive.google.com/uc?export=download&id=1PWB2a83SjjwmplPArXrCtLVtp9SnO34B';

void openLink(
  BuildContext context,
  String url, {
  bool isRoute = false,
  bool newTab = false,
  bool newWindow = false,
  bool isDownload = false,
}) {
  if (videoPlayerController != null) {
    videoPlayerController!.pause();
  }
  if (isDownload) {
    html.window.open(url, '_blank');
  } else {
    if (isRoute) {
      if (url == RoutesName.current) {
        return;
      }
      Navigator.pushNamed(context, url);
    } else {
      html.window.open(
        url,
        newTab || newWindow ? '_blank' : '_self',
        newWindow ? 'location=yes' : null,
      );
    }
  }
}
