import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snakegame/providers/game_provider.dart';
import 'package:snakegame/providers/obscure_text_provider.dart';
import 'package:snakegame/providers/signup_provider.dart';
import 'package:snakegame/screens/menu_screen.dart';
import 'package:snakegame/screens/score_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/game_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // loading env file
  await Supabase.initialize(
    url: dotenv.env['PROJECT_URL']!,
    anonKey: dotenv.env['API_KEY']!,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignupProvider()),
        ChangeNotifierProvider(create: (_) => ObscureTextProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snake Game',
      theme: ThemeData(
        textTheme: GoogleFonts.bricolageGrotesqueTextTheme(
            Theme.of(context).textTheme),
        primarySwatch: Colors.green,
      ),

      /*Based on the user login or signed up state, we'll navigate them to home screen else if not signed up or login, we'll navigate them to the auth screens*/
      /*Adding home with FutureBuilder to check the user session*/
      home: FutureBuilder<Session?>(
        future: Future.value(supabase.auth.currentSession),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final session = snapshot.data;
          if (session != null) {
            return const MenuScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/game': (_) => const GameScreen(),
        '/menu': (_) => const MenuScreen(),
        '/scores': (_) => const ScoreScreen(),
      },
    );
  }
}
