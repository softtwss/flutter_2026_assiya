import 'package:flutter/material.dart';

import 'models/event.dart';
import 'routes.dart';
import 'screens/detail_screen.dart';
import 'screens/form_screen.dart';
import 'shell.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // R11: ThemeMode lives above MaterialApp.
  ThemeMode _themeMode = ThemeMode.system;

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  // R22: Both themes use ColorScheme.fromSeed.
  ThemeData _theme(Brightness brightness) => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const HSLColor.fromAHSL(1, 145, 0.28, 0.30).toColor(),
          brightness: brightness,
        ),
      );

  // R25: Detail and form use typed route arguments.
  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    if (settings.name == Routes.detail && args is DetailArgs) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => DetailScreen(args: args),
      );
    }

    if (settings.name == Routes.form && args is FormArgs) {
      return MaterialPageRoute<Event>(
        settings: settings,
        builder: (_) => FormScreen(event: args.event),
      );
    }

    return null;
  }

  Route<dynamic> _onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('Page not found'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VibeEvent',
      debugShowCheckedModeBanner: false,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      themeMode: _themeMode,
      initialRoute: Routes.shell,
      routes: {
        Routes.shell: (_) => Shell(
              themeMode: _themeMode,
              onThemeMode: _setThemeMode,
            ),
      },
      onGenerateRoute: _onGenerateRoute,
      onUnknownRoute: _onUnknownRoute,
    );
  }
}
