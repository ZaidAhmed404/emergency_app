import 'package:emergency_app/data/repositories_impl/chat_repository_impl.dart';
import 'package:emergency_app/data/repositories_impl/contact_repository_impl.dart';
import 'package:emergency_app/domain/services_impl/chat_services_impl.dart';
import 'package:emergency_app/domain/services_impl/notification_services_impl.dart';
import 'package:emergency_app/presentation/controllers/chat_message_controller.dart';
import 'package:emergency_app/presentation/controllers/contacts_controller.dart';
import 'package:emergency_app/presentation/controllers/notification_controller.dart';
import 'package:emergency_app/presentation/controllers/storage_controller.dart';
import 'package:emergency_app/presentation/controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../data/repositories_impl/auth_repository_impl.dart';
import '../data/repositories_impl/storage_repository_impl.dart';
import '../data/repositories_impl/user_repository_impl.dart';
import '../domain/services_impl/email_service_impl.dart';
import '../presentation/controllers/auth_controller.dart';

final GetIt getIt = GetIt.instance;

void setupDependencyInjection() {
  // Register FirebaseAuth instance
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Register AuthRepositoryImpl instance
  getIt.registerLazySingleton<AuthRepositoryImpl>(() => AuthRepositoryImpl(
        firebaseAuth: getIt<FirebaseAuth>(),
      ));

  // Register AuthController instance
  getIt.registerFactory<AuthController>(() => AuthController(
      authRepository: getIt<AuthRepositoryImpl>(),
      userController: getIt<UserController>(),
      emailServices: getIt<EmailServicesImpl>(),
      userRepository: getIt<UserRepositoryImpl>()));

  getIt.registerLazySingleton<StorageRepositoryImpl>(
      () => StorageRepositoryImpl());

  getIt.registerFactory<StorageController>(
      () => StorageController(getIt<StorageRepositoryImpl>()));

  getIt.registerLazySingleton<UserRepositoryImpl>(() => UserRepositoryImpl());
  getIt.registerLazySingleton<EmailServicesImpl>(() => EmailServicesImpl());

  getIt.registerFactory<UserController>(() => UserController(
      storageRepository: getIt<StorageRepositoryImpl>(),
      emailServices: getIt<EmailServicesImpl>(),
      userRepository: getIt<UserRepositoryImpl>()));

  getIt.registerLazySingleton<ContactRepositoryImpl>(
      () => ContactRepositoryImpl());

  getIt.registerFactory<ContactsController>(
      () => ContactsController(getIt<ContactRepositoryImpl>()));

  getIt.registerLazySingleton<ChatServicesImpl>(() => ChatServicesImpl());
  getIt.registerLazySingleton<ChatRepositoryImpl>(() => ChatRepositoryImpl());

  getIt.registerFactory<ChatMessageController>(() => ChatMessageController(
      chatServices: getIt<ChatServicesImpl>(),
      chatRepository: getIt<ChatRepositoryImpl>()));

  getIt.registerLazySingleton<NotificationServicesImpl>(
      () => NotificationServicesImpl());

  getIt.registerFactory<NotificationController>(() => NotificationController(
        getIt<NotificationServicesImpl>(),
      ));
}
