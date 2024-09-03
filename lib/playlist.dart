import 'package:flutter/material.dart';


class Playlist extends StatefulWidget {
  const Playlist({Key? key}) : super(key: key);

  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  // Define variables to hold playlists
  List<String> classicMusicPlaylist = ["Classic Song 1", "Classic Song 2", "Classic Song 3"];
  List<String> rockMusicPlaylist = ["Rock Song 1", "Rock Song 2", "Rock Song 3"];
  List<String> hipHopMusicPlaylist = ["Hip Hop Song 1", "Hip Hop Song 2", "Hip Hop Song 3"];

  // Function to add a song to a playlist
  void addToPlaylist(List<String> playlist, String song) {
    setState(() {
      playlist.add(song);
    });
  }

  // Function to remove a song from a playlist
  void removeFromPlaylist(List<String> playlist, String song) {
    setState(() {
      playlist.remove(song);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music Playlist"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPlaylistCard("Classic Music", classicMusicPlaylist, Icons.library_music),
            _buildPlaylistCard("Rock Music", rockMusicPlaylist, Icons.music_note),
            _buildPlaylistCard("Hip Hop Music", hipHopMusicPlaylist, Icons.queue_music),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistCard(String title, List<String> playlist, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  icon,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  playlist[index],
                  style: TextStyle(fontSize: 16),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    removeFromPlaylist(playlist, playlist[index]);
                  },
                ),
              );
            },
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  addToPlaylist(playlist, "New Song");
                },
                icon: Icon(Icons.add),
                label: Text("Add Song"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


