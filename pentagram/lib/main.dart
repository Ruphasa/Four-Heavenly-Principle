import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pentagram/pages/login/login_page.dart';
import 'package:pentagram/pages/main_page.dart';
import 'package:pentagram/providers/auth_providers.dart';
import 'package:pentagram/providers/fcm_providers.dart';
import 'package:pentagram/providers/current_user_provider.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pentagram/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pentagram/seeders/seeders.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  // Initialize Firebase with proper error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase already initialized (hot restart case)
    debugPrint('Firebase initialization: $e');
  }
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Jawara Pintar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.background,
          error: AppColors.error,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const AuthChecker(),
    );
  }
}

/// Widget untuk cek status login saat app start
class AuthChecker extends ConsumerStatefulWidget {
  const AuthChecker({super.key});

  @override
  ConsumerState<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends ConsumerState<AuthChecker> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Cek apakah user sudah pernah login
    await ref.read(authControllerProvider.notifier).checkLoginStatus();

    // Inisialisasi FCM dan subscribe ke campaign/topic
    final fcmService = ref.read(fcmServiceProvider);
    await fcmService.initialize();
    await fcmService.subscribeToTopic('pentagramMessageToken');

    // Simpan FCM token ke dokumen users/{userId} untuk user yang sudah login
    try {
      final token = await fcmService.getToken();
      if (token != null && token.isNotEmpty) {
        final userId = await ref.read(currentUserIdProvider.future);
        if (userId != null && userId.isNotEmpty) {
          final fcmNotificationService = ref.read(fcmNotificationServiceProvider);
          await fcmNotificationService.updateUserFCMToken(userId, token);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error updating user FCM token: $e');
      }
    }

    // Tidak perlu navigate, widget akan rebuild otomatis karena state berubah
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final Widget child = authState.isAuthenticated
        ? const MainPage()
        : const LoginPage();

    if (!kDebugMode) return child;

    // In debug mode, overlay a small floating button to run the seeder
    return Stack(
      children: [
        child,
        Positioned(
          right: 16,
          bottom: 16,
          child: _SeedFab(onSeed: _runSeeder),
        ),
      ],
    );
  }

  Future<void> _runSeeder() async {
    try {
      final fs = FirebaseFirestore.instance;
      final seeder = Seeders(fs);
      await seeder.runAll(clearBefore: true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seeding completed.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Seeding failed: $e')),
        );
      }
    }
  }
}

class _SeedFab extends StatelessWidget {
  final Future<void> Function() onSeed;
  const _SeedFab({required this.onSeed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: 'seedFab',
      onPressed: onSeed,
      tooltip: 'Reseed Firestore (clears and seeds)',
      child: const Icon(Icons.dataset),
    );
  }
}
