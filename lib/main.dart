import 'package:flutter/material.dart';
import 'utils/sound_service.dart';

import 'views/game_screen.dart';
import 'views/login_screen.dart';
import 'views/splash_screen.dart';

// Set this to false for production mode
const bool isDevelopmentMode = false;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SoundService(); // Initialize the SoundService
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget appBody = Navigator(
      initialRoute: SplashScreen.routeName,
      onGenerateRoute: (settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case SplashScreen.routeName:
            builder = (BuildContext _) => const SplashScreen();
            break;
          case LoginScreen.routeName:
            builder = (BuildContext _) => const LoginScreen();
            break;
          case GameScreen.routeName:
            builder = (BuildContext _) => const GameScreen();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isDevelopmentMode ? DevWrapper(child: appBody) : appBody,
    );
  }
}

class DevWrapper extends StatefulWidget {
  final Widget child;

  const DevWrapper({super.key, required this.child});

  @override
  _DevWrapperState createState() => _DevWrapperState();
}

class _DevWrapperState extends State<DevWrapper> {
  Key _navigatorKey = UniqueKey();

  void _resetToSplash() {
    setState(() {
      _navigatorKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        KeyedSubtree(
          key: _navigatorKey,
          child: widget.child,
        ),
        if (isDevelopmentMode)
          Positioned(
            bottom: 40,
            right: 20,
            child: ElevatedButton(
              onPressed: _resetToSplash,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.5),
                foregroundColor: Colors.white,
              ),
              child: const Text('Reset to Splash'),
            ),
          ),
      ],
    );
  }
}
