import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CatalogueWidget extends StatefulWidget {


  @override
  _CatalogueWidget createState() => _CatalogueWidget();

}

class _CatalogueWidget extends State<CatalogueWidget> {

  final String _imageurl = "assets/images/img_1844_1.jpg";
 // var assetsImage = new AssetImage('assets/images/img_1844_1.jpg'); //<- Creates an object that fetches an image.
  //var image = new Image(image: assetsImage, fit: BoxFit.cover); //<- Creates a widget that displays an image.

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      key: new PageStorageKey('catalogue'),
      itemBuilder: _getSlidableWidget,
    );
  }

  Widget _getSlidableWidget(BuildContext context, int index){

    return new Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: new Container(
        color: Colors.white,
        child: new ListTile(
          leading: new Image.asset(_imageurl, width: 69, height: 200.0),
          //https://www.proficosmetics.ru/upload/resize_cache/iblock/254/200_200_1/img_1844.jpg
          title: new Text('Holyland'),
          subtitle: new Text('Лосьон для растворения закрытых комедонов / Super Lotion LOTIONS 250 мл'),
        ),
      ),
      actions: <Widget>[
        new IconSlideAction(
          caption: 'Archive',
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () => null,
        ),
        new IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () => null,
        ),
      ],
    );
  }
}
