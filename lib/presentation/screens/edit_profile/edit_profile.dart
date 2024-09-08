import 'dart:developer';
import 'dart:io';

import 'package:emergency_app/presentation/controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../../provider/screen_provider.dart';
import '../../widgets/heading_text.dart';
import '../../widgets/icon_button.dart';
import '../../widgets/overlay_loading.dart';
import '../../widgets/text_button.dart';
import '../../widgets/text_field.dart';
import '../../widgets/toast.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  static const routeName = "/Edit-Profile-Screen";

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  bool isEditing = false;

  final TextEditingController userNameController = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.displayName);

  final TextEditingController emailController =
      TextEditingController(text: FirebaseAuth.instance.currentUser!.email);

  final _formKey = GlobalKey<FormState>();

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

  final UserController _userController = GetIt.I<UserController>();

  @override
  Widget build(BuildContext context) {
    final screenNotifier = ref.watch(screenNotifierProvider.notifier);
    return Scaffold(
      body: OverlayLoadingWidget(
        isLoading: ref.watch(screenNotifierProvider),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButtonWidget(
                      icon: Icons.arrow_back,
                      onPressedFunction: () {
                        Navigator.pop(context);
                      },
                      iconSize: 20,
                    ),
                    HeadingTextWidget(
                      heading: "Edit Profile",
                      fontSize: 25,
                    ),
                    IconButtonWidget(
                      icon: Icons.edit,
                      onPressedFunction: () {
                        if (isEditing == true) {
                          isEditing = false;
                        } else {
                          isEditing = true;
                        }
                        setState(() {});
                      },
                      iconSize: 20,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    pickedImage != null
                        ? SizedBox(
                            height: 120,
                            width: 120,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.file(
                                  File(pickedImage!.path),
                                  fit: BoxFit.cover,
                                )),
                          )
                        : ClipOval(
                            child: SizedBox.fromSize(
                            size: const Size.fromRadius(60), // Image radius
                            child: Image.network(
                                FirebaseAuth.instance.currentUser!.photoURL!,
                                fit: BoxFit.fill, loadingBuilder:
                                    (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Lottie.asset(
                                      'assets/lottie/loading.json'));
                            }),
                          )),
                    if (isEditing)
                      TextButtonWidget(
                        buttonWidth: MediaQuery.of(context).size.width * 0.5,
                        function: () async {
                          pickImage(ImageSource.gallery);
                        },
                        isSelected: false,
                        text: 'Upload Image',
                      ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                HeadingTextWidget(
                  heading: "Profile Data",
                  fontSize: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFieldWidget(
                      hintText: "Username",
                      controller: userNameController,
                      isPassword: false,
                      isEnabled: isEditing,
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
                      isEnabled: isEditing,
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
                  ]),
                ),
                const Spacer(),
                if (isEditing)
                  TextButtonWidget(
                    buttonWidth: MediaQuery.of(context).size.width,
                    function: () async {
                      FocusScope.of(context).unfocus();
                      screenNotifier.updateLoading(isLoading: true);

                      if (_formKey.currentState!.validate()) {
                        log("message");
                        await _userController.handleUpdatingUserProfile(
                            email: emailController.text,
                            userName: userNameController.text,
                            imagePath: pickedImage?.path);
                      }
                      screenNotifier.updateLoading(isLoading: false);
                    },
                    isSelected: true,
                    text: 'Save',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
