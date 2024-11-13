import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/footer/footer.dart';
import 'package:guadalajarav2/views/main_top_bar.dart/main_top_bar.dart';

class PageNotFoundView extends StatelessWidget {
  const PageNotFoundView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      child: Column(
        children: [
          MainTopBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: height * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          '404',
                          style: TextStyle(
                            fontSize: height * 0.1,
                            fontWeight: FontWeight.bold,
                            color: teal.add(black, 0.3),
                          ),
                        ),
                        AutoSizeText(
                          'sorry, page not found :(',
                          style: TextStyle(
                            fontSize: height * 0.06,
                            fontWeight: FontWeight.w400,
                            color: gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
