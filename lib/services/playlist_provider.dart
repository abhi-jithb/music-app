// lib/services/playlist_provider.dart
import 'package:flutter/material.dart';

class Playlist {
  final String name;
  List<String> musicFiles;

  Playlist(this.name) : musicFiles = [];
}

class PlaylistProvider with ChangeNotifier {
  List<Playlist> _playlists = [];

  List<Playlist> get playlists => _playlists;

  void addPlaylist(String name) {
    _playlists.add(Playlist(name));
    notifyListeners();
  }

  void addMusicToPlaylist(String playlistName, String musicFile) {
    final playlist = _playlists.firstWhere((p) => p.name == playlistName);
    playlist.musicFiles.add(musicFile);
    notifyListeners();
  }
}
