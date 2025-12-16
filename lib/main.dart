import 'package:chat_app/pages/chat_screen.dart';
import 'package:chat_app/pages/login_Screen.dart';
import 'package:chat_app/pages/register_screen.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ScholarChat());
}

class ScholarChat extends StatelessWidget {
  const ScholarChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        chatScreen.id: (context) => chatScreen(),
      },
      initialRoute: "Login Screen",
      debugShowCheckedModeBanner: false,
    );
  }
}
