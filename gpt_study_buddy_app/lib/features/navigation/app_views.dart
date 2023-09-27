class AppViews {
  static const String signup = "/auth/signup";
  static const String login = "/auth/login";
  static const String forgotpassword = "/auth/forgotpassword";
  static const String home = "/home";
  static const String createBot = "/home/createbot";
  static const String chatDetails = "/home/chatdetails";
  static const String createNotes = "/home/createnotes";

  static String resolveSubRoute(String subRoute, String parentRoute) {
    return subRoute.replaceAll(parentRoute, "").replaceAll("/", "");
  }
}
