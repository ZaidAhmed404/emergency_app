import 'dart:io';

import 'package:emergency_app/Screens/LoginScreen/LoginScreen.dart';
import 'package:emergency_app/Widgets/TextButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../Constants/ColorConstants.dart';
import '../../Widgets/TextFieldWidget.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  static const routeName = "/Signup-Screen";
  XFile? pickedImage;

  Future pickImage(ImageSource source) async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 60,
        maxHeight: 600,
        maxWidth: 600,
      );
      if (image == null) return;
      // final imageTemporary = io.File(image.path);
      // setState(() {
      pickedImage = image;
      // });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController firstController = TextEditingController();

  final TextEditingController lastController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              const Text(
                'Sign Up',
                style: TextStyle(fontSize: 28),
              ),
              const Spacer(),
              Row(
                children: [
                  pickedImage != null
                      ? SizedBox(
                          height: 50,
                          width: 50,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.file(
                                File(pickedImage!.path),
                                fit: BoxFit.cover,
                              )),
                        )
                      : SizedBox(
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/images/user.png',
                              // height: 100,
                            ),
                          ),
                        ),
                  TextButton(
                      onPressed: () {
                        pickImage(ImageSource.gallery);
                      },
                      child: Text(
                        'Select Image',
                        style: TextStyle(color: ColorConstants().primaryColor),
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(children: [
                  TextFieldWidget(
                    hintText: "Username",
                    controller: usernameController,
                    isPassword: false,
                    isEnabled: true,
                    validationFunction: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                    textInputType: TextInputType.text,
                    textFieldWidth: MediaQuery.of(context).size.width,
                    onValueChange: (value) {},
                    maxLines: 1,
                    borderCircular: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    hintText: "First Name",
                    controller: firstController,
                    isPassword: false,
                    isEnabled: true,
                    validationFunction: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First Name is required';
                      }
                      return null;
                    },
                    textInputType: TextInputType.text,
                    textFieldWidth: MediaQuery.of(context).size.width,
                    onValueChange: (value) {},
                    maxLines: 1,
                    borderCircular: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    hintText: "Last Name",
                    controller: lastController,
                    isPassword: false,
                    isEnabled: true,
                    validationFunction: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last Name is required';
                      }
                      return null;
                    },
                    textInputType: TextInputType.text,
                    textFieldWidth: MediaQuery.of(context).size.width,
                    onValueChange: (value) {},
                    maxLines: 1,
                    borderCircular: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    hintText: "Email Address",
                    controller: emailController,
                    isPassword: false,
                    isEnabled: true,
                    validationFunction: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      } else if (value.length < 8) {
                        return 'Email must have 8 characters';
                      } else if (!value.contains("@") ||
                          !value.contains(".com")) {
                        return 'Please enter correct email';
                      }
                      return null;
                    },
                    textInputType: TextInputType.text,
                    textFieldWidth: MediaQuery.of(context).size.width,
                    onValueChange: (value) {},
                    maxLines: 1,
                    borderCircular: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    hintText: "Password",
                    controller: passwordController,
                    isPassword: true,
                    isEnabled: true,
                    validationFunction: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      } else if (value.length < 8) {
                        return 'Password must have 8 characters';
                      }
                      return null;
                    },
                    textInputType: TextInputType.text,
                    textFieldWidth: MediaQuery.of(context).size.width,
                    onValueChange: (value) {},
                    maxLines: 1,
                    borderCircular: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ]),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButtonWidget(
                function: () async {
                  if (_formKey.currentState!.validate()) {
                    // if (pickedImage == null) {
                    //   toast('Upload Image', context: context);
                    // } else {
                    //   await auth.signupWithEmailAndPass(
                    //       email: email,
                    //       pass: pass,
                    //       username: username,
                    //       image: pickedImage!.path,
                    //       fName: firstName,
                    //       lName: lastName,
                    //       context: context);
                    //   Navigator.pop(context);
                    // }

                    // setState(() {});
                    // .then((value) => Navigator.of(context)
                    //     .pushNamed(BottomBarScreen.routeName));
                  }
                },
                text: 'Register',
                isSelected: true,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already Have Account?',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Color(0xffE74140)),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
