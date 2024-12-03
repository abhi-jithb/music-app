import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<void> fetchMusicFromUrl(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Get the directory to save the file
    final directory = await getApplicationDocumentsDirectory();

    // Create a unique file name based on the URL
    final fileName = url.split('/').last + '.mp3';
    final file = File('${directory.path}/$fileName');

    // Save the audio data to the file
    await file.writeAsBytes(response.bodyBytes);
    
    print('Music fetched and saved successfully');
  } else {
    throw Exception('Failed to fetch music');
  }
}
