import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/administration/Movements/movement.dart';
import 'package:guadalajarav2/administration/Movements/movementType.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/views/admin_view/admin_history_view/admin_history_search_menu.dart';
import 'package:guadalajarav2/views/dashboard_main_top_bar.dart/dashboard_main_top_dar.dart';
import 'package:guadalajarav2/views/dialogs/basic_text_dialog.dart';
import 'package:guadalajarav2/views/dialogs/loading_dialog.dart';

class AdminHistoryView extends StatefulWidget {
  AdminHistoryView({Key? key}) : super(key: key);

  @override
  State<AdminHistoryView> createState() => _AdminHistoryViewState();
}

class _AdminHistoryViewState extends State<AdminHistoryView> {
  List<Movement> movements = [];
  List<Movement> allMovements = [];
  List<List<Movement>> segmentedMovements = [];
  int part = 0;
  int segmentSize = 1;
  int numSections = 10;

  Map<String, dynamic> filters = {
    'category': null,
    'type': null,
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer.run(() async {
      await getMovements();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          DashboardTopBar(selected: 4),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Card(
                color: backgroundColor,
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.01,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Row(
                            children: [
                              IconButton(
                                splashRadius: 15,
                                icon: Icon(
                                  Icons.chevron_left,
                                  color: teal.add(black, 0.3),
                                ),
                                onPressed: () => openLink(
                                  context,
                                  AJRoute.admin.url,
                                  isRoute: true,
                                ),
                              ),
                              Expanded(child: Container()),
                              _ChangeSegmentButton(
                                limit: segmentedMovements.length,
                                changeSegment: changeSegment,
                                segment: part,
                                segmentsSize: segmentSize,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 28,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: AdminHistorySearchMenu(
                                  filters: filters,
                                  changeFilter: (key, value) async {
                                    filters[key] = value;

                                    Map<String, int> f = {};

                                    if (filters['category'] != null) {
                                      f['type'] = MovementGType.values
                                          .indexOf(filters['category']);
                                    }

                                    if (filters['type'] != null) {
                                      f['subtype'] = MovementType.values
                                          .indexOf(filters['type']);
                                    }

                                    await getMovements(f: f);
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: _MovementsTable(movements),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getMovements({Map<String, int> f = const {}}) async {
    openDialog(context, container: BasicTextDialog('Getting Movements'));
    if (f.isEmpty) {
      allMovements = (await getAllMovements(context)).reversed.toList();
    } else {
      allMovements = (await getMovementsFiltered(context, f)).reversed.toList();
    }

    segmentedMovements = [];

    segmentSize = allMovements.length ~/ numSections;

    for (int i = 0; i < numSections; i++) {
      segmentedMovements.add(
        allMovements.sublist(
          segmentSize * i,
          min(segmentSize * (i + 1), allMovements.length),
        ),
      );
    }

    movements = segmentedMovements[part];
    Navigator.pop(context);
    setState(() {});
  }

  void changeSegment(int newValue) => setState(() {
        part = newValue;
        movements = segmentedMovements[part];
      });
}

class _ChangeSegmentButton extends StatelessWidget {
  final int segment;
  final int limit;
  final int segmentsSize;
  final Function(int newValue) changeSegment;
  const _ChangeSegmentButton({
    Key? key,
    required this.limit,
    required this.segment,
    required this.segmentsSize,
    required this.changeSegment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int first = (segment * segmentsSize) + 1;
    int last = ((segment + 1) * segmentsSize);

    return Container(
      child: Row(
        children: [
          IconButton(
            splashRadius: 15,
            onPressed: segment > 0 ? () => changeSegment(segment - 1) : null,
            icon: Icon(Icons.chevron_left),
          ),
          SizedBox(
            width: width * 0.05,
            child: AutoSizeText(
              '${first.toString().padLeft(3, " ")} - ${last.toString().padLeft(3, " ")}',
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            splashRadius: 15,
            onPressed:
                segment < limit - 1 ? () => changeSegment(segment + 1) : null,
            icon: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class _MovementsTable extends StatelessWidget {
  final List<Movement> movements;
  const _MovementsTable(this.movements, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: gray),
                  ),
                ),
                child: Row(
                  children: [
                    'Date',
                    'Time',
                    'Category',
                    'User ID',
                    'Username',
                    'Description',
                  ]
                      .map(
                        (e) => Expanded(
                          flex: e == 'Description' ? 3 : 1,
                          child: Center(
                            child: AutoSizeText(
                              e.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            Expanded(
              flex: 19,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ListView.separated(
                  itemBuilder: (context, index) => _MovementTile(
                    movements[index],
                    isDarker: index % 2 == 0,
                  ),
                  itemCount: movements.length,
                  separatorBuilder: (context, index) => SizedBox(height: 5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovementTile extends StatelessWidget {
  final Movement movement;
  final bool isDarker;
  const _MovementTile(
    this.movement, {
    Key? key,
    this.isDarker = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> values = movement.toJson().values.toList();
    values.removeAt(5);

    values[0] = movement.date;
    values[1] = movement.time;
    values[2] = movement.type.name;
    values[3] = movement.userId;
    values[4] = movement.username;
    values[5] = movement.description;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isDarker ? white : backgroundColor,
      ),
      child: Row(
        children: values
            .map(
              (e) => Expanded(
                flex: e == movement.description ? 3 : 1,
                child: Center(
                  child: AutoSizeText(e.toString()),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
