import 'package:flutter/material.dart';
import 'package:flutter_ble_messenger/database/chat_dao.dart';
import 'package:flutter_ble_messenger/database/discussion_dao.dart';
import 'package:flutter_ble_messenger/model/chat.dart';
import 'package:flutter_ble_messenger/model/discussion.dart';
import 'package:flutter_ble_messenger/screens/Messages/chat_custom.dart' as ChatDiscussion;

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<Chat> chats = new List<Chat>();
  ChatDao chatDao = new ChatDao();
  DiscussionDao discussionDao = new DiscussionDao();

  @override
  void initState() {
    chatDao.getAll().then((value) {
      print(value);
      setState(() {
        chats = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              List<Discussion> messages = List<Discussion>();
              discussionDao.getAll(chats[index].chatId).then((value) {
                print("messages" + messages.toString());
                messages = value;
              });
              return ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDiscussion.Chat(name: chats[index].receiverName,chatId: chats[index].chatId,bleAddress: "",) ),
                  );
                },
                  leading: Image.asset('assets/images/person1.png'),
                  title: Text(
                    chats[index].receiverName,
                    style: TextStyle(
                      fontFamily: "Segoe UI",
                      fontSize: 18,
                      color: Color(0xff5e5e5e),
                    ),
                  ),
                  subtitle: Text(
                    "test",
                    style: TextStyle(
                      fontFamily: "Segoe UI",
                      fontWeight: FontWeight.w300,
                      fontSize: 17,
                      color: Color(0xffaaa5a5),
                    ),
                  ),
                  trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Now",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: "Segoe UI",
                            fontSize: 13,
                            color: Color(0xff5e5e5e),
                          ),
                        ),
                      ]));
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
            itemCount: chats.length));
  }
}
