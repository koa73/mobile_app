class TopicsModel {
  List<Topics> _topics;

  TopicsModel({List<Topics> topics}) {
    this._topics = topics;
  }

  List<Topics> get topics => _topics;
  set topics(List<Topics> topics) => _topics = topics;

  TopicsModel.fromJson(Map<String, dynamic> json) {
    if (json['topics'] != null) {
      _topics = new List<Topics>();
      json['topics'].forEach((v) {
        _topics.add(new Topics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._topics != null) {
      data['topics'] = this._topics.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Topics {
  int _id;
  String _name;

  Topics({int id, String name}) {
    this._id = id;
    this._name = name;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;

  Topics.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    return data;
  }
}
