import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:gpt_study_buddy/features/auth/providers/auth_service_provider.dart";
import "package:gpt_study_buddy/features/auth/views/login_view.dart";
import "package:gpt_study_buddy/features/auth/views/signup_view.dart";
import "package:gpt_study_buddy/features/bot/data/bot.dart";
import "package:gpt_study_buddy/features/bot/views/create_bot_view/create_bot_view.dart";
import "package:gpt_study_buddy/features/chat/views/chat_detail_view.dart";
import "package:gpt_study_buddy/features/home.dart";
import "package:gpt_study_buddy/features/navigation/app_views.dart";
import "package:gpt_study_buddy/injection_container.dart";

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
      return AppViews.home;
    }

    return null;
  },
  routes: <GoRoute>[
    GoRoute(
        path: AppViews.home,
        builder: (BuildContext context, GoRouterState state) => const Home(),
        routes: [
          GoRoute(
            path: AppViews.resolveSubRoute(AppViews.createBot, AppViews.home),
            builder: (BuildContext context, GoRouterState state) =>
                const CreateBotView(),
          ),
          GoRoute(
            path: AppViews.resolveSubRoute(AppViews.chatDetails, AppViews.home),
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
