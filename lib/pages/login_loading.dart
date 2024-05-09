import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';



class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  void _handleGoogleSignIn() async{
    try{
      GoogleAuthProvider _googleAuthProvider =  GoogleAuthProvider();
      await _auth.signInWithProvider(_googleAuthProvider);
      String userId = _user!.email!.substring(0, _user!.email!.length-4);
      DatabaseReference _dbref = FirebaseDatabase.instance.ref();
      DatabaseReference userRef = _dbref.child("Users");
      final userSnapshot = await userRef.get();
      if(!userSnapshot.hasChild(userId)){
        DatabaseReference ref = userRef;
        await ref.update({
          userId: {
            "communities": "",
            "name": _user!.displayName
          }
        });
      }
      Navigator.pushReplacementNamed(context, '/', arguments: {
        'user': _user,
      });
      // Navigator
    } catch(error){
      print(error);
    }
  }

  @override
  void initState(){
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    _handleGoogleSignIn();

    return Scaffold(
        backgroundColor: Colors.white,
        body: SpinKitRotatingCircle(
          color: Colors.blueAccent,
          size: 50,
        )
    );
  }
}
