import 'package:community_chat_forum/services/community.dart';
import 'package:flutter/material.dart';
import 'package:community_chat_forum/components/build_group_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {



  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    Community community = args["community"];
    User? user = args["user"];
    List<Group> groups = [];

    community.getGroups(community.comGrpRef!).then((value) {
      groups = value;
      print(groups[0].name);
    });

    return FutureBuilder(future: community.getGroups(community.comGrpRef!), builder: (context, snapshot) {
      if(!snapshot.hasError){
        return Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
            title: Text(community.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_sharp),
                hoverColor: const Color(0xff162773),
                onPressed: () {
                  Navigator.pushNamed(context, '/createGroup', arguments: {
                    "user": user,
                    "community": community
                  });
                },
              )
            ],
          ),
          body: ListView.builder(
            itemCount: groups.length,
            itemBuilder: (BuildContext, int index) {
              return GestureDetector(
                child: buildGroupTile(groups[index]),
                onTap: () {
                  Navigator.pushNamed(context, "/chatroom", arguments: {
                    "user": args["user"],
                    "group": groups[index]
                  });
                },
              );
            }
        ),
        );
      }
      else{
        return Scaffold();
      }
    });
  }
}
