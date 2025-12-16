import 'package:chat_app/constants.dart';
import 'package:chat_app/pages/chat_screen.dart';
import 'package:chat_app/pages/register_screen.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String id = "Login Screen";

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

GlobalKey<FormState> formKey = GlobalKey();

String? email;
String? password;
bool isLoading = false;

class _LoginScreenState
    extends State<LoginScreen> {
  double _logoVerticalOffset = -450.0;
  double _textOpacity = 0.0;
  static const double _targetLogoOffset = -300.0;
  static const double _fixedFormTopOffset = -10.0;

  // to do change during running Ui

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        setState(() {
          _logoVerticalOffset = _targetLogoOffset;
        });
      },
    );

    Future.delayed(
      const Duration(milliseconds: 1200),
      () {
        setState(() {
          _textOpacity = 1.0;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(
                seconds: 1,
              ),
              curve: Curves.easeOutBack,
              left: 0,
              right: 0,
              top:
                  MediaQuery.of(
                        context,
                      ).size.height /
                      2 +
                  _logoVerticalOffset,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/message-app.png',
                    fit: BoxFit.fill,
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    duration: const Duration(
                      milliseconds: 500,
                    ),
                    opacity: _textOpacity,
                    child: const Text(
                      "S c h o l a r   Chat",
                      style: TextStyle(
                        fontFamily: "BB",
                        fontSize: 35,
                        color: Color(0xFF9575CD),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //علشان افصل اللي فوق عن اللي تحت
            Positioned(
              left: 0,
              right: 0,
              top:
                  MediaQuery.of(
                        context,
                      ).size.height /
                      2.2 +
                  _fixedFormTopOffset,
              bottom: 0,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(
                          bottom: 20.0,
                        ),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Align(
                          alignment:
                              Alignment
                                  .centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(
                                  left: 15,
                                ),
                            child: Text(
                              "LOGIN",
                              style:
                                  const TextStyle(
                                    fontFamily:
                                        "BB",
                                    fontSize: 25,
                                    color: Color(
                                      0xFFD1C4E9,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                          child: CustomTextField(
                            onChanged: (data) {
                              email = data;
                            },

                            hintText: "Email",
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                          child: CustomTextField(
                            onChanged: (data) {
                              password = data;
                            },
                            hintText: "Password",
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding:
                              const EdgeInsets.all(
                                8.0,
                              ),
                          child: CustomButton(
                            onTap: () async {
                              if (formKey
                                  .currentState!
                                  .validate()) {
                                isLoading = true;
                                setState(() {});
                                try {
                                  await LoginUser();
                                  Navigator.pushNamed(
                                    context,
                                    chatScreen.id,
                                  );
                                } on FirebaseAuthException catch (
                                  ex
                                ) {
                                  if (ex.code ==
                                      "user-not-found") {
                                    // خطأ تسجيل الدخول
                                    showSnackBar(
                                      context,
                                      "No user found for that email.",
                                    );
                                  } else if (ex
                                          .code ==
                                      "wrong-password") // خطأ تسجيل الدخول
                                  {
                                    showSnackBar(
                                      context,
                                      "Wrong password provided for that user.",
                                    );
                                  } else {
                                    showSnackBar(
                                      context,
                                      ex.message ??
                                          "An error occurred during login.",
                                    );
                                  }
                                } catch (ex) {
                                  print(ex);
                                  showSnackBar(
                                    context,
                                    "there was an error please try again",
                                  );
                                } finally {
                                  isLoading =
                                      false;
                                  setState(() {});
                                }
                              }
                            },

                            text: "LOGIN",
                          ),
                        ),
                        Center(
                          child: Text(
                            "Don,t Have Any Accounts ? ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RegisterScreen.id,
                            );
                          },
                          child: Center(
                            child: Text(
                              " Register Now ",
                              style: TextStyle(
                                color: Color(
                                  0xFF9575CD,
                                ),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSnackBar(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          // تم تصحيح هذا الجزء لاستخدام رسالة الخطأ الفعلية
          message,
        ),
      ),
    );
  }

  // تم تغيير اسم الدالة واستخدام signInWithEmailAndPassword لعملية تسجيل الدخول
  Future<void> LoginUser() async {
    var auth = FirebaseAuth.instance;
    await auth.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
