import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/login_alternative/login_alternative_background.dart';
import 'package:guadalajarav2/views/login_alternative/login_minimalist_text_field.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class LoginMinimalist extends StatefulWidget {
  LoginMinimalist({Key? key}) : super(key: key);

  @override
  State<LoginMinimalist> createState() => _LoginMinimalistState();
}

class _LoginMinimalistState extends State<LoginMinimalist> {
  bool isPasswordHidden = true;
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              children: [
                Expanded(child: LoginAlternativeBackground()),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  padding: EdgeInsets.only(right: width * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoginMinimalistTextField(
                        hint: 'Enter username',
                        controller: userController,
                      ),
                      SizedBox(height: 40),
                      LoginMinimalistTextField(
                        controller: passController,
                        obscureText: isPasswordHidden,
                        hint: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(isPasswordHidden
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () => setState(
                            () => isPasswordHidden = !isPasswordHidden,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: gray,
                              ),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      CustomButton(
                        text: 'Log in',
                        width: 262.5,
                        isBold: true,
                        borderRadius: BorderRadius.circular(15),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                CustomPaint(painter: _simplePainter()),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _simplePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Paint paint = Paint()..color = teal;
    // Paint pointPaint = Paint()..color = red;
    // Paint centerPaint = Paint()..color = black;

    List<Offset> points = [
      Offset(size.width, size.width * 0.5),
      Offset(size.width * 0.5, 0),
    ];
    List<Offset> centers = [];

    Path path = Path()
      ..moveTo(points[1].dx, points[1].dy)
      ..lineTo(size.width, 0)
      ..lineTo(points[0].dx, points[0].dy);
    centers.add(
      Offset(
        size.width,
        0,
      ),
    );
    path.quadraticBezierTo(
      centers[0].dx,
      centers[0].dy,
      points[1].dx,
      points[1].dy,
    );

    canvas.drawPath(path, paint);

    // for (Offset center in centers) {
    //   canvas.drawCircle(center, 2, centerPaint);
    // }
    // for (Offset center in points) {
    //   canvas.drawCircle(center, 2, pointPaint);
    // }
  }

  @override
  bool shouldRepaint(_simplePainter oldDelegate) => true;
}
