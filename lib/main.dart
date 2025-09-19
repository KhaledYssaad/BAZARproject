import 'package:app/forgotpass/new_password.dart';
import 'package:app/forgotpass/reset_password.dart';
import 'package:app/home/cartscreen/cart_screen.dart';
import 'package:app/home/categoryscreen/category.dart';
import 'package:app/home/home.dart';
import 'package:app/home/categoryscreen/search_screen.dart';
import 'package:app/home/homescreen/search_author_screen.dart';
import 'package:app/home/homescreen/see_all_authors.dart';
import 'package:app/login&singup/congrats.dart';
import 'package:app/forgotpass/forgot_page.dart';
import 'package:app/login&singup/login.dart';
import 'package:app/login&singup/signup.dart';
import 'package:app/login&singup/verfication_email.dart';
import 'package:app/home/profilescreen/adress_screen.dart';
import 'package:app/home/profilescreen/favorite_screen.dart';
import 'package:app/home/profilescreen/help_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/radio_provider.dart';
import 'package:app/auth/auth_gate.dart';
import 'package:app/home/profilescreen/account_screen.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";

// import 'package:timezone/standalone.dart';
// import 'package:timezone/timezone.dart';
// import 'package:timezone/data/latest.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
void main() async {
  await Supabase.initialize(
    anonKey: dotenv.env["SUPABASE_KEY"]!,
    url: "https://jclpqcrxasheoidmdpkz.supabase.co",
  );
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RadioProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    // initializeTimeZone();
    // setLocalLocation(getLocation("Africa/Algiers"));
    const androidSettings =
        AndroidInitializationSettings("@mipmap/launcher_icon");
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await notificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      home: const AuthGate(),
      routes: {
        "/login": (context) => const Login(),
        "/login/signup": (context) => const Signup(),
        "/login/forgotpassword": (context) => const ForgotPage(),
        "/login/forgotpassword/reset": (context) => const ResetPassword(),
        "/login/forgotpassword/newpassword": (context) => const NewPassword(),
        "/login/forgotpassword/congrats": (context) => const Congrats(
            title: "Password Changed!",
            desc:
                "Password changed successfully, you can login again with a new password"),
        "/login/signup/verification": (context) => const VerificationEmail(),
        "/login/signup/verification/congrats": (context) => const Congrats(
            title: "Congratulation!",
            desc:
                "Your account is complete, please enjoy the best menu from us."),
        "/home": (context) => const Home(),
        "/home/seeauthors": (context) => const SeeAllAuthors(),
        "/author/searchauthors": (context) => const SearchAuthorScreen(),
        "/category": (context) => const CategoryPage(),
        "/category/search": (context) => const SearchScreen(),
        '/profile/account': (context) => const AccountScreen(),
        '/profile/address': (context) => AddressScreen(),
        '/profile/favorites': (context) => const FavoriteScreen(),
        '/profile/cart': (context) => const CartScreen(),
        '/profile/help': (context) => const HelpCenter(),
      },
    );
  }
}
