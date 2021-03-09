class MessagesList {
  final List<Message> messages;
  MessagesList({this.messages});
  factory MessagesList.fromJson(List<dynamic> parsedJson) {
    List<Message> messages = new List<Message>();
    messages = parsedJson.map((i)=>Message.fromJson(i)).toList();
    return new MessagesList(messages: messages);
  }
}

class Message {
  final String uid;
  final String name;
  final String datetime;
  final String comment;

  Message({this.uid, this.name, this.datetime, this.comment});

  factory Message.fromJson(Map<String, dynamic> parsedJson) {
    return new Message(uid: parsedJson['uid'].toString(), name: parsedJson['name'].toString(), datetime: parsedJson['datetime'].toString(), comment:parsedJson['comment'].toString());
  }

  @override
  String toString() {
    //return '{ ${this.uid}, ${this.name}, ${this.datetime}, ${this.comment} }';
    return '{ ${this.uid}, ${this.name}}';
  }
}