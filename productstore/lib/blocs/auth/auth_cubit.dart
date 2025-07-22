import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthCubit() : super(AuthState.initial()) {
    checkAuthStatus();
  }

  void updateEmail(String email) {
    final isValid = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
    emit(state.copyWith(email: email, isEmailValid: isValid));
  }

  void updatePassword(String password) {
    final isValid = password.length >= 6;
    emit(state.copyWith(password: password, isPasswordValid: isValid));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void clearError() {
    emit(state.copyWith(errorMessage: ''));
  }

  Future<void> signIn() async {
    emit(state.copyWith(isLoading: true, errorMessage: '', isGuest: false));
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      await _saveUserId(credential.user!.uid);
      emit(state.copyWith(isLoading: false, isAuthenticated: true, userId: credential.user!.uid));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: _firebaseErrorMessage(e)));
    } catch (_) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Unexpected error occurred.'));
    }
  }

  Future<void> register() async {
    emit(state.copyWith(isLoading: true, errorMessage: '', isGuest: false));
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      await _saveUserId(credential.user!.uid);
      emit(state.copyWith(isLoading: false, isAuthenticated: true, userId: credential.user!.uid));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: _firebaseErrorMessage(e)));
    } catch (_) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Unexpected error occurred.'));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    emit(AuthState.initial());
  }

  void signInAsGuest() {
    emit(state.copyWith(isGuest: true, isAuthenticated: false));
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('user_id');
    final firebaseUser = _auth.currentUser;

    if (uid != null && firebaseUser != null) {
      emit(state.copyWith(userId: uid, isAuthenticated: true));
    } else {
      emit(state.copyWith(userId: null, isAuthenticated: false));
    }
  }

  String _firebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'Email is already in use.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      default:
        return e.message ?? 'Authentication error occurred.';
    }
  }

  Future<void> _saveUserId(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', uid);
  }
}
