import 'package:get_it/get_it.dart';
import 'package:gpt_study_buddy/auth/auth_service.dart';
import 'package:gpt_study_buddy/auth/auth_service_provider.dart';
import 'package:gpt_study_buddy/auth/data/auth_token_repo.dart';
import 'package:gpt_study_buddy/common/http_client.dart';

import 'bot/views/create_bot_view/create_bot_viewmodel.dart';

final sl = GetIt.instance;

Future<void> injectDependencies() async {
  //repos
  sl.registerLazySingleton<AppHttpClient>(() => AppHttpClient());
  sl.registerLazySingleton<AuthTokenRepo>(() => AuthTokenRepo());

  //services
  sl.registerLazySingleton<AuthService>(() => AuthService(autTokenRep: sl()));

  //providers
  sl.registerLazySingleton<AuthServiceProvider>(
      () => AuthServiceProvider(authService: sl(), autTokenRep: sl()));
  sl.registerLazySingleton<CreateBotViewmodel>(() => CreateBotViewmodel());
}
