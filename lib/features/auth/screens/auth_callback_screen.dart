import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthCallbackScreen extends StatefulWidget {
  const AuthCallbackScreen({super.key});

  @override
  State<AuthCallbackScreen> createState() => _AuthCallbackScreenState();
}

class _AuthCallbackScreenState extends State<AuthCallbackScreen> {
  @override
  void initState() {
    super.initState();
    _handleCallback();
  }

  Future<void> _handleCallback() async {
    try {
      // Give Supabase a moment to process the token from the URL
      await Future.delayed(const Duration(milliseconds: 500));
      await Supabase.instance.client.auth.refreshSession();

      final user = Supabase.instance.client.auth.currentUser;

      if (!mounted) return;

      if (user?.emailConfirmedAt != null) {
        // Email confirmed — go to next onboarding step
        context.go('/onboarding/personal-info');
      } else {
        // Something went wrong — go back to verify screen
        context.go('/verify-email');
      }
    } catch (e) {
      if (mounted) context.go('/verify-email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Color(0xFF0068F5)),
            const SizedBox(height: 20),
            Text(
              'Confirming your email...',
              style: GoogleFonts.manrope(
                fontSize: 15,
                color: const Color(0xFF525866),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
