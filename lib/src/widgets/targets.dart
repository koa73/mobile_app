import 'package:flutter/material.dart';

class Targets extends StatefulWidget {

  final Color color;

  Targets({Key k, this.color});

  @override
  createState() => new MyTargetsState(color);
}

class MyTargetsState extends State<Targets> {

  Color color;

  MyTargetsState(this.color);

  @override
  Widget build(BuildContext context) {

    final CountTarget inheritedWidget = CountTarget.of(context);
    return Wrap(
        direction: Axis.horizontal,
        spacing: 8.0,
        children: _getList(inheritedWidget.count)
    );
  }

  List<Widget> _getList(int count){

    return List<Widget>.generate(5, (i) => ((count - i) > 0)
        ?Icon(Icons.brightness_1, size: 18.0, color: this.color)
        :Icon(Icons.radio_button_unchecked, size: 18.0, color: this.color)
    );
  }
}

class CountTarget extends InheritedWidget {
  CountTarget({
    Key key,
    @required Widget child,
    this.count,
  }): super(key: key, child: child);

  final count;

  static CountTarget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(CountTarget);
  }

  @override
  bool updateShouldNotify(CountTarget oldWidget) => count != oldWidget.count;
}