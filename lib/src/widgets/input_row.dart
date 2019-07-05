import 'package:flutter/material.dart';
import '../globals.dart' as global;

class InputRow extends StatelessWidget {

  final Widget child;
  final IconData icon;
  final bool isError;

  InputRow({
    Key key,
    @required this.icon,
    @required this.child,
    this.isError = false
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: isError?global.errorColor:global.foregroundColor,
              width: 0.5,
              style: BorderStyle.solid),
        ),
      ),
      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding:
            EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
            child: Icon(
              icon,
              color: global.foregroundColor,
            ),
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}