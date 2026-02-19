import 'package:adalem/components/card_toast.dart';
import 'package:adalem/components/button_xl.dart';
import 'package:adalem/features/auth/data/repo_impl.dart';
import 'package:adalem/features/auth/data/google_datasource.dart';
import 'package:adalem/features/auth/domain/uc_googlesignin.dart';
import 'package:adalem/features/auth/presentation/vm_login.dart';
import 'package:adalem/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final LoginViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel(
      signInWithGoogle: SignInWithGoogle(
        AuthRepositoryImpl(
          dataSource: AuthRemoteDataSourceImpl(),
        ),
      ),
    );
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    final result = _viewModel.result;
    if (result == null) return;

    if (result.success && result.user != null) {
      final user = result.user!;
      ToastCard.success(
        context,
        "Hello ${user.name.isNotEmpty ? user.name : 'User'}!",
        description: user.email,
        icon: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(user.photoURL),
          backgroundColor: Colors.grey.shade600,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainWrapper()),
        (route) => false,
      );
    } else {
      bool err = result.errorMessage?.toLowerCase().contains('cancel') ?? false;
      ToastCard.error(
        context,
        err ? "Authentication Cancelled" : "Authentication Failed",
        description: err ? "Authentication was interrupted." : "Please check your connection or try again later.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage("assets/img_adalem.png"),
                    width: 200,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "A D A L E M",
                    style: TextStyle(fontSize: 20),
                  ),

                  const SizedBox(height: 100),

                  XLButton(
                    onTap: _viewModel.isLoading
                        ? null
                        : _viewModel.handleGoogleSignIn,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            "Continue with ",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Flexible(
                          child: SvgPicture.asset(
                            "assets/google.svg",
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.inverseSurface,
                              BlendMode.srcIn,
                            ),
                            height: 28,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Sign in or create a new account",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}