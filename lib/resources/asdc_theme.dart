import 'package:flutter/material.dart';

/// ширина навигационной панели
const kDrawerWidth = 260.0;

class AsdcTheme {
  /// отступы обычные
  static const md = 24.0;
  static const paddingMd = EdgeInsets.all(md);

  /// тип прокрутки содержимого
  static const scrollPhysics = BouncingScrollPhysics(
    parent: AlwaysScrollableScrollPhysics(),
  );

  /// стиль [FilledButton] для кнопок удаления
  static ButtonStyle dangerButtonStyleOf(BuildContext context) {
    final theme = Theme.of(context);

    return FilledButton.styleFrom(
      foregroundColor: theme.colorScheme.onError,
      backgroundColor: theme.colorScheme.error,
    );
  }

  /// главный цвет в соответствии с Material You
  static const seedColor = Color(0xff007aff);

  /// светлая тема оформления
  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: seedColor,
    fontFamily: 'Golos UI',

    // colorScheme: ColorScheme.fromSeed(seedColor: seedColor),

    /// Define FadeUpwardsPageTransitionsBuilder as the default transition on
    /// iOS also. But again this will break the swipe back gesture on iOS
    /// убирает ненужную тень в macOS между станицами
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    }),
  );

  /// тёмная тема оформления
  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: seedColor,
    fontFamily: 'Golos UI',

    /// Define FadeUpwardsPageTransitionsBuilder as the default transition on
    /// iOS also. But again this will break the swipe back gesture on iOS
    /// убирает ненужную тень в macOS между станицами
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    }),
  );
}

class Breakpoints {
  static const double sm = 576.0;
  static const double md = 768.0;
  static const double lg = 992.0;
  static const double xl = 1200.0;
}

class ElevationShadow {
  static List<BoxShadow> level1 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.30),
      blurRadius: 2.0,
      spreadRadius: 0.0,
      offset: const Offset(0.0, 1.0),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 3.0,
      spreadRadius: 1.0,
      offset: const Offset(0.0, 1.0),
    ),
  ];

  static List<BoxShadow> level2 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.30),
      blurRadius: 2.0,
      spreadRadius: 0.0,
      offset: const Offset(0.0, 1.0),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 6.0,
      spreadRadius: 2.0,
      offset: const Offset(0.0, 2.0),
    ),
  ];

  static List<BoxShadow> level3 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 8.0,
      spreadRadius: 3.0,
      offset: const Offset(0.0, 4.0),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.30),
      blurRadius: 3.0,
      spreadRadius: 0.0,
      offset: const Offset(0.0, 1.0),
    ),
  ];
}
