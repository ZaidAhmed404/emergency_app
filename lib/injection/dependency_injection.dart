import 'package:emergency_app/data/repositories/storage_repository_impl.dart';
import 'package:emergency_app/data/repositories/user_repository_impl.dart';
import 'package:emergency_app/presentation/controllers/storage_controller.dart';
import 'package:emergency_app/presentation/controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../data/repositories/auth_repository_impl.dart';
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
      userRepository: getIt<UserRepositoryImpl>()));

  getIt.registerLazySingleton<StorageRepositoryImpl>(
      () => StorageRepositoryImpl());

  getIt.registerFactory<StorageController>(
      () => StorageController(getIt<StorageRepositoryImpl>()));

  getIt.registerLazySingleton<UserRepositoryImpl>(() => UserRepositoryImpl());

  getIt.registerFactory<UserController>(() => UserController(
      storageRepository: getIt<StorageRepositoryImpl>(),
      userRepository: getIt<UserRepositoryImpl>()));
}
