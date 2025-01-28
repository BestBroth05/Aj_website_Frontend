import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/enums/projects/project_permissions.dart';
import 'package:guadalajarav2/enums/working_areas.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class AddMembersContainer extends StatefulWidget {
  final Map<int, User> users;
  final Map<int, List<int>> membersInProject;
  final Function(
    User userId,
    WorkingAreas? areaId,
    ProjectPermission permissionId,
  ) onAddedMember;
  final Function(int userId, int areaId) onDeleteArea;
  AddMembersContainer(
    this.users, {
    Key? key,
    required this.membersInProject,
    required this.onAddedMember,
    required this.onDeleteArea,
  }) : super(key: key);

  @override
  State<AddMembersContainer> createState() => _AddMembersContainerState();
}

class _AddMembersContainerState extends State<AddMembersContainer> {
  User? selected;
  WorkingAreas? selectedArea;
  ProjectPermission? selectedPermission;
  List<WorkingAreas> areas = WorkingAreas.values;
  List<ProjectPermission> permissions = ProjectPermission.values;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.975,
      width: width * 0.25,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            'Members',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Divider(thickness: 2),
          Expanded(
            child: widget.membersInProject.length == 0
                ? Center(
                    child: AutoSizeText(
                      'There are currently no members in this project',
                      style: TextStyle(
                        color: gray.add(black, 0.3),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      int id = widget.membersInProject.keys.elementAt(index);
                      List<int> wAIds =
                          widget.membersInProject.values.elementAt(index);

                      User _user = widget.users[id]!;
                      ProjectPermission permission =
                          ProjectPermission.values[wAIds[0]];

                      List<WorkingAreas> _areas = [];
                      wAIds.sublist(1).forEach(
                            (i) => _areas.add(
                              WorkingAreas.values.elementAt(i),
                            ),
                          );

                      return Card(
                        elevation: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                '${_user.fullName} - ${permission.name}'
                                    .toTitle(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.5,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _areas
                                    .map(
                                      (e) => InkWell(
                                        onTap: () => setState(
                                          () => widget.onDeleteArea.call(
                                            _user.id,
                                            e.id,
                                          ),
                                        ),
                                        child: AutoSizeText(
                                          e.name.toTitle(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: gray.add(black, 0.5),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: widget.membersInProject.length,
                  ),
          ),
          Divider(thickness: 2),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _CustomUserDropDown<User>(
                  onChanged: (newUser) => setState(() {
                    selected = newUser;

                    selectedArea = null;
                  }),
                  value: selected,
                  users: widget.users.values.toList(),
                  hint: 'Member',
                ),
              ),
              Expanded(
                flex: 3,
                child: _CustomUserDropDown<WorkingAreas>(
                  onChanged: (newUser) => setState(
                    () => selectedArea = newUser,
                  ),
                  value: selectedArea,
                  users: areas.where((element) {
                    if (selected == null) {
                      return false;
                    } else {
                      if (widget.membersInProject.containsKey(selected!.id)) {
                        return !widget.membersInProject[selected!.id]!
                            .contains(element.id);
                      } else {
                        return true;
                      }
                    }
                  }).toList(),
                  hint: 'Area',
                ),
              ),
              Expanded(
                flex: 3,
                child: _CustomUserDropDown<ProjectPermission>(
                  onChanged: (newUser) => setState(
                    () => selectedPermission = newUser,
                  ),
                  value: selectedPermission,
                  users: permissions,
                  hint: 'Permission',
                ),
              ),
              SizedBox(width: 20),
              CustomButton(
                width: 25,
                icon: Icons.add,
                onPressed: selected != null &&
                        // selectedArea != null &&
                        selectedPermission != null
                    ? () => setState(
                          () {
                            widget.onAddedMember.call(
                                selected!, selectedArea, selectedPermission!);
                            selectedArea = null;
                          },
                        )
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomUserDropDown<T> extends StatefulWidget {
  final Function(T? selected) onChanged;
  final T? value;
  final List<T> users;
  final String hint;
  _CustomUserDropDown({
    Key? key,
    required this.hint,
    required this.onChanged,
    required this.value,
    required this.users,
  }) : super(key: key);

  @override
  State<_CustomUserDropDown<T>> createState() => __CustomUserDropDownState<T>();
}

class __CustomUserDropDownState<T> extends State<_CustomUserDropDown<T>> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: DropdownButton<T>(
        isExpanded: true,
        borderRadius: BorderRadius.circular(10),
        underline: SizedBox(),
        icon: Container(),
        selectedItemBuilder: (context) => widget.users
            .map(
              (e) => Padding(
                padding: const EdgeInsets.all(5.0),
                child: Center(
                  child: AutoSizeText(
                    T == User
                        ? (e as User).name
                        : T == WorkingAreas
                            ? (e as WorkingAreas).name.toTitle()
                            : (e as ProjectPermission).name.toTitle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
            .toList(),
        items: widget.users
            .map(
              (T e) => DropdownMenuItem<T>(
                child: Center(
                  child: AutoSizeText(
                    T == User
                        ? (e as User).name
                        : T == WorkingAreas
                            ? (e as WorkingAreas).name.toTitle()
                            : (e as ProjectPermission).name.toTitle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                value: e,
              ),
            )
            .toList(),
        hint: Center(
          child: AutoSizeText(
            widget.hint,
            textAlign: TextAlign.start,
          ),
        ),
        onChanged: widget.onChanged,
        value: widget.value,
      ),
    );
  }
}
