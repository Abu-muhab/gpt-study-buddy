import 'package:get_it/get_it.dart';
import 'package:gpt_study_buddy/auth/auth_service.dart';
import 'package:gpt_study_buddy/auth/providers/auth_service_provider.dart';
import 'package:gpt_study_buddy/auth/data/auth_token_repo.dart';
import 'package:gpt_study_buddy/bot/bot_service.dart';
import 'package:gpt_study_buddy/chat/providers/chat_details_viewmodel.dart';
import 'package:gpt_study_buddy/chat/providers/chats_provider.dart';
import 'package:gpt_study_buddy/chat/data/message_repo.dart';
import 'package:gpt_study_buddy/common/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bot/providers/create_bot_viewmodel.dart';

final sl = GetIt.instance;

Future<void> injectDependencies() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  //repos
  sl.registerLazySingleton<AuthTokenRepo>(() => AuthTokenRepo());
  sl.registerLazySingleton<AppHttpClient>(
      () => AppHttpClient(authTokenRepo: sl()));
  sl.registerLazySingleton<MessageRepository>(() => MessageRepository(
      sharedPreferences: sharedPreferences, authServiceProvider: sl()));

  //services
  sl.registerLazySingleton<AuthService>(
      () => AuthService(autTokenRep: sl(), httpClient: sl()));
  sl.registerLazySingleton<BotService>(() => BotService(httpClient: sl()));

  //providers
  sl.registerLazySingleton<AuthServiceProvider>(
      () => AuthServiceProvider(authService: sl(), autTokenRep: sl()));
  sl.registerLazySingleton<ChatsProvider>(() => ChatsProvider(
      botService: sl(), messageRepository: sl(), authServiceProvider: sl()));
  sl.registerLazySingleton<CreateBotViewmodel>(
      () => CreateBotViewmodel(botService: sl(), chatsProvider: sl()));
  sl.registerLazySingleton<ChatDetailsViewModel>(() =>
      ChatDetailsViewModel(messageRepository: sl(), authServiceProvider: sl()));
}
