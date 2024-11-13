import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/team_member.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/home_screen_view/team_banner/team_member_tile.dart';

class TeamBanner extends StatefulWidget {
  final List<TeamMember> members;
  TeamBanner(this.members, {Key? key}) : super(key: key);

  @override
  State<TeamBanner> createState() => _TeamBannerState();
}

class _TeamBannerState extends State<TeamBanner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.symmetric(
        vertical: height * 0.025,
      ),
      width: width,
      height: 200 + height * 0.05,
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          viewportFraction: 0.25,
          enlargeCenterPage: true,
          autoPlayAnimationDuration: const Duration(seconds: 1),
          autoPlayInterval: const Duration(milliseconds: 2000),
        ),
        items: widget.members.map((member) => TeamMemberTile(member)).toList(),
      ),
    );
  }
}
