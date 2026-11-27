import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'screens/flight_screen.dart';
import 'screens/home_shell.dart';
import 'screens/onboarding_screen.dart';
import 'state/app_state.dart';
import 'state/search_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => SearchState()),
      ],
      child: const VueApp(),
    ),
  );
}

class VueApp extends StatelessWidget {
  const VueApp({super.key});

  @override
  Widget build(BuildContext context) {
    final stage = context.select<AppState, AppStage>((s) => s.stage);

    return MaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: ThemeMode.system, // тема телефона пользователя
      builder: (context, child) {
        final dark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          child: child!,
        );
      },
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 700),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: KeyedSubtree(
          key: ValueKey(stage),
          child: switch (stage) {
            AppStage.onboarding => const OnboardingScreen(),
            AppStage.flying => const FlightScreen(),
            AppStage.home => const HomeShell(),
          },
        ),
      ),
    );
  }
}
