import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../components/components.dart';
import '../constants.dart';
import '../features/home/service/service.dart';
import '../features/home/view/home_view.dart';
import '../screens/welcome.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddProduct extends StatefulWidget {
  static String id = 'add_product';
  const AddProduct({super.key, required this.uid});
  final String uid;

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  late File file;
  final ImagePicker picker = ImagePicker();

  late String _title;
  late String _price;
  late String _description;
  late String _stock;
  late String _image;
  bool _saving = false;
  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } catch (e) {
      return;
    }
  }

  // Future choiceImage() async {
  //   var pickerImage = await picker.getImage(source: ImageSource.gallery);
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.id);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoadingOverlay(
          isLoading: _saving,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const ScreenTitle(title: 'Profile'),
                        CustomTextField(
                          textField: TextField(
                              onChanged: (value) {
                                _title = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                  hintText: 'Title')),
                        ),
                        CustomTextField(
                          textField: TextField(
                              keyboardType: TextInputType.multiline,
                              onChanged: (value) {
                                _description = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                  hintText: 'Description')),
                        ),
                        CustomTextField(
                          textField: TextField(
                              onChanged: (value) {
                                _price = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                  hintText: 'Price')),
                        ),
                        CustomTextField(
                          textField: TextField(
                              onChanged: (value) {
                                _stock = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                  hintText: 'Stock')),
                        ),
                        MaterialButton(
                            color: Colors.blue,
                            child: const Text("Pick Image from Gallery",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              pickImage();
                            }),
                        CustomBottomScreen(
                          textButton: 'Login',
                          heroTag: 'login_btn',
                          question: 'Forgot password?',
                          buttonPressed: () {
                            //ocusManager.instance.primaryFocus?.unfocus();
                            Services.addProduct(_title, _description, _price,
                                    _stock, widget.uid)
                                .then((result) {
                              if ("success" == result) {
                                print("add finished");
                              }
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeView(uid: widget.uid),
                              ),
                            );
                            print(_title + _description + _price + _stock);
                          },
                          questionPressed: () {},
                        ),
                      ],
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
