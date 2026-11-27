import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

/// Название приложения — меняется в одном месте.
const kAppName = 'vue';

// Палитра из дизайна и иконки.
const kInk = Color(0xFF0A0409); // фон тёмной темы
const kCardDark = Color(0xFF2F1A27); // карточки профиля
const kFieldDark = Color(0xFF2A1325); // поля ввода
const kSunsetTop = Color(0xFFE38B4F);
const kSunsetMid = Color(0xFFB2354F);
const kSunsetBottom = Color(0xFF5E1559);

const kSunsetGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [kSunsetTop, kSunsetMid, kSunsetBottom],
);

const kAvatarGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF9B2D52), Color(0xFF5B1B4A)],
);

extension VueTheme on BuildContext {
  ColorScheme get cs => Theme.of(this).colorScheme;
  TextTheme get tt => Theme.of(this).textTheme;
  Color get muted => cs.onSurface.withValues(alpha: 0.6);
  Color get hairline => cs.onSurface.withValues(alpha: 0.18);
}

ThemeData buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: kSunsetMid,
    brightness: brightness,
  ).copyWith(
    surface: dark ? kInk : const Color(0xFFFFFBFB),
    onSurface: dark ? Colors.white : const Color(0xFF1B1017),
    primary: dark ? kSunsetTop : kSunsetMid,
    onPrimary: Colors.white,
    surfaceContainerHigh: dark ? kCardDark : const Color(0xFFF4E9EE),
    surfaceContainerHighest: dark ? kFieldDark : const Color(0xFFEBDDE4),
  );

  final textTheme = GoogleFonts.montserratTextTheme(
    ThemeData(brightness: brightness).textTheme,
  ).apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    textTheme: textTheme,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    // Переходы между экранами как на iPhone (с жестом «назад» свайпом).
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        for (final p in TargetPlatform.values)
          p: const CupertinoPageTransitionsBuilder(),
      },
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: dark ? kCardDark : const Color(0xFFF4E9EE),
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
