import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ShoppingCartWidget extends StatelessWidget {

  List<String> _array = [];

  @override

  Widget build(BuildContext context) {
    return new Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,

      child: new Container(
        color: Colors.white,
        child: new ListTile(
          leading: new CircleAvatar(
            backgroundColor: Colors.indigoAccent,
            child: new Text('A'),
            foregroundColor: Colors.white,
          ),
          title: new Text('Tile n°A'),
          subtitle: new Text('SlidableDrawerDelegate'),
        ),
      ),
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'More',
          color: Colors.black45,
          icon: Icons.more_horiz,
          onTap: () => null,
        ),
        new IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => null,
        ),
      ],
    );
  }

}