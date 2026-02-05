import 'package:adalem/components/xlbutton.dart';
import 'package:adalem/main_wrapper.dart';
import 'package:adalem/services/auth/google_auth.dart';
import 'package:flutter/material.dart';

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
        if(!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainWrapper()),
          (route) => false, // Remove all previous routes
);
      }
    } catch(e) {
      if (!mounted) return;

     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
      print('Sign In Error $e');
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
              /*Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),*/

              Image(
                image: AssetImage('assets/img_adalem.png'),
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
                text: "Login with Google",
                onTap: _isLoading ? null : _handleGoogleSignIn,
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: widget.onTap,
                     child: Text(
                      "Register Here",
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ],
              ),

            ],
          
          ),
        ),
        ),
    );
  }
}

