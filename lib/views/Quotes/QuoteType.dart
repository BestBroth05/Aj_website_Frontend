import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/CustomerClass.dart';
import 'package:guadalajarav2/views/Quotes/DesplegableQuotes.dart';
import '../../enums/route.dart';
import '../../utils/SuperGlobalVariables/ObjVar.dart';
import '../../utils/colors.dart';
import '../../utils/tools.dart';
import '../../utils/url_handlers.dart';
import '../admin_view/AdminWidgets/Title.dart';

// ignore: must_be_immutable
class QuoteType extends StatefulWidget {
  CustomersClass customer;
  QuoteType({super.key, required this.customer});

  @override
  State<QuoteType> createState() => _QuoteTypeState();
}

class _QuoteTypeState extends State<QuoteType> {
  Map<AJRoute, Map<String, dynamic>> routes = {
    AJRoute.assemblies: {
      'name': 'Assemblies',
      'icon': FontAwesomeIcons.gear,
      'isHovering': false,
    },
    AJRoute.proyects: {
      'name': 'Projects',
      'icon': FontAwesomeIcons.diagramProject,
      'isHovering': false,
    },
    AJRoute.manofacture: {
      'name': 'Manofacture',
      'icon': FontAwesomeIcons.robot,
      'isHovering': false,
    }
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: teal.add(black, 0.3),
          title: TitleH1(context, "Types of Quotations"),
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DesplegableQuotes(customer: widget.customer)));
              },
              icon: Icon(
                Icons.chevron_left,
                color: Colors.white,
              )),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: SizedBox(
              height: 500,
              width: width,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: width / 3,
                ),
                itemCount: routes.length,
                itemBuilder:

                    /*child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
               children: List.generate(
                routes.length,*/
                    (context, index) {
                  AJRoute route = routes.keys.elementAt(index);
                  String name = routes.values.elementAt(index)['name'];
                  IconData icon = routes.values.elementAt(index)['icon'];
                  bool isHovering =
                      routes.values.elementAt(index)['isHovering'];

                  return Container(
                    margin: EdgeInsets.all(width * 0.02),
                    child: InkWell(
                      // style: ElevatedButton.styleFrom(primary: white),
                      onTap: () {
                        setState(() {
                          currentUser.customerNameQuotes = widget.customer;
                        });

                        openLink(context, route.url, isRoute: true);
                      },
                      onHover: (value) => setState(
                        () => routes.values.elementAt(index)['isHovering'] =
                            value,
                      ),
                      child: Container(
                        width: width * 0.2,
                        height: width * 0.2,
                        decoration: BoxDecoration(
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              color: black.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: isHovering ? 8 : 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: FaIcon(
                                icon,
                                color: isHovering ? teal : gray,
                                size: width * 0.1,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: AutoSizeText(
                                name,
                                style: TextStyle(
                                  color: isHovering ? teal : gray,
                                  fontSize: 30,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                // ).toList(),
              ),
            ),
          ),
        ));
  }
}
