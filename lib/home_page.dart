import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'services/music_service.dart';
import 'services/playlist_provider.dart';
import 'widgets/music_player.dart'; // Import the MusicPlayer widget
import 'alarm_page.dart'; // Import the AlarmPage
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController urlController = TextEditingController();
  final TextEditingController playlistController = TextEditingController();
  List<File> musicFiles = [];

  @override
  void initState() {
    super.initState();
    _loadMusicFiles();
  }

  Future<void> _loadMusicFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync().where((item) => item.path.endsWith('.mp3')).toList();
    setState(() {
      musicFiles = files.cast<File>();
    });
  }

  Future<void> _fetchMusic() async {
    await fetchMusicFromUrl(urlController.text);
    _loadMusicFiles(); // Reload music files after fetching new music
  }

  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.alarm),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AlarmPage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
        title: Text('Music App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Music',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Playlist', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Create Playlist'),
                          content: TextField(
                            controller: playlistController,
                            decoration: InputDecoration(labelText: 'Playlist Name'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                if (playlistController.text.isNotEmpty) {
                                  playlistProvider.addPlaylist(playlistController.text);
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text('Create'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Add Music', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    // Handle add local music
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: 'Enter URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchMusic,
              child: Text('Get Music'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Playlists', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: playlistProvider.playlists.length,
                      itemBuilder: (context, index) {
                        final playlist = playlistProvider.playlists[index];
                        return ListTile(
                          title: Text(playlist.name),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Add Music to Playlist'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Select Music'),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: musicFiles.length,
                                          itemBuilder: (context, fileIndex) {
                                            final file = musicFiles[fileIndex];
                                            return ListTile(
                                              title: Text(file.path.split('/').last),
                                              onTap: () {
                                                playlistProvider.addMusicToPlaylist(playlist.name, file.path);
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text('Music Files', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: musicFiles.length,
                itemBuilder: (context, index) {
                  final file = musicFiles[index];
                  return ListTile(
                    title: Text(file.path.split('/').last),
                    trailing: MusicPlayer(audioPath: file.path, file: File(file.path)),
                    onTap: () {
                      // Handle music file tap
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
