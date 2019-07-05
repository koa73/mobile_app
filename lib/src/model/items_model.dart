// To parse this JSON data, do
//
//     final itemsList = itemsListFromJson(jsonString);

import 'dart:convert';

ItemsList itemsListFromJson(String str) => ItemsList.fromJson(json.decode(str));

String itemsListToJson(ItemsList data) => json.encode(data.toJson());

class ItemsList {
  List<Item> items;

  ItemsList({
    this.items,
  });

  factory ItemsList.fromJson(Map<String, dynamic> json) => new ItemsList(
    items: new List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "items": new List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Item {
  String id;
  String name;
  String desc;
  String volume;
  String cost;
  String img;

  Item({
    this.id,
    this.name,
    this.desc,
    this.volume,
    this.cost,
    this.img,
  });

  factory Item.fromJson(Map<String, dynamic> json) => new Item(
    id: json["id"],
    name: json["name"],
    desc: json["desc"],
    volume: json["volume"],
    cost: json["cost"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "desc": desc,
    "volume": volume,
    "cost": cost,
    "img": img,
  };
}
