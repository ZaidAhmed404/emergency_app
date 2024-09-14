import 'package:emergency_app/presentation/screens/contacts/widgets/requests.dart';
import 'package:emergency_app/presentation/screens/search_contacts/search_contacts.dart';
import 'package:emergency_app/presentation/widgets/contacts_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart';
import '../../provider/screen_provider.dart';
import '../../widgets/heading_text.dart';
import '../../widgets/icon_button.dart';
import '../../widgets/overlay_loading.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: OverlayLoadingWidget(
        isLoading: ref.watch(screenNotifierProvider),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HeadingTextWidget(
                      heading: "Contacts",
                      fontSize: 25,
                    ),
                    IconButtonWidget(
                      icon: Icons.add,
                      onPressedFunction: () {
                        navigatorKey.currentState
                            ?.pushNamed(SearchContactsScreen.routeName);
                      },
                      iconSize: 20,
                      isFilled: true,
                    ),
                  ],
                ),
                Contacts(),
                const SizedBox(
                  height: 20,
                ),
                HeadingTextWidget(
                  heading: "Requests",
                  fontSize: 25,
                ),
                Requests()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
