import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tractalk_flutter/auth/login_screen.dart';
import 'package:tractalk_flutter/auth/otp_screen.dart';
import 'package:tractalk_flutter/auth/user_infomation_screen.dart';
import 'package:tractalk_flutter/constants.dart';

import 'package:tractalk_flutter/main_screen/home_screen.dart';
import 'package:tractalk_flutter/providers/authentication_provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
      ],
      child: MainApp(savedThemeMode: savedThemeMode),
    ),
  );
}

class MainApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MainApp({super.key, required this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      dark: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder:
          (theme, darkTheme) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'TracTalk',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            darkTheme: darkTheme,
            // home: const UserInfomationScreen(),
            initialRoute: Constants.loginScreen,
            routes: {
              Constants.loginScreen: (context) => const LoginScreen(),
              Constants.otpScreen: (context) => const OTPScreen(),
              Constants.userInformationScreen:
                  (context) => const UserInfomationScreen(),
              Constants.homeScreen: (context) => const HomeScreen(),
            },
          ),
    );
  }
}
