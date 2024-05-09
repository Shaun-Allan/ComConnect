import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateCommunityPage extends StatefulWidget {
  @override
  _CreateCommunityPageState createState() => _CreateCommunityPageState();
}

class _CreateCommunityPageState extends State<CreateCommunityPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();


  void _createGroup(User? _user) async{
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
      DatabaseReference comRef = dbRef.child("Communities");
      DatabaseReference lastIdRef = dbRef.child("Last Community Id");
      DatabaseReference userRef = dbRef.child("Users").child(userId);
      DataSnapshot lastIdSnapshot = await lastIdRef.get();
      int lastId = int.parse(lastIdSnapshot.value.toString());
      lastId++;
      await comRef.update({
        lastId.toString(): {
          "Groups": {},
          "admins": userId+",",
          "members": userId+",",
          "name": name,
          "description": description
        }
      });
      DataSnapshot userComSnapshot = await userRef.child("communities").get();
      DatabaseReference userComRef = userRef.child("communities");
      String userComs = userComSnapshot.value.toString();
      userComs = userComs + lastId.toString() + ",";
      await userComRef.set(userComs);

      lastIdRef.set(lastId);

      Navigator.pushReplacementNamed(context, "/", arguments: {
        "user": _user
      });

      // _nameController.clear();
      // _descriptionController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please enter a valid name and description for the Community.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, User?>;
    User? _user = args["user"];
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
                labelText: 'Community Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Community Description',
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
                _createGroup(_user);
              },
              child: const Text('Create Community'),
            ),
          ],
        ),
      ),
    );
  }
}
