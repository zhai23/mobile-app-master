import 'package:cobble/ui/theme/cobble_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CobbleTheme {
  static appTheme(Brightness? brightness) {
    final scheme = CobbleSchemeData.fromBrightness(brightness);
    final invertedScheme = scheme.invert();

    /// Some colors in bright theme are actually dark and vise versa. That's why
    /// I have to manually create both version, I can't simply copy from [scheme].
    /// For example primary color in dark theme is considered light and expects
    /// dark text even though text in dark theme should be light.
    final materialScheme = brightness == Brightness.dark
        ? ColorScheme(
            primary: scheme.primary,
            //primaryVariant: scheme.primary,
            secondary: scheme.primary,
            //secondaryVariant: scheme.primary,
            surface: scheme.surface,
            background: scheme.background,
            error: scheme.danger,
            onPrimary: invertedScheme.text,
            onSecondary: invertedScheme.text,
            onSurface: scheme.text,
            onBackground: scheme.text,
            onError: scheme.text,
            brightness: brightness!,
          )
        : ColorScheme(
            primary: scheme.primary,
            //primaryVariant: scheme.primary,
            secondary: scheme.primary,
            //secondaryVariant: scheme.primary,
            surface: scheme.surface,
            background: scheme.background,
            error: scheme.danger,
            onPrimary: invertedScheme.text,
            onSecondary: invertedScheme.text,
            onSurface: scheme.text,
            onBackground: scheme.text,
            onError: scheme.text,
            brightness: brightness!,
          );

    /// This is entire typography of app, as determined by designer. You should
    /// try to use these presets and modify them with `.copyWith` instead of
    /// creating your own
    final textTheme = TextTheme(
      headlineMedium: TextStyle(
        color: materialScheme.onSurface,
        fontSize: 16,
        height: 1.17,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        color: materialScheme.onSurface,
        fontSize: 14,
        height: 1.17,
        fontWeight: FontWeight.w400,
      ),
      headlineLarge: TextStyle(
        color: materialScheme.onSurface,
        fontSize: 24,
        height: 1.17,
        fontWeight: FontWeight.w500,
      )
    );

    final buttonTheme = ButtonStyle(
      minimumSize: MaterialStateProperty.all(Size(32, 32)),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: MaterialStateProperty.all(
        EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 8,
        ),
      ),
      textStyle: WidgetStateProperty.all(TextStyle(
        color: materialScheme.primary,
        fontSize: 14,
        height: 1.17,
        fontWeight: FontWeight.w500,
      )),
      foregroundColor: simpleMaterialStateProperty(
        materialScheme.primary,
        materialScheme.onSurface.withOpacity(0.12),
      ),
    );

    final invertedBrightness = brightness == Brightness.dark ? Brightness.light : Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: materialScheme.surface,
        statusBarIconBrightness: invertedBrightness,
        statusBarBrightness: invertedBrightness,
      ),
    );

    return ThemeData(
      brightness: brightness,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: materialScheme.primary,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: materialScheme.primary,
        foregroundColor: materialScheme.onPrimary,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: materialScheme.primary,
        textTheme: ButtonTextTheme.primary,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: buttonTheme.copyWith(
          side: simpleMaterialStateProperty(
            BorderSide(color: materialScheme.primary),
            BorderSide(color: materialScheme.onSurface.withOpacity(0.12)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: buttonTheme,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        color: materialScheme.surface,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: materialScheme.primary,
          size: 25,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: materialScheme.surface,
      ),
      iconTheme: IconThemeData(
        color: materialScheme.primary,
        size: 25,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: scheme.divider,
          ),
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelStyle: textTheme.bodyMedium!.copyWith(
          fontSize: 16,
        ),
        labelColor: scheme.text,
        unselectedLabelStyle: textTheme.bodyMedium!.copyWith(
          fontSize: 16,
        ),
        labelPadding: const EdgeInsets.only(top: 5, bottom: 4),
        unselectedLabelColor: scheme.muted,
        // TODO: Indicator should be rounded and not straight, implement that later
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 4.0,
            color: scheme.primary,
          ),
        ),
      ), checkboxTheme: CheckboxThemeData(
 fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return materialScheme.primary; }
 return null;
 }),
 ), radioTheme: RadioThemeData(
 fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return materialScheme.primary; }
 return null;
 }),
 ), switchTheme: SwitchThemeData(
 thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return materialScheme.primary; }
 return null;
 }),
 trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return materialScheme.primary; }
 return null;
 }),
 ), colorScheme: materialScheme.copyWith(background: materialScheme.background).copyWith(secondary: materialScheme.secondary),
    );
  }
}

MaterialStateProperty<T?> simpleMaterialStateProperty<T>(
  T normal, [
  T? disabled,
  T? error,
]) =>
    MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) {
        assert(disabled != null, 'Provide disabled state!');
        return disabled;
      }
      if (states.contains(MaterialState.error)) {
        assert(error != null, 'Provide error state!');
        return error;
      }
      return normal;
    });
