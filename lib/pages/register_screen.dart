import 'package:chat_app/pages/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

const primaryColor = Colors.black;

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  static String id = "Register Screen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  String? email;

  String? password;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFF9575CD),
          title: const Center(
            child: Text(
              "S c h o l a r  Chat",
              style: TextStyle(
                fontFamily: "BB",
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                const Text(
                  "R E G I S T E R",
                  style: TextStyle(
                    fontFamily: "BB",
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: CustomTextField(
                    onChanged: (data) {
                      email = data;
                    },
                    hintText: "Email",
                  ),
                ),

                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: CustomTextField(
                    onChanged: (data) {
                      password = data;
                    },
                    hintText: "Password",
                  ),
                ),

                const SizedBox(height: 40),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: CustomButton(
                    //add auth of firebase
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        isLoading = true;
                        setState(() {});
                        try {
                          await RegisterUser();
                          Navigator.pushNamed(context, chatScreen.id);
                          showSnackBar(context, "Register Successfully");
                        } on FirebaseAuthException catch (ex) {
                          if (ex.code == "weak-password") {
                            showSnackBar(context, "Password is too weak.");
                          } else if (ex.code == "email-already-in-use") {
                            showSnackBar(
                              context,
                              "Email is already registered.",
                            );
                          } else {
                            showSnackBar(
                              context,
                              ex.message ?? "An unknown error occurred.",
                            );
                          }
                        } catch (ex) {
                          print(ex);
                          showSnackBar(
                            context,
                            "there was an error please try again",
                          );
                        } finally {
                          isLoading = false;
                          setState(() {});
                        }
                      }
                    },

                    text: 'Register',
                  ),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Go started",
                    style: const TextStyle(
                      color: Color(0xFF9575CD),
                      fontSize: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> RegisterUser() async {
    var auth = FirebaseAuth.instance;
    UserCredential user = await auth.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
    print(user.user!.displayName);
  }
}
