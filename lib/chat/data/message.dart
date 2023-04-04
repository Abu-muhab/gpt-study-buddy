class Message {
  Message({
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.timestamp,
  });

  final String message;
  final String senderId;
  final String receiverId;
  final String type;
  final DateTime timestamp;
}
