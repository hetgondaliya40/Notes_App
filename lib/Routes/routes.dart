import 'package:get/get.dart';
import 'package:notes_app/view/screen/home_page/home_page.dart';
import 'package:notes_app/view/screen/login_page/login_page.dart';
import 'package:notes_app/view/screen/signup_page/signup_page.dart';

import '../view/screen/notes_detail_page/notes_detail_page.dart';
import '../view/screen/splash_screen/splash_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const notes = '/notes';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => LoginPage()),
    GetPage(name: signup, page: () => SignupPage()),
    GetPage(name: home, page: () => HomePage()),
    // Here we use the arguments to pass the note
    GetPage(
      name: notes,
      page: () => NotesDetailPage(),
    ),
  ];
}
