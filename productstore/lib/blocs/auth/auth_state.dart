import 'package:flutter/foundation.dart';

@immutable
class AuthState {
  final String email;
  final String password;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isPasswordVisible;
  final bool isLoading;
  final bool isAuthenticated;
  final bool isGuest;
  final String? userId;
  final String errorMessage;

  const AuthState({
    required this.email,
    required this.password,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isPasswordVisible,
    required this.isLoading,
    required this.isAuthenticated,
    required this.isGuest,
    required this.userId,
    required this.errorMessage,
  });

  factory AuthState.initial() {
    return const AuthState(
      email: '',
      password: '',
      isEmailValid: false,
      isPasswordValid: false,
      isPasswordVisible: false,
      isLoading: false,
      isAuthenticated: false,
      isGuest: false,
      userId: null,
      errorMessage: '',
    );
  }

  AuthState copyWith({
    String? email,
    String? password,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isPasswordVisible,
    bool? isLoading,
    bool? isAuthenticated,
    bool? isGuest,
    String? userId,
    String? errorMessage,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isGuest: isGuest ?? this.isGuest,
      userId: userId ?? this.userId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}