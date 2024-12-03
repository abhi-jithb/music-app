import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/playlist_provider.dart';
import 'home_page.dart';
import 'profile_page.dart';
// import 'settings_page.dart';

void main() {
  runApp(MusicApp());
}

class MusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlaylistProvider(),
      child: MaterialApp(
        title: 'Music App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
        routes: {
          '/profile': (context) => ProfilePage(),
          // '/settings': (context) => SettingsPage(), // Ensure you have a SettingsPage
        },
      ),
    );
  }
}
