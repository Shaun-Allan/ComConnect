import 'package:flutter/material.dart';
import 'package:community_chat_forum/services/community.dart';


Widget buildCommunityTile(Community com) {
  return Column(
    children: [

      Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.02, color: Colors.black)
            )
        ),
        child: ListTile(
          hoverColor: const Color(0xffe1e1e1),
          leading: Image.asset('assets/community_dp.png'),
          title: Text(com.name),
        ),
      ),
      const SizedBox(
        height: 5,
      ),
    ],
  );
}


Widget buildGroupTile(Group grp) {
  return Column(
    children: [

      Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.02, color: Colors.black)
            )
        ),
        child: ListTile(
          hoverColor: const Color(0xffe1e1e1),
          leading: Image.asset('assets/community_dp.png'),
          title: Text(grp.name),
        ),
      ),
      const SizedBox(
        height: 5,
      ),
    ],
  );
}