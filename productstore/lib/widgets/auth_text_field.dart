import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final bool isValid;
  final bool obscureText;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  final Widget? suffixIcon;

  const AuthTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.isValid,
    required this.onChanged,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: (!isValid && value.isNotEmpty) ? Colors.red : Colors.black,
        ),
        suffixIcon: suffixIcon,
        errorText:
        (!isValid && value.isNotEmpty) ? "Invalid $label" : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
