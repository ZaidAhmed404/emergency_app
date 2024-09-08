import 'dart:io';

import 'package:emergency_app/presentation/controllers/user_controller.dart';
import 'package:emergency_app/presentation/widgets/heading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/color_constants.dart';
import '../../controllers/storage_controller.dart';
import '../../provider/screen_provider.dart';
import '../../widgets/overlay_loading.dart';
import '../../widgets/text_button.dart';
import '../../widgets/text_field.dart';
import '../../widgets/toast.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  CompleteProfileScreen({super.key});

  static const routeName = "/Complete-Profile-Screen";

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();
  final StorageController _storageController = GetIt.I<StorageController>();
  final UserController _userController = GetIt.I<UserController>();

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

  @override
  Widget build(
    BuildContext context,
  ) {
    final screenNotifier = ref.watch(screenNotifierProvider.notifier);
    return Scaffold(
      body: OverlayLoadingWidget(
        isLoading: ref.watch(screenNotifierProvider),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HeadingTextWidget(heading: "Complete Profile", fontSize: 20),
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
                    hintText: "Phone Number",
                    controller: _phoneNumberController,
                    isPassword: false,
                    isEnabled: true,
                    validationFunction: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone Number is required';
                      }
                      return null;
                    },
                    textInputType: TextInputType.text,
                    textFieldWidth: MediaQuery.of(context).size.width,
                    onValueChange: (value) {},
                    maxLines: 1,
                    borderCircular: 10,
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
                    toastWidget(message: 'Please Upload Image', isError: true);
                  } else if (_formKey.currentState!.validate()) {
                    final url = await _storageController
                        .handleImageUploading(pickedImage!.path.toString());
                    if (url != null) {
                      await _userController.completeProfile(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          phoneNumber: _phoneNumberController.text,
                          url: url,
                          userName: _userNameController.text);
                    }
                  }

                  screenNotifier.updateLoading(isLoading: false);
                },
                text: 'Save',
                isSelected: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
