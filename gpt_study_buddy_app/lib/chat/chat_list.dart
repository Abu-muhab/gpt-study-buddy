import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/bot/create_bot_view/create_bot_viewmodel.dart';
import 'package:gpt_study_buddy/bot/create_bot_view/create_bot_view.dart';
import 'package:gpt_study_buddy/main.dart';
import 'package:provider/provider.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        centerTitle: false,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) => CreateBotViewmodel(),
                child: const CreateAssistantView(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        color: primaryColor[100],
        child: ListView(
          children: <Widget>[
            const ChatTile(),
            Divider(
              color: Colors.grey[800],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatTile extends StatefulWidget {
  const ChatTile({super.key});

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: const Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              'https://picsum.photos/200/300',
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sukanmi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Let me know if you need anything else.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
