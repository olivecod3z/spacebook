import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacebook/shared/navigation/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dwpfctewgvhsjazmvwbn.supabase.co',
    anonKey: 'sb_publishable_WhZHY2-d0YpsrnH4ASJQuQ_1M7rSL1d',
  );
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
