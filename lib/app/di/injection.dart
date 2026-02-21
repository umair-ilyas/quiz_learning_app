import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/trivia_api_service.dart';
import '../../core/repositories/quiz_repository.dart';
import '../../core/repositories/user_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> setupDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Services
  sl.registerLazySingleton<TriviaApiService>(() => TriviaApiService());

  // Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepository(prefs: sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<QuizRepository>(
    () => QuizRepository(
      apiService: sl<TriviaApiService>(),
      prefs: sl<SharedPreferences>(),
    ),
  );
}
