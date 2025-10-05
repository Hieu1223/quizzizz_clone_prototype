import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider, EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:provider/provider.dart';
import 'package:quizzizz_clone/firebase_options.dart';
import 'package:quizzizz_clone/view_models/main_page/collection_view_model.dart';
import 'package:quizzizz_clone/views/login_page.dart';
import 'package:quizzizz_clone/views/main_page/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];

    void onSignedIn(BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainPage(),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CollectionsViewModel()..loadCollections())
        // You can add more providers here if needed
      ],
      child: MaterialApp(
        initialRoute:
            FirebaseAuth.instance.currentUser == null ? '/login' : '/main',
        routes: {
          '/login': (context) {
            return LoginPage(
              providers: providers,
              onSignedIn: () => onSignedIn(context),
            );
          },
          '/main': (context) => const MainPage(),
        },
      ),
    );
  }
}
