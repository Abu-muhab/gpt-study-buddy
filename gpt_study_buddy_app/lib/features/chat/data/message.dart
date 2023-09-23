class Message {
  Message({
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.timestamp,
    required this.messageId,
  });

  final String message;
  final String senderId;
  final String receiverId;
  final String type;
  final DateTime timestamp;
  final String messageId;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        message: (json["message"] as String).trim(),
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        type: json["type"],
        timestamp: DateTime.parse(json["timestamp"]),
        messageId: json["messageId"],
      );

  factory Message.empty() => Message(
        message: '',
        senderId: '',
        receiverId: '',
        type: '',
        timestamp: DateTime.now(),
        messageId: '',
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "senderId": senderId,
        "receiverId": receiverId,
        "type": type,
        "timestamp": timestamp.toIso8601String(),
        "messageId": messageId,
      };

  bool isForChat({required String participant1, required String participant2}) {
    return (senderId == participant1 && receiverId == participant2) ||
        (senderId == participant2 && receiverId == participant1);
  }
}
