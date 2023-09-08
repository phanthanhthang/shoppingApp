import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shopping_app/features/home/view/home_view.dart';
import '../components/components.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static String id = 'signup_screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final userCollections = FirebaseFirestore.instance.collection("users");
  late String _email;
  late String _password;
  late String _confirmPass;
  bool _saving = false;
  String userId = "";
  String pathFile = "";
  String uid = "";

  // Send Mail function
  void sendMail({
    required String recipientEmail,
    required String mailMessage,
    required Attachment path,
  }) async {
    // change your email here
    String username = 'thanhthang0512@gmail.com';
    // change your password here
    String password = 'fxqoskpryzdfaleo';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Mail Service')
      ..recipients.add(recipientEmail)
      ..subject = 'Mail '
      ..text = 'Message: $mailMessage'
      ..attachments.add(path);

    try {
      await send(message, smtpServer);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.id);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoadingOverlay(
          isLoading: _saving,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TopScreenImage(screenImageName: 'signup.png'),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const ScreenTitle(title: 'Sign Up'),
                          CustomTextField(
                            textField: TextField(
                              onChanged: (value) {
                                _email = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'Email',
                              ),
                            ),
                          ),
                          CustomTextField(
                            textField: TextField(
                              obscureText: true,
                              onChanged: (value) {
                                _password = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'Password',
                              ),
                            ),
                          ),
                          CustomTextField(
                            textField: TextField(
                              obscureText: true,
                              onChanged: (value) {
                                _confirmPass = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'Confirm Password',
                              ),
                            ),
                          ),
                          CustomBottomScreen(
                            textButton: 'Sign Up',
                            heroTag: 'signup_btn',
                            question: 'Have an account?',
                            buttonPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                _saving = true;
                              });
                              if (_confirmPass == _password) {
                                try {
                                  await _auth
                                      .createUserWithEmailAndPassword(
                                          email: _email, password: _password)
                                      .then((value) {
                                    if (value.user != null) {
                                      userId = value.user!.uid;
                                      userCollections.doc(userId).set({
                                        'password': _password,
                                        'email': _email
                                      });
                                    }
                                  });

                                  final image = await QrPainter(
                                    data: userId,
                                    version: QrVersions.auto,
                                    gapless: false,
                                  ).toImage(300);
                                  final a = await image
                                      .toByteData(format: ImageByteFormat.png)
                                      .then((value) async {
                                    if (value != null) {
                                      final filename = 'qr_code.png';
                                      final tempDir =
                                          await getTemporaryDirectory(); // Get temporary directory to store the generated image
                                      final file = await File(
                                              '${tempDir.path}/$filename')
                                          .create(); // Create a file to store the generated image
                                      var bytes = value.buffer
                                          .asUint8List(); // Get the image bytes
                                      await file.writeAsBytes(bytes);
                                      pathFile = file.path;
                                      sendMail(
                                        recipientEmail: _email,
                                        mailMessage:
                                            "Hello welcomeeee to our platform. We sent your QR CODE that permits you to authenticate to our platform",
                                        path: FileAttachment(File(file.path)),
                                      );
                                    } // Write the image bytes to the file
                                    //   final Email email = Email(
                                    //     body: 'Image QR CODE',
                                    //     subject: 'QR CODE',
                                    //     recipients: [_email],
                                    //     cc: ['cc@example.com'],
                                    //     bcc: ['bcc@example.com'],
                                    //     attachmentPaths: [file.path],
                                    //     isHTML: true,
                                    //   );
                                    //   print(email.attachmentPaths);
                                    //   await FlutterEmailSender.send(email);
                                    // }
                                  });

                                  if (context.mounted) {
                                    // QrImageView(
                                    //   data: userId,
                                    //   version: QrVersions.auto,
                                    //   size: 200.0,
                                    // );

                                    signUpAlert(
                                      context: context,
                                      title: 'GOOD JOB',
                                      desc: 'Go login now',
                                      btnText: 'Login Now',
                                      onPressed: () {
                                        setState(() {
                                          _saving = false;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeView(uid: userId),
                                            ),
                                          );
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HomeView(uid: userId),
                                          ),
                                        );
                                      },
                                    ).show();
                                  }
                                } catch (e) {
                                  signUpAlert(
                                      context: context,
                                      onPressed: () {
                                        SystemNavigator.pop();
                                      },
                                      title: 'SOMETHING WRONG',
                                      desc: 'Close the app and try again',
                                      btnText: 'Close Now');
                                }
                              } else {
                                showAlert(
                                    context: context,
                                    title: 'WRONG PASSWORD',
                                    desc:
                                        'Make sure that you write the same password twice',
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }).show();
                              }
                            },
                            questionPressed: () async {
                              Navigator.pushNamed(context, LoginScreen.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
