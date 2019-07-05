import 'package:flutter/material.dart';
import '../globals.dart' as global;

class BackGround extends StatelessWidget {

  final Widget child;

  BackGround({
    Key key,
    @required this.child,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: Alignment.centerLeft,
          end: new Alignment(1.0, 0.0),
          // 10% of the width, so there are ten blinds.
          colors: [global.backgroundColor1, global.backgroundColor2],
          // whitish to gray
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
      height: MediaQuery
          .of(context)
          .size
          .height,
      child: child,
    );
  }
}