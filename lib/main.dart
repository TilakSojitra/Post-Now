import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:post_now/providers/user_provider.dart';
import 'package:post_now/responsive/mobilescreen_layout.dart';
import 'package:post_now/responsive/responsive_layout_screen.dart';
import 'package:post_now/responsive/webscreen_layout.dart';
import 'package:post_now/screens/login_screen.dart';
import 'package:post_now/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAG1V6VkEZ9Mo-KlRdpNifm-ylWucCeGPg",
            appId: "1:134426906874:web:749c657ea797f18b717943",
            messagingSenderId: "134426906874",
            projectId: "post-now-instagram",
            storageBucket: "post-now-instagram.appspot.com"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Post Now ✔️',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: SplashScreen(
          seconds: 6,
          navigateAfterSeconds: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                    webScreenLayout: WebScreenLayout(),
                    mobileScreenLayout: MobileScreenLayout(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator (
                    color: primaryColor,
                  ),
                );
              }
              return const LoginScreen();
              // home: LoginScreen(),
              // home: SignupScreen(),
            },
          ),
          gradientBackground: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black,Colors.lightBlue],
            stops: [
              0.8,
              0.9
            ]
          ),
          title: const Text(
            'Engage, Rather than sell...',
            style: TextStyle(
              fontFamily:'FuzzyBubbles',
              color: secondaryColor,
              fontWeight: FontWeight.w400,
            ),
            textScaleFactor: 1.5,
          ),
          backgroundColor: mobileBackgroundColor,
          image: Image.asset('assets/logo home.jpg'),
          loadingText: const Text(''),
          photoSize: 150.0,
          loaderColor: primaryColor,
        ),
      ),
    );
  }
}