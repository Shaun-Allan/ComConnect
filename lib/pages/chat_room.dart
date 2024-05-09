import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:community_chat_forum/components/chat_message.dart';
import 'package:community_chat_forum/services/community.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final msgController = TextEditingController();

  void sendMessage(DatabaseReference chatRef, String message, String author, String name, User user, Group group, BuildContext context) async{
    DataSnapshot chatSnapshot = await chatRef.get();
    String chats = chatSnapshot.value.toString();
    Map<String, dynamic> chatJSON = jsonDecode(chats);
    String key = author + ", " + DateTime.now().toString();
    Map<String, String> valueMap = {
      "name": name,
      "message": message
    };
    chatJSON[key] = valueMap;
    String chat = jsonEncode(chatJSON);
    await chatRef.set(chat);
    build(context);

    // Navigator.pop(context);
    // Navigator.pushReplacementNamed(context, "/chatroom", arguments: {
    //   "group": group,
    //   "user": user
    // });
  }

  Future<String> getChat(DatabaseReference grpRef) async{
    DataSnapshot chatSnapshot = await grpRef.child("chats").get();
    String chats = chatSnapshot.value.toString();
    return chats;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    User? _user = args["user"];
    Group grp = args["group"];
    List<ChatMessage> messages= [];
  // Timer.periodic(Duration(milliseconds: 1), (timer) {

    String chat = "{}";
    getChat(grp.grpRef).then((value) {
      print(value);
      chat = value;
      Map<String, dynamic> chatMap = jsonDecode(chat);
      chatMap.forEach((key, value) {
        String chatType = "receiver";
        String email = key.split(", ")[0];
        if(_user!.email == email+".com"){
          chatType = "sender";
        }
        messages.add(ChatMessage(author: value["name"]!, messageContent: value["message"]!, messageType: chatType));
      });
    });


  // });


    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffd8e0fb),
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                const CircleAvatar(

                  maxRadius: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        grp.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      // Text(
                      //   "$onlineNo Online",
                      //   style: TextStyle(
                      //       color: Colors.grey.shade600, fontSize: 13),
                      // ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder(future: getChat(grp.grpRef), builder: (context, snapshot) {
        if(!snapshot.hasError){
          return Stack(
            children: <Widget>[
              ListView.builder(
                itemCount: messages.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // return Container(
                  //   padding:
                  //       EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  //   child: Text(messages[index].messageContent),
                  // );
                  return Container(
                    padding: const EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: Align(
                      alignment: (messages[index].messageType == "receiver"
                          ? Alignment.topLeft
                          : Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (messages[index].messageType == "receiver"
                              ? Colors.grey.shade200
                              : Colors.blue[200]),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: messages[index].messageType == "receiver"
                            ? Column(
                          children: [
                            Container(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  messages[index].author,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xdd03032c)),
                                ),
                              ),
                            ),
                            // SizedBox(width: 2),
                            Container(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  messages[index].messageContent,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        )
                            : Text(
                          messages[index].messageContent,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(
                          controller: msgController,
                          decoration: InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          String msg = msgController.text.trim();
                          DatabaseReference chatRef = grp.grpRef.child("chats");
                          String userId = _user!.email!.substring(0, _user.email!.length-4);
                          sendMessage(chatRef, msg, userId, "Shaun Not Allan", _user, grp, context);
                        },
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        backgroundColor: Colors.blue,
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        else{
          return Scaffold();
        }
      })
    );

  }

}
