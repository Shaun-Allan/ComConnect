import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:community_chat_forum/services/community.dart';
import 'package:community_chat_forum/components/build_group_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int ind = 0;



  @override
  Widget build(BuildContext context) {
    final args = ModalRoute
        .of(context)
        ?.settings
        .arguments as Map<String, User?>;
    User? _user = args["user"];
    print(_user);


    DatabaseReference _dbref = FirebaseDatabase.instance.ref();
    print(_dbref.path);

    List<Community> communities = [];

    getCommunities(_user, _dbref).then((value) {
      print(value[1].name);
      communities = value;
    });


    List<Widget> _widgetOptions = [
      FutureBuilder(
          future: getCommunities(_user, _dbref), builder: (context, snapshot) {
        if (!snapshot.hasError) {
          return ListView.builder(
              itemCount: communities.length,
              itemBuilder: (BuildContext, int index) {
                return GestureDetector(
                  child: buildCommunityTile(communities[index]),
                  onTap: () {
                    Navigator.pushNamed(context, "/groups", arguments: {
                      "community": communities[index],
                      "user": _user
                    });
                  },
                );
              }
          );
        }
        else {
          return Scaffold();
        }
      }),

      Scaffold(
        body: Text("Profile"),
      ),

      Scaffold(
        body: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 13,
            minimumSize: const Size(250, 65),
          ),
          onPressed: (){

          },
          child: const Text('Create Community'),
        ),
      )
    ];


    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Image.asset('assets/comchat_appbar_icon.png'),
        ),
        title: const Text('ComChat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_sharp),
            hoverColor: const Color(0xff162773),
            onPressed: () {
              Navigator.pushNamed(context, '/addcom', arguments: {
                "user": _user
              });
            },
          )
        ],
      ),
      body: _widgetOptions[ind],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: ind,
        onTap: (index) {
          setState(() {
            ind = index;
          });
        },
      ),


    );
  }
  }
