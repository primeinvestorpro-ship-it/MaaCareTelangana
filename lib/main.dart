import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/state/app_state.dart';
import 'app/theme.dart';
import 'app/localization.dart';
import 'features/auth/auth_screen.dart';
import 'features/dashboard/main_navigation_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MaaCareApp(),
    ),
  );
}

class MaaCareApp extends StatelessWidget {
  const MaaCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return MaterialApp(
      title: 'MaaCare Telangana',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      locale: appState.locale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('te', 'IN'),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: appState.isLoggedIn
          ? const MainNavigationShell()
          : const AuthScreen(),
    );
  }
}
