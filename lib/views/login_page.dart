
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';


class LoginPage extends StatelessWidget {
  final List<AuthProvider> providers;
  final VoidCallback onSignedIn;

  const LoginPage({super.key, required this.providers, required this.onSignedIn});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: providers,
      actions: [
        AuthStateChangeAction<UserCreated>((context, state) {
          onSignedIn();
        }),
        AuthStateChangeAction<SignedIn>((context, state) {
          onSignedIn();
        }),
      ],
    );
  }
}