import 'package:get_it/get_it.dart';
import 'package:gpt_study_buddy/common/http_client.dart';
import 'package:gpt_study_buddy/features/auth/auth_service.dart';
import 'package:gpt_study_buddy/features/auth/data/auth_token_repo.dart';
import 'package:gpt_study_buddy/features/auth/providers/auth_service_provider.dart';
import 'package:gpt_study_buddy/features/bot/data/bot_service.dart';
import 'package:gpt_study_buddy/features/bot/providers/create_bot_viewmodel.dart';
import 'package:gpt_study_buddy/features/calendar/data/event_repo.dart';
import 'package:gpt_study_buddy/features/calendar/viewmodel/calendar_datasource.dart';
import 'package:gpt_study_buddy/features/calendar/viewmodel/calendar_viewmodel.dart';
import 'package:gpt_study_buddy/features/calendar/viewmodel/create_event_viewmodel.dart';
import 'package:gpt_study_buddy/features/chat/data/message_repo.dart';
import 'package:gpt_study_buddy/features/chat/providers/chat_details_viewmodel.dart';
import 'package:gpt_study_buddy/features/chat/providers/chats_provider.dart';
import 'package:gpt_study_buddy/features/notes/data/notes_service.dart';
import 'package:gpt_study_buddy/features/notes/providers/notes_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> injectDependencies() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  //repos
  sl.registerLazySingleton<AuthTokenRepo>(() => AuthTokenRepo());
  sl.registerLazySingleton<AppHttpClient>(
      () => AppHttpClient(authTokenRepo: sl()));
  sl.registerLazySingleton<MessageRepository>(() => MessageRepository(
      sharedPreferences: sharedPreferences, authServiceProvider: sl()));
  sl.registerLazySingleton<EventRepository>(() => EventRepository(
        httpClient: sl(),
      ));

  //services
  sl.registerLazySingleton<AuthService>(
      () => AuthService(autTokenRep: sl(), httpClient: sl()));
  sl.registerLazySingleton<BotService>(() => BotService(httpClient: sl()));
  sl.registerLazySingleton<NotesService>(() => NotesService(httpClient: sl()));

  //providers
  sl.registerLazySingleton<AuthServiceProvider>(
      () => AuthServiceProvider(authService: sl(), autTokenRep: sl()));
  sl.registerLazySingleton<ChatsProvider>(() => ChatsProvider(
      botService: sl(), messageRepository: sl(), authServiceProvider: sl()));
  sl.registerLazySingleton<CreateBotViewmodel>(
      () => CreateBotViewmodel(botService: sl(), chatsProvider: sl()));
  sl.registerLazySingleton<ChatDetailsViewModel>(() =>
      ChatDetailsViewModel(messageRepository: sl(), authServiceProvider: sl()));
  sl.registerLazySingleton<NotesProvider>(
      () => NotesProvider(notesService: sl(), authServiceProvider: sl()));
  sl.registerLazySingleton<EventDataSource>(
      () => EventDataSource(eventRepository: sl()));
  sl.registerLazySingleton<CalendarViewmodel>(
      () => CalendarViewmodel(dataSource: sl()));
  sl.registerLazySingleton<CreateEventViewModel>(() =>
      CreateEventViewModel(eventRepository: sl(), calendarViewmodel: sl()));
}
