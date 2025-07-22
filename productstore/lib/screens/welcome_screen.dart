import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:productstore/screens/register_screen.dart';
import 'package:productstore/screens/home_screen.dart';
import 'package:productstore/screens/login_screen.dart';
import '../blocs/auth/auth_cubit.dart';
import '../widgets/rounded_button.dart';
import '../widgets/animated_logo.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: Column(
              children: [
                const Expanded(
                  flex: 3,
                  child: Center(
                    child: AnimatedLogo(),
                  ),
                ),
                const Text(
                  'Welcome to Qargo',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Shop everything you love in one place.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                RoundedButton(
                  label: 'Sign In',
                  icon: Icons.login,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                ),
                const SizedBox(height: 16),
                RoundedButton(
                  label: 'Sign Up',
                  icon: Icons.person_add,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                ),
                const SizedBox(height: 16),
                RoundedButton(
                  label: 'Continue as Guest',
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    context.read<AuthCubit>().signInAsGuest();
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) =>  HomeScreen()),
                  );
                  }
                ),
                const Spacer(),
                const Text(
                  '© 2025 Qargo. All rights reserved.',
                  style: TextStyle(fontSize: 12, color: Colors.black38),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
