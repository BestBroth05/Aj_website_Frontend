import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/alert.dart';
import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/utils/styles.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/inventory_view/inventory_body.dart';

class DeleteConfirmation extends StatefulWidget {
  final Product product;

  DeleteConfirmation({required this.product});

  @override
  _DeleteConfirmation createState() => _DeleteConfirmation();
}

class _DeleteConfirmation extends State<DeleteConfirmation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.25,
      height: height * 0.4,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03,
                  vertical: height * 0.0075,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Icon(
                          Icons.delete_forever_rounded,
                          color: red,
                          size: height * 0.1,
                        ),
                      ),
                    ),
                    AutoSizeText(
                      'Are you sure you want to delete component:',
                      maxLines: 2,
                      maxFontSize: 20,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: darkGrey,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                    AutoSizeText(
                      '${widget.product.mpn}',
                      maxFontSize: 20,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: darkGrey,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                      child: Container(
                        height: height * 0.05,
                        child: ElevatedButton(
                          style: TextButton.styleFrom(backgroundColor: gray),
                          child: AutoSizeText('Cancel', style: buttonEdit),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    child: VerticalDivider(),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                      child: Container(
                        height: height * 0.05,
                        child: ElevatedButton(
                          style: TextButton.styleFrom(backgroundColor: red),
                          child: AutoSizeText('Delete!', style: buttonEdit),
                          onPressed: () async {
                            bool canDelete =
                                await deleteComponentInDatabase(widget.product);

                            if (canDelete) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              containerDialog(
                                context,
                                false,
                                AlertNotification(
                                  icon: Icons.check_circle_rounded,
                                  color: green,
                                  str: 'Component Deleted',
                                ),
                                0.2,
                              );

                              InventoryBody.parts.removeWhere((element) =>
                                  element.mpn == widget.product.mpn);
                            } else {
                              containerDialog(
                                context,
                                false,
                                AlertNotification(
                                  icon: Icons.warning_amber_rounded,
                                  color: red,
                                  str:
                                      'Problem, could not delete from database',
                                ),
                                0.2,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
