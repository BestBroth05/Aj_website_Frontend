import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/team_member.dart';
import 'package:guadalajarav2/enums/social_media.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class TeamMemberTile extends StatefulWidget {
  final TeamMember member;
  final bool isDark;
  TeamMemberTile(
    this.member, {
    Key? key,
    this.isDark = false,
  }) : super(key: key);

  @override
  State<TeamMemberTile> createState() => _TeamMemberTileState();
}

class _TeamMemberTileState extends State<TeamMemberTile> {
  Map<SocialMedia, String> get socialMedia {
    Map<SocialMedia, String> sm = {};

    if (widget.member.facebook != null) {
      sm.putIfAbsent(SocialMedia.facebook, () => widget.member.facebook!);
    }

    if (widget.member.instagram != null) {
      sm.putIfAbsent(SocialMedia.instagram, () => widget.member.instagram!);
    }

    if (widget.member.linkedin != null) {
      sm.putIfAbsent(SocialMedia.linkedin, () => widget.member.linkedin!);
    }

    return sm;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: white,
      elevation: 5,
      child: Container(
        width: width * 0.15,
        padding: EdgeInsets.symmetric(vertical: height * 0.01),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(child: widget.member.profilePicture),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AutoSizeText(
                        widget.member.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: AutoSizeText(
                      widget.member.position,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
