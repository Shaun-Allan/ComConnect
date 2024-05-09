import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:community_chat_forum/services/community.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();


  void _createGroup(User? _user, Community community) async{
    String name = _nameController.text.trim();
    String description = _descriptionController.text.trim();

    if (name.isNotEmpty && description.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Community created successfully!'),
        ),
      );
      String userId = _user!.email!.substring(0, _user!.email!.length-4);

      DatabaseReference dbRef = FirebaseDatabase.instance.ref();
      DatabaseReference comRef = dbRef.child("Communities").child(community.communityId);
      DataSnapshot lastIdSnapshot = await comRef.child("Last Group Id").get();
      int lastId = int.parse(lastIdSnapshot.value.toString());
      lastId++;
      if(lastId == 1001){
        comRef.update({
          "Groups": {
            lastId.toString(): {
              "chats": "{}",
              "description": description,
              "name": name
            }
          }
        });
      }
      else{
        DatabaseReference grpsRef = comRef.child("Groups");
        await grpsRef.update({
          lastId.toString(): {
            "chats": "{}",
            "description": description,
            "name": name
          }
        });
      }

      comRef.child("Last Group Id").set(lastId);



      Navigator.pushReplacementNamed(context, "/groups", arguments: {
        "user": _user,
        "community": community
      });

      // _nameController.clear();
      // _descriptionController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please enter a valid name and description for the Group.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    User? _user = args["user"];
    Community community = args["community"];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Community'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Group Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 13,
                minimumSize: const Size(250, 65),
              ),
              onPressed: (){
                _createGroup(_user, community);
              },
              child: const Text('Create Community'),
            ),
          ],
        ),
      ),
    );
  }
}
