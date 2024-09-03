import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alan_voice/alan_voice.dart';
import 'login_page.dart';
import 'music_access.dart';
import 'Face_Analysis.dart';
import 'fm_radio.dart';
import 'Search.dart';
import 'playlist.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    AlanVoice.addButton(
        "6b1d43ccace6becfd9da83f8f261cfdd2e956eca572e1d8b807a3e2338fdd0dc/stage", // Replace with your Alan AI project key
        buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);

    // Handle voice commands
    AlanVoice.onCommand.add((command) {
      _handleCommand(command.data);
    });
  }

  void _handleCommand(Map<String, dynamic> command) {
    switch (command["command"]) {
      case "openFaceAnalysis":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FaceAnalysis()),
        );
        break;
      case "openFmRadio":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FmRadio()),
        );
        break;
      case "openMusicAccess":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MusicAccess()),
        );
        break;
      case "openSearch":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Search()),
        );
        break;
      case "logout":
        _logout();
        break;
      default:
        print("Unknown command");
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to LoginPage and replace the current page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Alan-Tune"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/music_bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Discover',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'New music and playlists',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            buildCard(Icons.music_note, 'Music Access', 'Explore music', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MusicAccess()),
              );
            }),
            buildCard(Icons.face, 'Face Analysis', 'Analyze your face', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FaceAnalysis()),
              );
            }),
            buildCard(Icons.radio, 'FM Radio', 'Listen to FM radio', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FmRadio()),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Playlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Account',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/pf1.jpg'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Alan-Tune',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Alan-Tune@application.com',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Search()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Playlist()),
        );
        break;
      case 3:
      // Open account screen
        break;
    }
  }

  Widget buildCard(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 50, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}
