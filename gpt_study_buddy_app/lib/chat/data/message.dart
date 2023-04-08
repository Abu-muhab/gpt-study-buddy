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

  Map<String, dynamic> toJson() => {
        "message": message,
        "senderId": senderId,
        "receiverId": receiverId,
        "type": type,
        "timestamp": timestamp.toIso8601String(),
        "messageId": messageId,
      };
}
