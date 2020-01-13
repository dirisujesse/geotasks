import 'package:flutter/material.dart';
import 'package:geotasks/style/colors.dart';

class PulseAnimation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PulseAnimationState();
  }
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              // radius: 1.5,
              colors: [appBlue, appWhite],
              stops: [
                0,
                _ctrl.value,
              ],
            ),
          ),
        );
      },
    );
  }
}
