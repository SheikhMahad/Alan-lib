import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:radio_player/radio_player.dart';

import 'colors.dart';
import 'radio.dart';
import 'radio_list_tile.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({Key? key}) : super(key: key);

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  List<RadioModel>? radioList;
  RadioModel? currentPlayingRadio;
  RadioPlayer radioPlayer = RadioPlayer();
  bool isPlaying = false;
  int currentIndex = 0;

  bool get isRadioSelected => currentPlayingRadio != null;

  @override
  void initState() {
    super.initState();
    radioPlayer.stateStream.listen((value) {
      setState(() {
        isPlaying = value;
      });
    });
    fetchRadioData();
  }

  void fetchRadioData() async {
    try {
      var response = await http.get(Uri.parse("http://192.168.0.112:8000/radios"));
      List data = jsonDecode(response.body);
      setState(() {
        radioList = data.map((e) => RadioModel.fromJson(e)).toList();
        if (radioList!.isNotEmpty) {
          currentPlayingRadio = radioList![currentIndex];
          radioPlayer.setChannel(
            title: currentPlayingRadio!.title ?? "",
            url: currentPlayingRadio!.audioUrl ?? "",
            imagePath: currentPlayingRadio!.image,
          );
          radioPlayer.play();
        }
      });
    } catch (e) {
      print("Error fetching radio data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(
            //   width: double.infinity,
            //   child: Center(
            //     child: Image.asset(
            //       "assets/logo.png",
            //       width: 150,
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            if (isRadioSelected) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: currentPlayingRadio!.image ?? "",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Container(
                      color: CustomColors.primary.withOpacity(0.2),
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  currentPlayingRadio!.title ?? "No title Available",
                  style: textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: Text(
                  currentPlayingRadio!.subtitle ?? "No information available",
                  style: textTheme.titleMedium?.copyWith(color: Colors.black54),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.fast_rewind_outlined, size: 40),
                      onPressed: () {
                        if (currentIndex > 0) {
                          setState(() {
                            currentIndex--;
                            playSelectedRadio();
                          });
                        }
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        if (isPlaying) {
                          radioPlayer.pause();
                        } else {
                          radioPlayer.play();
                        }
                      },
                      child: Container(
                        width: 58,
                        height: 58,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: CustomColors.primary.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          shape: BoxShape.circle,
                          color: CustomColors.primary,
                        ),
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.fast_forward_outlined, size: 40),
                      onPressed: () {
                        if (currentIndex < radioList!.length - 1) {
                          setState(() {
                            currentIndex++;
                            playSelectedRadio();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 26),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Available Radios",
                style: textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: radioList == null
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : ListView.builder(
                itemCount: radioList!.length,
                itemBuilder: (context, index) => CustomRadioListTile(
                  radio: radioList![index],
                  isPlaying: index == currentIndex && isPlaying,
                  onTap: () {
                    setState(() {
                      currentIndex = index;
                      playSelectedRadio();
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void playSelectedRadio() {
    currentPlayingRadio = radioList![currentIndex];
    radioPlayer.setChannel(
      title: currentPlayingRadio!.title ?? "",
      url: currentPlayingRadio!.audioUrl ?? "",
      imagePath: currentPlayingRadio!.image,
    );
    radioPlayer.play();
  }
}