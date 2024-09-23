import 'dart:developer';
import 'dart:io';

import 'package:emergency_app/data/models/user_model.dart';
import 'package:emergency_app/presentation/controllers/user_controller.dart';
import 'package:emergency_app/presentation/provider/user_provider.dart';
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

  TextEditingController _userNameController = TextEditingController();

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();

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
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userNameController.text = ref.watch(userNotifierProvider).userName;
      _firstNameController.text = ref.watch(userNotifierProvider).firstName;
      _lastNameController.text = ref.watch(userNotifierProvider).lastName;
      _phoneNumberController.text = ref.watch(userNotifierProvider).phoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenNotifier = ref.watch(screenNotifierProvider.notifier);
    return Scaffold(
      body: OverlayLoadingWidget(
        isLoading: ref.watch(screenNotifierProvider),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButtonWidget(
                        icon: Icons.arrow_back,
                        isFilled: true,
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
                        isFilled: true,
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
                                  ref.watch(userNotifierProvider).photoUrl,
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
                        controller: _userNameController,
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
                        hintText: "First Name",
                        controller: _firstNameController,
                        isPassword: false,
                        isEnabled: isEditing,
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
                        isEnabled: isEditing,
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
                        hintText: "Phone Number",
                        controller: _phoneNumberController,
                        isPassword: false,
                        isEnabled: isEditing,
                        validationFunction: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone Number is required';
                          }
                          return null;
                        },
                        textInputType: TextInputType.phone,
                        textFieldWidth: MediaQuery.of(context).size.width,
                        onValueChange: (value) {},
                        maxLines: 1,
                        borderCircular: 10,
                      ),
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (isEditing)
                    TextButtonWidget(
                      buttonWidth: MediaQuery.of(context).size.width,
                      function: () async {
                        FocusScope.of(context).unfocus();
                        screenNotifier.updateLoading(isLoading: true);
                        String? url;
                        if (_formKey.currentState!.validate()) {
                          if (pickedImage != null) {
                            url = await _userController
                                .handleUploadingNewProfileImage(
                                    oldFilePath: ref
                                        .watch(userNotifierProvider)
                                        .photoUrl,
                                    filePath: pickedImage!.path);
                          }

                          await _userController.editProfile(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              phoneNumber: _phoneNumberController.text,
                              url: url ??
                                  ref.watch(userNotifierProvider).photoUrl,
                              userName: _userNameController.text);
                          log(url.toString());
                          ref
                              .watch(userNotifierProvider.notifier)
                              .updateUserModel(
                                  userModel: UserModel(
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                      phoneNumber: _phoneNumberController.text,
                                      photoUrl: url ??
                                          ref
                                              .watch(userNotifierProvider)
                                              .photoUrl,
                                      userName: _userNameController.text,
                                      uid: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      token: ref
                                          .watch(userNotifierProvider)
                                          .token));
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
      ),
    );
  }
}
