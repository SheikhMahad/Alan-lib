import 'package:flutter/material.dart';


class MusicAccess extends StatefulWidget {
  const MusicAccess({super.key});

  @override
  State<MusicAccess> createState() => _MusicAccessState();
}

class _MusicAccessState extends State<MusicAccess> {
  bool isPlaying = false;
  double currentPosition = 0.0;

  void playPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music Access"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Album Art
              Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/album.jpg'), // Make sure you have an image asset
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Song Title and Artist
              Text(
                "Song Title",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "Artist Name",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 20),
              // Progress Bar
              Slider(
                value: currentPosition,
                min: 0.0,
                max: 100.0,
                onChanged: (value) {
                  setState(() {
                    currentPosition = value;
                  });
                },
              ),
              SizedBox(height: 20),
              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous),
                    iconSize: 36,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    iconSize: 36,
                    onPressed: playPause,
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next),
                    iconSize: 36,
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Additional Icons (Add to favorite, Share, Add to playlist)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    iconSize: 30,
                    onPressed: () {
                      // Add to favorite functionality
                    },
                  ),

                  IconButton(
                    icon: Icon(Icons.playlist_add),
                    iconSize: 30,
                    onPressed: () {
                      // Add to playlist functionality
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}