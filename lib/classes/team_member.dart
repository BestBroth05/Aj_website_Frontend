import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';

class TeamMember {
  final String name;
  final String position;
  final String description;
  String? facebook;
  String? instagram;
  String? linkedin;

  String? image;
  late Color color;

  TeamMember({
    required this.name,
    required this.position,
    this.description = '',
    this.image,
    this.facebook,
    this.instagram,
    this.linkedin,
  }) {
    color = randomColor;
  }

  Widget get profilePicture {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: image == null ? teal.add(black, 0.2) : null,
          image: image != null
              ? DecorationImage(image: NetworkImage(image!))
              : null),
      child: Center(
        child: image == null
            ? AutoSizeText(
                initials,
                style: TextStyle(color: white, fontSize: 20),
              )
            : Container(),
      ),
    );
  }

  String get initials {
    List<String> names = name.split(' ');
    return names[0][0] + ' ' + names[1][0];
  }
}
