import 'package:adalem/core/components/animation_loader.dart';
import 'package:adalem/features/auth/domain/auth_user.dart';
import 'package:adalem/features/auth/domain/uc_getauthstate.dart';
import 'package:adalem/features/auth/presentation/view_login.dart';
import 'package:adalem/shell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final getAuthState = context.read<GetAuthState>();

    return StreamBuilder<AuthUser?>(
      stream: getAuthState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: LoaderAnimation(),
          );
        }

        if(snapshot.hasData) {
          return const Shell();
        }

        return const LoginView();
      }
    );
  }
}