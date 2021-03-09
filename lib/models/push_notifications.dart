class PushNotification {
  String id;
  DateTime createdAt;
  String messageType;
  String guid;
  String title;
  String subtitle;
  String body;
  bool isNew;

  PushNotification(this.id, [this.messageType, this.guid]);

  factory PushNotification.fromJson(Map<String, dynamic> json,
      [bool isNew = true]) {
    var push = PushNotification(json['ID']);

    push.createdAt = DateTime.parse(json['CreatedAt']);
    push.messageType = json['MessageType'];
    push.guid = json['GUID'];
    push.title = json['Title'];
    push.subtitle = json['Subtitle'];
    push.body = json['Body'];
    push.isNew = isNew;

    return push;
  }

  factory PushNotification.fromMap(Map<String, dynamic> map) {
    var push = PushNotification(map['id']);

    push.createdAt = DateTime.parse(map['createdAt']);
    push.messageType = map['messageType'];
    push.guid = map['guid'];
    push.title = map['title'];
    push.subtitle = map['subtitle'];
    push.body = map['body'];
    push.isNew = map['isNew'] == 1 ? true : false;

    return push;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toString(),
      'messageType': messageType,
      'guid': guid,
      'title': title,
      'subtitle': subtitle,
      'body': body,
      'isNew': isNew ? 1 : 0,
    };
  }
}
