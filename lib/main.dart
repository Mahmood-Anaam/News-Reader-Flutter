import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'utils/app_theme.dart';
import 'models/news_controller.dart';
import 'views/auth_screen.dart';
import 'views/home_page.dart';


main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        late Widget screen;
        if (snapshot.hasData) {
          screen = const HomePage();
        } else {
          screen = const AuthScreen();
        }

        return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (ctx) {
                EverythingNewsController everythingNewsController =
                EverythingNewsController();
                everythingNewsController.init();
                return everythingNewsController;
              }),
              ChangeNotifierProvider(create: (ctx) {
                CategoryNewsController categoryNewsController =
                CategoryNewsController();
                return categoryNewsController;
              }),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: Themes.appTheme,
              title: 'News Reader',
              home: screen,
            ));
      },
    );
  }
}
