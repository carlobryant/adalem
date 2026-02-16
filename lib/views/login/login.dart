import 'package:adalem/components/card_toast.dart';
import 'package:adalem/components/xlbutton.dart';
import 'package:adalem/main_wrapper.dart';
import 'package:adalem/services/auth/google_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

//https://youtu.be/eGFwpDSHXh0?t=1071
//https://youtu.be/D5V3tknJ0NQ?list=LL&t=560
//https://youtu.be/0RWLaJxW7Oc?list=LL&t=2165

class Login extends StatefulWidget {
  final void Function()? onTap;

  const Login({
    super.key,
    required this.onTap
    });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GoogleSignInService _authService = GoogleSignInService();
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final result = await _authService.signInWithGoogle();
      if (!mounted) return;

      if (result != null) {
        ToastCard.success(
          context, "Hello ${result.user?.displayName ?? "User"}!",
          description: result.user?.email ?? "Signed in with Google",
          icon: CircleAvatar(
            radius: 25, 
            backgroundImage: NetworkImage(result.user?.photoURL ?? ""),
            backgroundColor: Colors.grey.shade600, 
            ),
        );

        //await Future.delayed(const Duration(milliseconds: 500));

        if(!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainWrapper()),
          (route) => false, // REMOVE ALL PREVIOUS ROUTES
        );
      } else {
        ToastCard.error(
          context, "Sign In Cancelled",
          description: "Sign in process did not complete.",
        );
      }
    } catch(e) {
      if (!mounted) return;

     /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
      print('Sign In Error $e');*/
      ToastCard.error(
          context, "Sign In Canceled",
          description: "Process did not complete.",
        );

    } finally {
      if (mounted) setState(() =>_isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image(
                image: AssetImage("assets/img_adalem.png"),
                width: 200,
                color: Theme.of(context).colorScheme.primary,
              ),
          
              const SizedBox(height: 25),
          
              Text(
                "A D A L E M",
                style: TextStyle(fontSize: 20),
              ),
          
              const SizedBox(height: 100),
          
              XLButton(
                onTap: _isLoading ? null : _handleGoogleSignIn,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "Sign in with ",
                        style: TextStyle(
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
                )
              ),

              const SizedBox(height: 5),

              Text(
                "Sign in or create a new account",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            
            

            ],
          
          ),
        ),
        ),
    );
  }
}

