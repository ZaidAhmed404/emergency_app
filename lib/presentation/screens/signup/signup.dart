import 'dart:io';

import 'package:emergency_app/presentation/controllers/storage_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Constants/color_constants.dart';
import '../../Widgets/text_button.dart';
import '../../Widgets/text_field.dart';
import '../../controllers/auth_controller.dart';
import '../../provider/screen_provider.dart';
import '../../widgets/overlay_loading.dart';
import '../../widgets/toast.dart';
import '../login/login.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  SignUpScreen({super.key});

  static const routeName = "/Signup-Screen";

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
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
      setState(() {
        pickedImage = image;
      });
    } on PlatformException catch (e) {
      toastWidget(isError: true, message: "Failed to pick image");
    }
  }

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final AuthController _authController = GetIt.I<AuthController>();
  final StorageController _storageController = GetIt.I<StorageController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenNotifier = ref.watch(screenNotifierProvider.notifier);
    return OverlayLoadingWidget(
      isLoading: ref.watch(screenNotifierProvider),
      child: Scaffold(
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
                          style:
                              TextStyle(color: ColorConstants().primaryColor),
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
                  buttonWidth: MediaQuery.of(context).size.width,
                  function: () async {
                    FocusScope.of(context).unfocus();
                    screenNotifier.updateLoading(isLoading: true);
                    if (pickedImage == null) {
                      toastWidget(
                          message: 'Please Upload Image', isError: true);
                    } else if (_formKey.currentState!.validate()) {
                      final url = await _storageController
                          .handleImageUploading(pickedImage!.path.toString());
                      if (url != null) {
                        await _authController.handleSignUp(
                            email: emailController.text,
                            password: passwordController.text,
                            url: url,
                            userName: usernameController.text);
                      }
                    }

                    screenNotifier.updateLoading(isLoading: false);
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
                        Navigator.of(context)
                            .pushReplacementNamed(LoginScreen.routeName);
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
      ),
    );
  }
}
