import 'dart:developer';

import '../../calendar/data/event.dart';

class Message {
  Message({
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.timestamp,
    required this.messageId,
    required this.createdResources,
  });

  final String message;
  final String senderId;
  final String receiverId;
  final String type;
  final DateTime timestamp;
  final String messageId;
  final List<Resource> createdResources;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        message: (json["message"] as String).trim(),
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        type: json["type"],
        timestamp: DateTime.parse(json["timestamp"]),
        messageId: json["messageId"],
        createdResources: json["createdResources"] == null
            ? []
            : List<Resource>.from(json["createdResources"]
                .map((resourceMap) => Resource.fromJson(resourceMap))),
      );

  factory Message.empty() => Message(
        message: '',
        senderId: '',
        receiverId: '',
        type: '',
        timestamp: DateTime.now(),
        messageId: '',
        createdResources: [],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "senderId": senderId,
        "receiverId": receiverId,
        "type": type,
        "timestamp": timestamp.toIso8601String(),
        "messageId": messageId,
        "createdResources": List<dynamic>.from(
            createdResources.map((resource) => resource.toJson())),
      };

  bool isForChat({required String participant1, required String participant2}) {
    return (senderId == participant1 && receiverId == participant2) ||
        (senderId == participant2 && receiverId == participant1);
  }

  bool get isEmpty => message.isEmpty && senderId.isEmpty && receiverId.isEmpty;
}

class Resource {
  Resource({
    required this.type,
    required this.resource,
  });

  final String type;
  final Map<String, dynamic> resource;

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
        type: json["type"].toString(),
        resource: json["resource"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "resource": resource,
      };

  dynamic toResourceObject() {
    try {
      switch (type) {
        case 'event':
          return Event.fromJson(resource);
        default:
          return null;
      }
    } catch (err, stack) {
      log(err.toString(), stackTrace: stack);
      return null;
    }
  }
}
