import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/sound_service.dart';

import 'views/game_screen.dart';
import 'views/login_screen.dart';
import 'views/splash_screen.dart';

// Set this to false for production mode
const bool isDevelopmentMode = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the SoundService
  await SoundService.initialize();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Enable on back invoked callback
  if (SystemChannels.platform.name == 'android_app_retain') {
    await SystemChannels.platform.invokeMethod<void>(
      'SystemNavigator.setSystemUIOverlayStyle',
      <String, dynamic>{
        'systemNavigationBarColor': Colors.transparent,
        'systemNavigationBarDividerColor': Colors.transparent,
        'systemNavigationBarIconBrightness': Brightness.light,
        'statusBarColor': Colors.transparent,
        'statusBarBrightness': Brightness.light,
        'statusBarIconBrightness': Brightness.dark,
      },
    );
  }

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
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