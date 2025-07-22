import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_cubit.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_action_button.dart';
import '../widgets/auth_link_row.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
                  (route) => false, // remove all previous routes
            );
          });


        }
        if (state.errorMessage.isNotEmpty) {

          Future.delayed(Duration.zero, () {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              title: 'Registration Error',
              desc: state.errorMessage,
              btnOkOnPress: () {},
            ).show();
          });
          context.read<AuthCubit>().clearError();
        }
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AuthHeader(title: "Welcome Back", subtitle: "Login to your account"),
                    const SizedBox(height: 32),
                    AuthTextField(
                      label: "Email",
                      icon: Icons.email,
                      value: state.email,
                      isValid: state.isEmailValid,
                      onChanged: context.read<AuthCubit>().updateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      label: "Password",
                      icon: Icons.lock,
                      value: state.password,
                      isValid: state.isPasswordValid,
                      obscureText: !state.isPasswordVisible,
                      onChanged: context.read<AuthCubit>().updatePassword,
                      suffixIcon: IconButton(
                        icon: Icon(state.isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: context.read<AuthCubit>().togglePasswordVisibility,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (state.errorMessage.isNotEmpty)
                      Text(state.errorMessage, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: context.read<AuthCubit>().signIn,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        side:  BorderSide(color: state.errorMessage.isNotEmpty? Colors.red:Colors.white),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: state.isLoading? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          :  Text( "Login", style: TextStyle(color: state.errorMessage.isNotEmpty? Colors.red:Colors.white)),
                    ),


                    const SizedBox(height: 24),
                    AuthLinkRow(
                      text: "Don't have an account?",
                      linkText: "Register",
                      onTap: () => Navigator.pushNamed(context, '/register'),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
