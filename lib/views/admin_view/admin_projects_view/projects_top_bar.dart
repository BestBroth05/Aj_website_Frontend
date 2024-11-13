import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class ProjectsTopBar extends StatefulWidget {
  final int inProgress;
  final int standby;
  final int finished;
  final bool isGridLayout;
  final Map<String, String?> filters;
  final Function(String filter, String? value) addFilter;
  final VoidCallback clearFilters;

  final Function(bool value) changeLayout;

  ProjectsTopBar({
    Key? key,
    required this.clearFilters,
    required this.changeLayout,
    required this.addFilter,
    required this.isGridLayout,
    required this.inProgress,
    required this.standby,
    required this.finished,
    required this.filters,
  }) : super(key: key);

  @override
  State<ProjectsTopBar> createState() => _ProjectsTopBarState();
}

class _ProjectsTopBarState extends State<ProjectsTopBar> {
  Map<String, Map<String, dynamic>> filterItems = {
    'company': {
      'items': ['ibiosense', 'dmi'],
      'icon': Icons.location_city,
    },
    'status': {
      'items': ['In Progress', 'Standby', 'Completed'],
      'icon': Icons.analytics_outlined,
    },
    'area': {
      'items': [
        'Hardware',
        'Software',
        'Firmware',
        'Manufacture',
        'Industrial'
      ],
      'icon': Icons.amp_stories_sharp,
    },
    'year': {
      'items': ['2022', '2021', '2020'],
      'icon': Icons.calendar_today
    },
    'month': {
      'items': [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ],
      'icon': Icons.calendar_month_outlined,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.005),
      height: 75,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: teal.add(black, 0.3),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => openLink(
              context,
              AJRoute.admin.url,
              isRoute: true,
            ),
            iconSize: 30,
            icon: Icon(Icons.chevron_left_rounded, color: white),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: filterItems.entries
                      .map(
                        (e) => SizedBox(
                          width: width * 0.1,
                          height: 50,
                          child: _FilterDropdown(
                            widget.filters[e.key],
                            items: e.value['items'],
                            icon: e.value['icon'],
                            hint: e.key.toTitle(),
                            onChanged: (value) =>
                                widget.addFilter.call(e.key, value),
                          ),
                        ),
                      )
                      .toList(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.0125),
                  child: CustomButton(
                    width: width * 0.06,
                    text: 'Apply filters',
                    color: white,
                    textColor: black,
                    height: 42.5,
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.0125),
                  child: CustomButton(
                    text: 'Clear filters',
                    width: width * 0.06,
                    // color: red.add(white, 0.5),
                    height: 42.5,
                    onPressed: widget.clearFilters,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _NumberText(amount: widget.inProgress, text: 'in progress'),
              _NumberText(amount: widget.standby, text: 'standby'),
              _NumberText(amount: widget.finished, text: 'completed'),
              _ProjectSwitch(
                isLeft: widget.isGridLayout,
                change: widget.changeLayout,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatefulWidget {
  final String? value;
  final List<String> items;
  final String hint;
  final Function(String? value) onChanged;
  final IconData icon;
  _FilterDropdown(
    this.value, {
    Key? key,
    required this.icon,
    required this.onChanged,
    required this.items,
    required this.hint,
  }) : super(key: key);

  @override
  State<_FilterDropdown> createState() => __FilterDropdownState();
}

class __FilterDropdownState extends State<_FilterDropdown> {
  List<String> items = ['None'];

  @override
  void initState() {
    super.initState();
    items.addAll(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<String?>(
          isExpanded: true,
          underline: SizedBox(),
          borderRadius: BorderRadius.circular(5),
          hint: Row(
            children: [
              Icon(widget.icon, color: gray.add(black, 0.2)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: width * 0.01),
                  child: AutoSizeText(widget.hint, minFontSize: 1, maxLines: 1),
                ),
              ),
            ],
          ),
          icon: SizedBox(),
          selectedItemBuilder: (context) => items
              .map(
                (e) => Row(
                  children: [
                    Icon(
                      widget.icon,
                      color: gray.add(black, 0.2),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: width * 0.01),
                      child: AutoSizeText(e, minFontSize: 1, maxLines: 1),
                    ),
                  ],
                ),
              )
              .toList(),
          items: items
              .map(
                (e) => DropdownMenuItem<String?>(
                  child: AutoSizeText(e, minFontSize: 1, maxLines: 1),
                  value: e,
                ),
              )
              .toList(),
          onChanged: widget.onChanged,
          value: widget.value,
        ),
      ),
    );
  }
}

class _ProjectSwitch extends StatefulWidget {
  final bool isLeft;
  final Function(bool value) change;
  _ProjectSwitch({
    Key? key,
    required this.isLeft,
    required this.change,
  }) : super(key: key);

  @override
  State<_ProjectSwitch> createState() => __ProjectSwitchState();
}

class __ProjectSwitchState extends State<_ProjectSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.05,
      height: 40,
      decoration: BoxDecoration(
        // color: backgroundColor,
        borderRadius: BorderRadius.circular(7.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () => widget.change.call(true),
            child: Container(
              padding: EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                color: widget.isLeft ? white : null,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                Icons.apps_rounded,
                color: widget.isLeft ? teal.add(black, 0.3) : white,
              ),
            ),
          ),
          InkWell(
            onTap: () => widget.change.call(false),
            child: Container(
              padding: EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                color: widget.isLeft ? null : white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                Icons.dehaze_rounded,
                color: widget.isLeft ? white : teal.add(black, 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberText extends StatelessWidget {
  final int amount;
  final String text;
  const _NumberText({
    Key? key,
    required this.amount,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              '$amount',
              style: TextStyle(fontSize: 20, color: white),
            ),
            AutoSizeText(
              text.toTitle(),
              style: TextStyle(fontSize: 10, color: gray.add(black, 0.0)),
            ),
          ],
        ),
      ),
    );
  }
}
