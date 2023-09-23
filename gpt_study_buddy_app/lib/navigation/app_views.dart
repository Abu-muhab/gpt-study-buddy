class AppViews {
  static const String signup = "/auth/signup";
  static const String login = "/auth/login";
  static const String forgotpassword = "/auth/forgotpassword";
  static const String chats = "/chats";
  static const String createBot = "/chats/createbot";
  static const String chatDetails = "/chats/chatdetails";

  static String resolveSubRoute(String subRoute, String parentRoute) {
    return subRoute.replaceAll(parentRoute, "").replaceAll("/", "");
  }
}
