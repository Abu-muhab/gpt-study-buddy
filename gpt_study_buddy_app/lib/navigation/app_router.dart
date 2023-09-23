import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import 'package:gpt_study_buddy/auth/providers/auth_service_provider.dart';
import "package:gpt_study_buddy/auth/views/login_view.dart";
import 'package:gpt_study_buddy/auth/views/signup_view.dart';
import "package:gpt_study_buddy/bot/data/bot.dart";
import "package:gpt_study_buddy/bot/views/create_bot_view/create_bot_view.dart";
import "package:gpt_study_buddy/chat/views/chat_detail_view.dart";
import "package:gpt_study_buddy/chat/views/chats_view.dart";
import "package:gpt_study_buddy/injection_container.dart";
import "package:gpt_study_buddy/navigation/app_views.dart";

final GoRouter appRouter = GoRouter(
  refreshListenable: sl<AuthServiceProvider>().isLoggedInNotifier,
  initialLocation: AppViews.login,
  redirect: (context, state) {
    bool isAuthRoute = state.location.contains("/auth");
    bool isLoggedIn = sl<AuthServiceProvider>().isLoggedIn;

    if (!isLoggedIn && !isAuthRoute) {
      return AppViews.login;
    }

    if (isLoggedIn && isAuthRoute) {
      return AppViews.chats;
    }

    return null;
  },
  routes: <GoRoute>[
    GoRoute(
        path: AppViews.chats,
        builder: (BuildContext context, GoRouterState state) =>
            const ChatsView(),
        routes: [
          GoRoute(
            path: AppViews.resolveSubRoute(AppViews.createBot, AppViews.chats),
            builder: (BuildContext context, GoRouterState state) =>
                const CreateBotView(),
          ),
          GoRoute(
            path:
                AppViews.resolveSubRoute(AppViews.chatDetails, AppViews.chats),
            builder: (BuildContext context, GoRouterState state) {
              final Bot bot = (state.extra! as Map<String, dynamic>)['bot'];
              return ChatDetailView(bot: bot);
            },
          ),
        ]),
    GoRoute(
      path: AppViews.signup,
      builder: (BuildContext context, GoRouterState state) => SignupView(),
    ),
    GoRoute(
      path: AppViews.login,
      builder: (BuildContext context, GoRouterState state) => LoginView(),
    ),
  ],
);
