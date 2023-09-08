import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/features/home/view/home_view.dart';
import 'product/manager/connectivity_manager.dart';
import 'core/extensions/app_extensions.dart';
import 'features/common/splash/view/splash_view.dart';
import 'core/init/navigation/navigation_route.dart';
import 'core/init/navigation/navigation_service.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/welcome.dart';
import 'screens/add_product.dart';
//import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBUYgLDXqsHfNZ71c-0_xy14aWdl82gFTI",
            appId: "1:730340885525:web:f36a374d6c8250d2fdfa1c",
            messagingSenderId: "730340885525",
            projectId: "shopingapp-61986"));
  }
  await Firebase.initializeApp();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ConnectivityManager(),
          )
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  static const String path = '/';
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontFamily: 'Ubuntu',
        ),
      )),
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        AddProduct.id: (context) => const AddProduct(uid: ""),
        SignUpScreen.id: (context) => SignUpScreen(),
        "/image": (context) => const WelcomeScreen(
              imageUrl: "http://192.168.1.197/ProductsDB/uploads/cafe4.png",
            ),
        '/home': (context) => const HomeView(uid: ""),
      },
    );
  }
}
