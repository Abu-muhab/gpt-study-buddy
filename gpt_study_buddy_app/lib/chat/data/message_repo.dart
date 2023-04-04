import 'package:faker/faker.dart';
import 'package:gpt_study_buddy/chat/data/message.dart';

class MessageRepository {
  static List<Message> getMockMessages(String userId) {
    var faker = Faker();
    String senderId = faker.guid.guid();

    List<Message> sent = List.generate(
      10,
      (index) => Message(
        message: faker.lorem.sentence(),
        senderId: senderId,
        receiverId: userId,
        type: faker.randomGenerator.string(10),
        timestamp: faker.date.dateTime(),
      ),
    );

    List<Message> received = List.generate(
      10,
      (index) => Message(
        message: faker.lorem.sentence().replaceAll("\n", " "),
        senderId: userId,
        receiverId: senderId,
        type: faker.randomGenerator.string(10),
        timestamp: faker.date.dateTime(),
      ),
    );

    final messages = [...sent, ...received];
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return messages;
  }
}
