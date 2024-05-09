import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddCommunites extends StatefulWidget {
  @override
  _AddCommunitesState createState() => _AddCommunitesState();
}

class _AddCommunitesState extends State<AddCommunites> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, User?>;
    User? _user = args["user"];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join/Create Communities'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 40, 8.0, 0),
        child: Center(
          child: Column(
            children: [
              TextButton.icon(
                  onPressed: () {

                  },
                  icon: const Icon(Icons.join_right_rounded),
                  label: const Text('Join a Community')),
              const SizedBox(
                height: 20,
              ),
              TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, "/createCom", arguments: {
                      "user": _user
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create a Community')),
            ],
          ),
        ),
      ),
    );
  }
}
