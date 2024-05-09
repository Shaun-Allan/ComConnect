
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[700],
      body: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login_bg.jpg'),
                fit: BoxFit.cover,
                opacity: 0.25,
              )
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 130.0, 0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget> [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical:15.0, horizontal:45.0),
                    child: Image.asset('assets/comchat_icon.png', fit: BoxFit.cover,),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 45.0),
                    child: SizedBox(
                      height: 50.0,
                      child: SignInButton(Buttons.google,
                        text: "Sign in with Google",
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, "/loading");
                        },
                      ),
                    ),
                  )
                ],
              ),
            )
          )
        )
      ),
    );
  }
}
