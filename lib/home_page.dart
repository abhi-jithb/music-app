import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'services/music_service.dart';
import 'services/playlist_provider.dart';
import 'widgets/music_player.dart';
import 'alarm_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final TextEditingController urlController = TextEditingController();
  final TextEditingController playlistController = TextEditingController();
  List<File> musicFiles = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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

  Future<void> _pickMusicFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
      allowMultiple: true,
    );

    if (result != null) {
      final files = result.paths.map((path) => File(path!)).toList();
      setState(() {
        musicFiles.addAll(files);
      });
    }
  }

Future<void> _createPlaylist() async {
  final playlistName = playlistController.text;
  if (playlistName.isNotEmpty) {
    final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    playlistProvider.addPlaylist(playlistName);
    Navigator.of(context).pop();
    playlistController.clear();
  }
}

  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.alarm, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AlarmPage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
        title: Text('Enjoy App', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Music',
                prefixIcon: Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white10,
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
              
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickMusicFiles,
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('Add Music'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20)),
                    overlayColor: MaterialStateProperty.all(Colors.white24),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.black,
                          title: Text('Create Playlist', style: TextStyle(color: Colors.white)),
                          content: TextField(
                            controller: playlistController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Playlist Name',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel', style: TextStyle(color: Colors.white)),
                            ),
                            TextButton(
                              onPressed: _createPlaylist,
                              child: Text('Create', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.playlist_add, color: Colors.white),
                  label: Text('Create Playlist'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white10),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20)),
                    overlayColor: MaterialStateProperty.all(Colors.white24),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: 'Enter URL',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white10,
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchMusic,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: Text('Get Music'),
            ),
            SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              tabs: [
                Tab(text: 'Playlists'),
                Tab(text: 'Music Files'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Playlists Tab
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: playlistProvider.playlists.length,
                          itemBuilder: (context, index) {
                            final playlist = playlistProvider.playlists[index];
                            return Card(
                              color: Colors.blueGrey,
                              child: ListTile(
                                leading: Icon(Icons.music_note, color: const Color.fromARGB(255, 122, 81, 81)),
                                title: Text(playlist.name, style: TextStyle(color: Colors.white)),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.black,
                                        title: Text('Add Music to Playlist', style: TextStyle(color: Colors.white)),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('Select Music', style: TextStyle(color: Colors.white)),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: musicFiles.length,
                                                itemBuilder: (context, fileIndex) {
                                                  final file = musicFiles[fileIndex];
                                                  return ListTile(
                                                    title: Text(file.path.split('/').last, style: TextStyle(color: Colors.white)),
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
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // Music Files Tab
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: musicFiles.length,
                          itemBuilder: (context, index) {
                            final file = musicFiles[index];
                            return ListTile(
                              title: Text(file.path.split('/').last, style: TextStyle(color: Colors.white)),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
