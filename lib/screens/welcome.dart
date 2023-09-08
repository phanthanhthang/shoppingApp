import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/components.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.imageUrl});
  final String imageUrl;
  static String id = 'welcome_screen';
  static Object shark = Object(fileName: "assets/images/Table_wooden.obj");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("Flutter 3D"),
        ),
        body: Stack(
          children: <Widget>[
            const ModelViewer(
              backgroundColor: Color.fromARGB(255, 36, 4, 4),
              src: 'assets/images/table.glb',
              alt: 'A 3D model of an astronaut',
              autoRotate: false,
              cameraOrbit: "3.856deg 80.18deg 50.28m",
              fieldOfView: "13.02deg",
              disableZoom: true,
            ),
            Positioned(
                width: MediaQuery.of(context).size.width,
                top: MediaQuery.of(context).size.width * 0.98,
                child: SizedBox(
                  height: 70,
                  width: 70,
                  child: Image.network(imageUrl),
                ))
          ],
        ));
  }
}
