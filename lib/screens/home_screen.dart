import 'package:flutter/material.dart';
import '../components/components.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../features/home/view/home_view.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static String id = 'home_screen';
  static String qrCode = "";

  Future<String> _scanQR() async {
    AppBar(
      backgroundColor: const Color(0xFFFF7D54),
      title: const Text(
        'Scanning Code',
        style: TextStyle(
          fontFamily: 'Product Sans',
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      centerTitle: true,
    );
    var qrResult = await BarcodeScanner.scan();
    qrCode = qrResult.rawContent;
    print(qrCode);
    return qrResult.rawContent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 231, 231),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TopScreenImage(screenImageName: 'logo.png'),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 15.0, left: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Hero(
                        tag: 'login_btn',
                        child: CustomButton(
                          buttonText: 'Get started',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeView(uid: ""),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Hero(
                        tag: 'signup_btn',
                        child: CustomButton(
                          buttonText: 'Sign Up',
                          isOutlined: true,
                          onPressed: () {
                            Navigator.pushNamed(context, SignUpScreen.id);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text(
                        'Log in using QR Code',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                      Hero(
                        tag: 'qrCode_btn',
                        child: CustomButton(
                          buttonText: 'Scan QR Code',
                          isOutlined: true,
                          onPressed: () {
                            _scanQR().then((value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeView(uid: value),
                                  ),
                                ));
                            //print(qrCode);
                          },
                        ),
                      ),
                      // IconButton(
                      //   onPressed: () {},
                      //   icon: CircleAvatar(
                      //     radius: 25,
                      //     child: Image.asset('assets/images/QR.jpg'),
                      //   ),
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     IconButton(
                      //       onPressed: () {},
                      //       icon: CircleAvatar(
                      //         radius: 25,
                      //         child: Image.asset(
                      //             'assets/images/icons/facebook.png'),
                      //       ),
                      //     ),
                      //     IconButton(
                      //       onPressed: () {},
                      //       icon: CircleAvatar(
                      //         radius: 25,
                      //         backgroundColor: Colors.transparent,
                      //         child:
                      //             Image.asset('assets/images/icons/google.png'),
                      //       ),
                      //     ),
                      //     IconButton(
                      //       onPressed: () {},
                      //       icon: CircleAvatar(
                      //         radius: 25,
                      //         child: Image.asset('assets/images/QR.jpg'),
                      //       ),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
