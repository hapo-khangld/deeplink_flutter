import 'package:flutter/material.dart';
import 'dart:async';
import 'package:uni_links3/uni_links.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
    _checkInitialDeepLink();
  }

  // checking deeplink if app run
  void _initDeepLinkListener() {
    _sub = uriLinkStream.listen((Uri? uri) async {
      print("uri: $uri");
      if (uri != null && uri.path == '/home-screen') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (navigatorKey.currentState != null) {
            try {
              navigatorKey.currentState?.push(
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            } catch (e) {
              print('Error navigating to home screen: $e');
            }
          } else {
            print('Navigator is still null');
          }
        });
      }
    }, onError: (err) {
      print('Failed to receive deeplink: $err');
    });
  }

  // checking deeplink after app restart
  Future<void> _checkInitialDeepLink() async {
    try {
      Uri? initialUri = await getInitialUri();
      if (initialUri != null && initialUri.path == '/home-screen') {
        // Nếu có deeplink, điều hướng đến HomeScreen
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (navigatorKey.currentState != null) {
            navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        });
      }
    } catch (e) {
      print('Error getting initial uri: $e');
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DeepLink Demo'),
        ),
        body: const Center(
          child: Text('Waiting for deeplink...'),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: const Center(
        child: Text('You are on the home screen!'),
      ),
    );
  }
}
