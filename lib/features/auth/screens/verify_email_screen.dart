import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  final String password;
  final VoidCallback onConfirmed;

  const VerifyEmailScreen({
    super.key,
    required this.email,
    required this.password,
    required this.onConfirmed,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _resending = false;
  bool _checking = false;
  int _cooldown = 0;
  Timer? _cooldownTimer;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _pollTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      await _checkConfirmation(silent: true);
    });
  }

  Future<void> _checkConfirmation({bool silent = false}) async {
    if (!silent) setState(() => _checking = true);

    try {
      // Sign in fresh to get latest confirmed state
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: widget.email,
        password: widget.password,
      );

      if (response.user?.emailConfirmedAt != null && mounted) {
        _pollTimer?.cancel();
        widget.onConfirmed();
        return;
      }

      if (!silent && mounted) {
        setState(() => _checking = false);
        _showSnack('Email not confirmed yet. Please check your inbox.');
      }
    } on AuthException catch (e) {
      if (!silent && mounted) {
        setState(() => _checking = false);
        // Email not confirmed shows as auth error
        if (e.message.toLowerCase().contains('email not confirmed')) {
          _showSnack('Email not confirmed yet. Please check your inbox.');
        } else {
          _showSnack('Could not verify. Please try again.');
        }
      }
    } catch (e) {
      if (!silent && mounted) {
        setState(() => _checking = false);
        _showSnack('Could not verify. Please try again.');
      }
    }
  }

  Future<void> _resendEmail() async {
    setState(() => _resending = true);
    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: widget.email,
      );
      _startCooldown();
      _showSnack('Confirmation email resent!');
    } catch (e) {
      _showSnack('Failed to resend. Please try again.');
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  void _startCooldown() {
    setState(() => _cooldown = 60);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_cooldown <= 1) {
        t.cancel();
        if (mounted) setState(() => _cooldown = 0);
      } else {
        if (mounted) setState(() => _cooldown--);
      }
    });
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.6),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 40,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 44),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'SPACEBOOK',
                    style: GoogleFonts.manrope(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0068F5),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4FF),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.mark_email_unread_outlined,
                      size: 36,
                      color: Color(0xFF0068F5),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Check your inbox',
                    style: GoogleFonts.manrope(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF383838),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'We sent a confirmation link to',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: const Color(0xFF525866),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.email,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF383838),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Click the link in the email to confirm your account and continue setting up your space.',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      color: const Color(0xFF868C98),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _checking ? null : () => _checkConfirmation(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0068F5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _checking
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "I've confirmed my email",
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed:
                          (_resending || _cooldown > 0) ? null : _resendEmail,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE2E4E9)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _resending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Color(0xFF0068F5),
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _cooldown > 0
                                  ? 'Resend in ${_cooldown}s'
                                  : 'Resend confirmation email',
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _cooldown > 0
                                    ? const Color(0xFF868C98)
                                    : const Color(0xFF383838),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Can't find it? Check your spam or junk folder.",
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: const Color(0xFF868C98),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
