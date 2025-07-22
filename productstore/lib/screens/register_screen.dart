import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_cubit.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_link_row.dart';
import '../widgets/auth_text_field.dart';
import 'home_screen.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
        // Show error dialog if errorMessage is not empty
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AuthHeader(
                      title: "Create Account",
                      subtitle: "Fill the form to register",
                    ),
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
                        onPressed:
                        context.read<AuthCubit>().togglePasswordVisibility,
                      ),
                    ),


                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: context.read<AuthCubit>().register,
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
                  :  Text("Register", style: TextStyle(color: state.errorMessage.isNotEmpty? Colors.red:Colors.white)),
                    ),

                    const SizedBox(height: 16),
                    AuthLinkRow(
                      text: "Already have an account? ",
                      linkText: "Login",
                      onTap: () => Navigator.pushNamed(context, '/login'),
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
