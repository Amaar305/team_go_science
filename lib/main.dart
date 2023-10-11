import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controller/auth_controller.dart';
import 'home_binding.dart';
import 'view/pages/user/user_page.dart';
import 'view/screen/add_category_screen.dart';
import 'view/screen/create_post_screen.dart';
import 'view/screen/go_science_users.dart';
import 'view/screen/login_screen.dart';
import 'view/screen/signup_screen.dart';
import 'view/splash/splash_screen.dart';
import 'view/themes/light_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  try {
    await Firebase.initializeApp().then(
      (value) => Get.put(AuthController()),
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Go Science',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      initialBinding: HomeBinding(),
      initialRoute: SplashScreen.routeName,
      getPages: [
        GetPage(
          name: SplashScreen.routeName,
          page: () => const SplashScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: UserPage.routeName,
          page: () => UserPage(),
          transition: Transition.zoom,
        ),
        GetPage(
          name: CreateArticleScreen.routeName,
          page: () => CreateArticleScreen(),
          transition: Transition.circularReveal,
        ),
        GetPage(
          name: LoginScreen.routeName,
          page: () => const LoginScreen(),
          transition: Transition.circularReveal,
        ),
        GetPage(
          name: SignUpScreen.routeName,
          page: () => const SignUpScreen(),
          transition: Transition.zoom,
        ),
        GetPage(
          name: AddCategoryScreen.routeName,
          page: () => AddCategoryScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: GoScienceUsersScreen.routeName,
          page: () => GoScienceUsersScreen(),
          transition: Transition.downToUp,
        ),
      ],
    );
  }
}
