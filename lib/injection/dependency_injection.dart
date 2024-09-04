import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../data/repositories/auth_repository_impl.dart';
import '../presentation/controllers/auth_controller.dart';

final GetIt getIt = GetIt.instance;

void setupDependencyInjection() {
  // Register FirebaseAuth instance
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Register AuthRepositoryImpl instance
  getIt.registerLazySingleton<AuthRepositoryImpl>(
      () => AuthRepositoryImpl(getIt<FirebaseAuth>()));

  // Register AuthController instance
  getIt.registerFactory<AuthController>(
      () => AuthController(authRepository: getIt<AuthRepositoryImpl>()));
}
