import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:just_audio/just_audio.dart'; // Import just_audio package
import 'package:image_picker/image_picker.dart'; // Import image_picker package

class FaceAnalysis extends StatefulWidget {
  const FaceAnalysis({Key? key}) : super(key: key);

  @override
  _FaceAnalysisState createState() => _FaceAnalysisState();
}

class _FaceAnalysisState extends State<FaceAnalysis> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;
  bool _isUsingFrontCamera = true;
  String? detectedEmotion;
  List<dynamic>? suggestedSongs;
  final AudioPlayer _audioPlayer = AudioPlayer(); // Create an AudioPlayer instance

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera([bool useFrontCamera = true]) async {
    try {
      cameras = await availableCameras();
      CameraDescription selectedCamera = useFrontCamera ? cameras!.first : cameras!.last;
      _cameraController = CameraController(selectedCamera, ResolutionPreset.medium);
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> captureAndSendImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final XFile imageFile = await _cameraController!.takePicture();
        final String imagePath = imageFile.path;
        await sendImageToBackend(File(imagePath));
      } catch (e) {
        print('Error capturing image: $e');
      }
    }
  }

  Future<void> sendImageToBackend(File imageFile) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse('https://31b4-154-208-41-131.ngrok-free.app/predict-emotion'));
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final Map<String, dynamic> data = json.decode(responseData.body);
        setState(()async {
          detectedEmotion = data['emotion'];
          await fetchSuggestedSongs();
        });


      } else {
        print('Error from backend: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending image to backend: $e');
    }
  }

  Future<void> fetchSuggestedSongs() async {
    print('Fetching songs');
    if (detectedEmotion != null) {
      try {
        final response = await http.get(
            Uri.parse('https://31b4-154-208-41-131.ngrok-free.app/suggest-song?emotion=$detectedEmotion'));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          print('songs list => $data');
          setState(() {
            suggestedSongs = data['songs'];
          });
        } else {
          print('Error fetching songs: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching suggested songs: $e');
      }
    }
  }

  Future<void> playSong(var url) async {
    try {
      print('Attempting to play song from URL: $url');

      if (Uri.tryParse(url)?.hasAbsolutePath ?? false) {
        await _audioPlayer.setUrl(url);
        _audioPlayer.play();
      } else {
        throw Exception('Invalid song URL');
      }
    } catch (e) {
      print('Error playing song: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to play the song')),
      );
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        await sendImageToBackend(File(pickedFile.path));
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
  }

  void toggleCamera() async {
    _isUsingFrontCamera = !_isUsingFrontCamera;
    await initializeCamera(_isUsingFrontCamera);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Mood Detector'),
        actions: [
          IconButton(
            icon: Icon(Icons.switch_camera),
            onPressed: toggleCamera,
          ),
        ],
      ),
      body: _isCameraInitialized
          ? Column(
        children: [
          SizedBox(
            height: 350,
            width: MediaQuery.of(context).size.width * 1.0,
            child: CameraPreview(_cameraController!),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: captureAndSendImage,
                child: Text('Detect Mood'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: pickImageFromGallery,
                child: Text('Upload Image'),
              ),
            ],
          ),
          if (detectedEmotion != null) Text('Detected Emotion: $detectedEmotion'),
          if (suggestedSongs != null)
            Expanded(
              child: ListView.builder(
                itemCount: suggestedSongs!.length,
                itemBuilder: (context, index) {
                  final song = suggestedSongs![index];
                  final String songTitle = song['title'];
                  final String artistName = song['artist']['name'];
                  final String songUrl = song['preview'];
                  print('songs tile');
                  return ListTile(
                      title: Text(songTitle),
                      subtitle: Text(artistName),
                      onTap: () {
                        playSong(songUrl);
                      }
                  );
                },
              ),
            ),
        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}