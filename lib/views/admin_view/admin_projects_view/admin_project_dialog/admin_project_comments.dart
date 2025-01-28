import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/extensions/date_time_ext.dart';
import 'package:guadalajarav2/main.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/admin_view/admin_projects_view/admin_project_dialog/admin_add_comment.dart';
import 'package:guadalajarav2/widgets/name_circle.dart';

class AdminProjectCommentsSection extends StatefulWidget {
  final Map<String, dynamic> project;
  final Map<int, User> users;
  final void Function(int projectId, String comment) addCommentFunct;
  AdminProjectCommentsSection(
    this.project, {
    Key? key,
    required this.users,
    required this.addCommentFunct,
  }) : super(key: key);

  @override
  State<AdminProjectCommentsSection> createState() =>
      _AdminProjectCommentsSectionState();
}

class _AdminProjectCommentsSectionState
    extends State<AdminProjectCommentsSection> {
  Map<String, dynamic> get project => widget.project;
  List<dynamic> get comments => widget.project['comments'] ?? [];

  Map<int, User> get users => widget.users;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.3,
      height: height * 0.95,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: white,
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.5),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AutoSizeText(
              'Comments',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                  // children: comments
                  //     .map(
                  //       (comment) => _Comment(
                  //         userComment: users[comment['member']],
                  //         date: comment['dateTime'],
                  //         comment: comment['comment'],
                  //       ),
                  //       // (_) => Container(),
                  //     )
                  //     .toList(),
                  ),
            ),
          ),
          AdminAddComment(
            projectId: project['id'],
            addCommentFunct: (id, comment) => setState(
              () => widget.addCommentFunct.call(id, comment),
            ),
          ),
        ],
      ),
    );
  }
}

class _Comment extends StatelessWidget {
  final User? userComment;
  final DateTime date;
  final String comment;
  const _Comment({
    Key? key,
    required this.userComment,
    required this.date,
    required this.comment,
  }) : super(key: key);

  String get formattedDate =>
      '${date.time} - ${date.readableFormat.toUpperCase()}';

  @override
  Widget build(BuildContext context) {
    if (userComment == null) {
      return Container();
    }

    List<Widget> children = [
      NameCircle(
        userComment!.name[0],
        userComment!.lastName[0],
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: white,
              border: Border.all(color: backgroundColor),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: black.withOpacity(0.15),
                  blurRadius: 8,
                  spreadRadius: 0.5,
                ),
              ],
            ),
            // height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: AutoSizeText(
                    comment,
                    textAlign: TextAlign.justify,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 10,
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: AutoSizeText(
                      formattedDate,
                      style: TextStyle(
                        color: gray.add(black, 0.4),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        // height: 100,
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: user!.username == userComment!.username
              ? children.reversed.toList()
              : children,
        ),
      ),
    );
  }
}
