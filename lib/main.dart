import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacebook/shared/navigation/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dwpfctewgvhsjazmvwbn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR3cGZjdGV3Z3Zoc2phem12d2JuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQzOTQwMzQsImV4cCI6MjA4OTk3MDAzNH0.d_c1FqVGtPBrc49gs8AsnUIyVXm2-G3dBRWF3jt8_Gc',
  );

  // Handle email confirmation token from URL hash
  final uri = Uri.base;
  if (uri.fragment.isNotEmpty && uri.fragment.contains('access_token')) {
    try {
      final params = Uri.splitQueryString(uri.fragment);
      final accessToken = params['access_token'];
      final refreshToken = params['refresh_token'] ?? '';
      if (accessToken != null) {
        await Supabase.instance.client.auth.setSession(accessToken);
      }
    } catch (e) {
      debugPrint('Token processing error: $e');
    }
  }

  runApp(
    const ProviderScope(
      child: SpaceBookApp(),
    ),
  );
}

class SpaceBookApp extends StatelessWidget {
  const SpaceBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpaceBook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0068F5)),
        textTheme: GoogleFonts.manropeTextTheme(),
        useMaterial3: true,
      ),
      initialRoute: AppRouter.onboarding,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
