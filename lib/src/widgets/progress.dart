import 'package:flutter/material.dart';

class ProgressView extends StatelessWidget {

  final bool visibility;
  final Widget child;

  ProgressView({
    Key key,
    @required this.child,
    @required this.visibility,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Stack(
        children: <Widget>[
          child,
          Visibility(
            key: ValueKey("visible"),
            visible: visibility,
            child: new Stack(
              key: ValueKey("model"),
              children: [
                new Opacity(
                  opacity: 0.3,
                  child: const ModalBarrier(dismissible: false, color: Colors.grey),
                ),
                new Center(
                    child: Padding(
                      child: new CircularProgressIndicator(),
                      padding: EdgeInsets.only(bottom: 200),
                    )
                ),
              ],
            ),
          )
        ]
    );
  }
}