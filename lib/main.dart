import 'package:audiometer/provider/firebase_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:audiometer/provider/storage_provider.dart';
import 'package:audiometer/provider/theme_provider.dart';
import 'package:audiometer/provider/realtime_monitoring_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'screens/Analysis/analysis.dart';
import 'screens/Helps&Tutorials/help_tutorials.dart';
import 'screens/Login/login.dart';
import 'screens/Real-Time-monitoring/real_time_monitoring.dart';
import 'screens/Reports/reports.dart';
import 'screens/Saved/saved_data.dart';
import 'screens/dashboard.dart';
import 'screens/settings/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeProvider().loadTheme();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => RealTimeMonitoringProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => StorageProvider()),
        ChangeNotifierProvider(create: (context) => FirebaseProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _checkAuthStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data ?? false) {
            return const DashboardPage();
          } else {
            return LoginPage();
          }
        },
      ),
      routes: {
        "/realTimeMonitoring": (context) => const RealTimeMonitoringScreen(),
        "/audioAnalysis": (context) => const AudioAnalysisScreen(),
        "/savedData": (context) => const SavedDataScreen(),
        "/reports": (context) => const ReportsScreen(),
        "/settings": (context) => const SettingsScreen(),
        "/help": (context) => const HelpAndTutorialsScreen(),
      },
      theme: themeProvider.themeData,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }

  Future<bool> _checkAuthStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('auth_token');

    if (authToken!.isNotEmpty) {
      return true;
    }

    return false;
  }
}
