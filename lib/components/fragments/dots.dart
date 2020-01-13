import 'package:flutter/material.dart';
import 'package:geotasks/style/colors.dart';

class Dots extends StatelessWidget {
  final int len;
  final int idx;
  Dots(this.idx, [this.len = 3]) : assert(idx != null);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        len,
        (index) {
          return AnimatedContainer(
            duration: Duration(
              milliseconds: 500,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            height: idx == index ? 8 : 7,
            width: idx == index ? 8 : 7,
            decoration: BoxDecoration(
              color: idx == index ? appYellow : Color(0x00),
              shape: BoxShape.circle,
              border: Border.all(
                color: idx != index ? appYellow : Color(0x00),
                width: idx == index ? 0 : 1,
              ),
            ),
          );
        },
      ),
    );
  }
}
