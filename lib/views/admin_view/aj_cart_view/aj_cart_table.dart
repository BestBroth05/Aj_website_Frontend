import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/admin_view/aj_cart_view/aj_cart_tile.dart';
import 'package:guadalajarav2/views/admin_view/aj_cart_view/aj_cart_view.dart';

class AJCartTable extends StatefulWidget {
  final Map<String, int> headers;
  final ScrollController scrollController;
  AJCartTable({
    Key? key,
    required this.scrollController,
    required this.headers,
  }) : super(key: key);

  @override
  State<AJCartTable> createState() => _AJCartTableState();
}

class _AJCartTableState extends State<AJCartTable> {
  ScrollController controllerMPN = ScrollController(initialScrollOffset: 0);
  ScrollController controller = ScrollController(initialScrollOffset: 0);
  ScrollController controllerTC = ScrollController(initialScrollOffset: 0);
  double _width = 0;
  @override
  void initState() {
    super.initState();
    controllerMPN.addListener(() {
      double offset = controllerMPN.offset;
      controller.jumpTo(offset);
      controllerTC.jumpTo(offset);
    });
    controller.addListener(() {
      double offset = controller.offset;
      controllerMPN.jumpTo(offset);
      controllerTC.jumpTo(offset);
    });
    controllerTC.addListener(() {
      double offset = controllerTC.offset;
      controller.jumpTo(offset);
      controllerMPN.jumpTo(offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    _width = 0;

    widget.headers.forEach((key, value) => _width += 70 * (value + 1));
    _width -= 140;

    // if (_width < (width)) {
    //   _width = width;
    // }

    return (_width >= width)
        ? Row(
            children: [
              Expanded(
                child: Scrollbar(
                  controller: widget.scrollController,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: widget.scrollController,
                    child: SizedBox(
                      width: _width,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(scrollbars: false),
                        child: ListView.builder(
                          controller: controller,
                          itemBuilder: (context, index) => AJCartTile(
                            AJCartView.parts.values.toList()[index],
                            headers: widget.headers,
                            isOdd: index % 2 != 0,
                            onUpdate: (totalCost) => setState(() {
                              AJCartView.parts[
                                  AJCartView.parts.values.toList()[index]
                                      ['id']]!['total_cost'] = totalCost;
                            }),
                          ),
                          itemCount: AJCartView.parts.values.toList().length,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 140,
                child: ListView.builder(
                  controller: controllerTC,
                  itemBuilder: (context, index) => Container(
                    height: 100,
                    color: index % 2 != 0 ? white : backgroundColor,
                    child: Center(
                      child: AutoSizeText(
                        AJCartView.parts.values
                            .toList()[index]['total_cost']
                            .toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  itemCount: AJCartView.parts.length,
                ),
              ),
            ],
          )
        : ListView.builder(
            controller: controller,
            itemBuilder: (context, index) => AJCartTile(
              AJCartView.parts.values.toList()[index],
              headers: widget.headers,
              isOdd: index % 2 != 0,
              onUpdate: (totalCost) => setState(
                () {
                  AJCartView.parts[AJCartView.parts.values.toList()[index]
                      ['id']]!['total_cost'] = totalCost;
                },
              ),
            ),
            itemCount: AJCartView.parts.values.toList().length,
          );
  }
}
