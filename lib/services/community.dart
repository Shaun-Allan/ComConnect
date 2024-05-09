import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class Community {
  String communityId = "";
  String name = "";
  List<String> members = [];
  List<String> admins = [];
  DatabaseReference? comGrpRef = null;

  Community(String communityId, String name, String members, String admins, DatabaseReference comGrpRef){
    this.communityId = communityId;
    this.name = name;
    this.members = convertStringToList(members);
    this.admins = convertStringToList(admins);
    this.comGrpRef = comGrpRef;

    // getGroups(comGrpRef).then((value){
    //   this.groups = value;
    // });



  }

  Future<List<Group>> getGroups(DatabaseReference comGrpRef) async{
    List<Group> groups = [];
    int grpId = 1001;
    DatabaseReference grpRef = comGrpRef.child(grpId.toString());
    DataSnapshot grpSnapshot = await grpRef.get();

    while(grpSnapshot.exists){
      DataSnapshot nameSnapShot = await grpRef.child('name').get();
      DataSnapshot descSnapShot = await grpRef.child('description').get();
      DataSnapshot chatsSnapShot = await grpRef.child('chats').get();


      groups.add(Group(grpId.toString(), nameSnapShot.value.toString(), descSnapShot.value.toString(), chatsSnapShot.value.toString(), grpRef));

      grpId++;
      grpRef = comGrpRef.child(grpId.toString());
      grpSnapshot = await grpRef.get();
    }

    return groups;
  }

}

class Group {
  String groupId;
  String name;
  String desc;
  String chats;
  DatabaseReference grpRef;


  Group(this.groupId, this.name, this.desc, this.chats, this.grpRef);
}


Future<List<Community>> getCommunities(User? _user, DatabaseReference dbRef) async{
    List<Community> extractedComs = [];
    print(_user!.email.toString().substring(0, _user!.email.toString().length-4));
    DatabaseReference userRef = dbRef.child('Users').child(_user!.email.toString().substring(0, _user!.email.toString().length-4));
    print(userRef.path);
    final userSnapshot = await userRef.get();
    print(userSnapshot.value.toString());
    if(userSnapshot.exists){
      DatabaseReference userComRef = userRef.child('communities');
      final userComSnapshot = await userComRef.get();
      String comString = userComSnapshot.value.toString();
      List<String> comList = convertStringToList(comString);
      await extractCommunities(comList, dbRef).then((value){
        extractedComs = value;
      });


    }
    else{
      print("no");
    }
    return extractedComs;
}

List<String> convertStringToList(String s){
  List<String> list= [];
  String sub = "";
  for(int i=0; i<s.length; i++){
    if(s[i]==',') {
      list.add(sub);
      sub = "";
    }
    else {
      sub = sub + s[i];
    }
  }
  return list;
}

Future extractCommunities(List<String> comListString, DatabaseReference dbRef) async{
  List<Community> extractedComs = [];
  DatabaseReference dbComRef = dbRef.child('Communities');
  for(int i=0; i<comListString.length; i++){
    DatabaseReference comRef = dbComRef.child(comListString[i]);
    DataSnapshot comName = await comRef.child('name').get();
    DataSnapshot comMembers = await comRef.child('members').get();
    DataSnapshot comAdmins = await comRef.child('admins').get();

    print(comListString[i]);


    extractedComs.add(Community(comListString[i], comName.value.toString(), comMembers.value.toString(), comAdmins.value.toString(), comRef.child('Groups')));

  }
  
  
  return extractedComs;
}
