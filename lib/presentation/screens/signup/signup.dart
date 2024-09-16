import 'dart:io';

import 'package:emergency_app/presentation/controllers/storage_controller.dart';
import 'package:emergency_app/presentation/widgets/heading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/color_constants.dart';
import '../../controllers/auth_controller.dart';
import '../../provider/screen_provider.dart';
import '../../widgets/overlay_loading.dart';
import '../../widgets/text_button.dart';
import '../../widgets/text_field.dart';
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

  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  HeadingTextWidget(heading: "Sign Up", fontSize: 25),
                  const SizedBox(
                    height: 50,
                  ),
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
                        controller: _userNameController,
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
                        controller: _firstNameController,
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
                        controller: _lastNameController,
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
                        controller: _emailController,
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
                        textInputType: TextInputType.emailAddress,
                        textFieldWidth: MediaQuery.of(context).size.width,
                        onValueChange: (value) {},
                        maxLines: 1,
                        borderCircular: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldWidget(
                        hintText: "Phone Number",
                        controller: _phoneNumberController,
                        isPassword: false,
                        isEnabled: true,
                        validationFunction: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone Number is required';
                          } else if (value.length > 10) {
                            return 'Length of phone number is invalid. Length is 10';
                          }
                          return null;
                        },
                        textInputType: TextInputType.phone,
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
                        controller: _passwordController,
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
                      TextFieldWidget(
                        hintText: "Confirm Password",
                        controller: _confirmPasswordController,
                        isPassword: true,
                        isEnabled: true,
                        validationFunction: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm Password is required';
                          } else if (value.length < 8) {
                            return 'Confirm Password must have 8 characters';
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
                        if (_passwordController.text !=
                            _confirmPasswordController.text) {
                          toastWidget(
                              isError: true,
                              message:
                                  "Password don't match. Please try again");
                        } else {
                          final url =
                              await _storageController.handleImageUploading(
                                  pickedImage!.path.toString());
                          if (url != null) {
                            await _authController.handleSignUp(
                                email: _emailController.text,
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                phoneNumber: _phoneNumberController.text,
                                password: _passwordController.text,
                                url: url,
                                userName: _userNameController.text);
                          }
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
                  const SizedBox(
                    height: 50,
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
