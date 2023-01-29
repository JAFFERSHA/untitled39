import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
        debugShowCheckedModeBanner: false,
        title: 'firebase sj',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Define background colors available for this app
  final Map<String, dynamic> _availableBackgroundColors = {
    "pink": Colors.blue,
    "amber": Colors.amber,
    "red": Colors.red,
    "white": Colors.white
  };

  final String _defaultBannerText = "Have a nice day";
  final String _defaultBackgroundColor = "white";

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  Future<void> _initConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(
          seconds: 1), // a fetch will wait up to 10 seconds before timing out
      minimumFetchInterval: const Duration(
          seconds:
          10), // fetch parameters will be cached for a maximum of 1 hour
    ));

    _fetchConfig();
  }

  // Fetching, caching, and activating remote config
  void _fetchConfig() async {
    await _remoteConfig.fetchAndActivate();
  }

  @override
  void initState() {
    _initConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _availableBackgroundColors[
      _remoteConfig.getString('background_color').isNotEmpty
          ? _remoteConfig.getString('background_color')
          : _defaultBackgroundColor],
      appBar: AppBar(
        title: const Text("firebase sj"),
      ),
      body: Center(
        child: Card(
          elevation: 9,
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Text(
              _remoteConfig.getString('banner_text').isNotEmpty
                  ? _remoteConfig.getString('banner_text')
                  : _defaultBannerText,
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ),
      ),
    );
  }
}
