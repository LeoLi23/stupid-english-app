import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

// New Page widget
class ArticlePage extends StatefulWidget {
  final int imageIndex;
  const ArticlePage({Key? key, required this.imageIndex}) : super(key: key);
  @override
  ArticlePageState createState() => ArticlePageState();
}

// Define a Sentence Class
class Sentence {
  final String text;
  final int startTime;
  final int endTime;

  Sentence(this.text, this.startTime, this.endTime);
}

class ArticlePageState extends State<ArticlePage> {
  int currentRound = 1;
  final player = AudioPlayer();
  bool isPlaying = true;
  bool _visible = false;
  double _opacity = 0.0;
  Duration position = const Duration(milliseconds: 0);
  Duration totalDuration = const Duration(milliseconds: 0);
  StreamSubscription<Duration>? positionSubscription;
  StreamSubscription<Duration>? durationSubscription;
  String paragraph = "";
  List<TextSpan> textSpans = [];
  List<double> speeds = [1.0, 1.25, 1.5];
  int selectedButton = 0;
  Color selectedColor = Colors.white;
  Color notSelectedColor = Colors.black;
  Color selectedTextColor = Colors.black;
  Color notSelectedTextColor = Colors.white;

  List<Sentence> sentences = [];
  int highlightedIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeAudio();
  }

  Future<void> initializeSentences() async {
    final String fileData = await rootBundle.loadString('assets/subtitles/audio${widget.imageIndex}.txt');
    List<String> lines = fileData.split('\n').where((line) => line.trim().isNotEmpty).toList();;

    for (int i = 1; i < lines.length - 1; i += 2){ // start from the second line
      if (kDebugMode) {
        print('lines[$i]: ${lines[i]}');
      }
      List<String> timestamps = lines[i].split(' ');
      if (kDebugMode) {
        print('timestamps: $timestamps');
      }
      int startTime = _convertTimeToMilliseconds(timestamps[0]);
      int endTime = _convertTimeToMilliseconds(timestamps[1]);
      String text = lines[i + 1].trim();
      if (kDebugMode) {
        print('text: $text, startTime: $startTime, endTime: $endTime');
      }
      sentences.add(Sentence(text, startTime, endTime));
    }
    setState(() {});
  }

  // convert time to double
  int _convertTimeToMilliseconds(String timeString){
    //00:00:02:72
    List<String> parts = timeString.split(':');
    //print('parts: $parts');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);
    int milliseconds = int.parse(parts[3]);
    return ((hours * 60 * 60 + minutes * 60 + seconds) * 1000 + milliseconds);
  }

  void toggleVisibility(bool visibility){
    setState(() {
      _visible = visibility;
    });
  }

  void initializeAudio() async {
    await initializeSentences();

    String audioPath = 'audio/audio${widget.imageIndex}.mp3';
    if (kDebugMode) {
      print("audioPath: $audioPath");
    }

    positionSubscription = player.onPositionChanged.listen((Duration p) {
      setState((){
        position = p;
        if (totalDuration.inMilliseconds != 0 && position.inMilliseconds.isFinite) {
          // Determine the curr sentence based on the audio position
          for (int index = 0; index < sentences.length; index++) {
            if (p.inMilliseconds >= sentences[index].startTime && p.inMilliseconds <= sentences[index].endTime) {
              // update the highlightedIndex
              setState(() {
                highlightedIndex = index;
              });
              break;
            }
          }
        }
      }); // update position
    });
    durationSubscription = player.onDurationChanged.listen((Duration d) {
      setState(() => totalDuration = d); // update total duration
    });

    // Repeat the audio for five times
    player.onPlayerComplete.listen((event){
      if (currentRound < 5) {
        player.seek(Duration.zero); // restart the audio from the beginning
        player.resume(); // start playing
        setState(() {
          currentRound++;
        });
      } else {
        player.stop();
      }
    });

    // Load and start the audio
    await player.play(AssetSource(audioPath));
  }

  void playAudio() async {
    if (isPlaying) {
      await player.pause();
    } else {
      await player.resume();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    // Cancel the subscription
    positionSubscription?.cancel();
    durationSubscription?.cancel();
    // Release the audio player
    player.dispose();
    super.dispose();
    if (kDebugMode) {
      print("Releasing");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Create TextSpan list
    textSpans = sentences.asMap().entries.map((entry) {
      int index = entry.key;
      Sentence sentence = entry.value;

      return TextSpan(
        text: "${sentence.text} ",
        style: TextStyle(
          fontSize: index == highlightedIndex ? 24 : 20,
          height: 1.6,
          color: index == highlightedIndex ? Colors.purple : Colors.black,
          fontFamily: 'Cambria',
          fontWeight: index == highlightedIndex ? FontWeight.bold : FontWeight.normal,
        ),
      );
    }).toList();

    return GestureDetector(
      onTap: () {
        playAudio();
        if (!_visible) {
          _visible = true;
          setState(() {
            _opacity = 1.0;
          });
          Timer(const Duration(seconds: 1), () {
            setState(() {
              _opacity = 0.0;
            });
            Timer(const Duration(milliseconds: 1000), () {
              _visible = false;
            });
          });
        }
      },
      child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg2.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Container(
                        width: 130,
                        height: 45,
                        margin: const EdgeInsets.only(top: 110),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.all(5)
                          ), child: Text(
                            'Round $currentRound',
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            )
                        ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      margin: const EdgeInsets.only(left: 26, right: 26, top: 30),
                      padding: const EdgeInsets.all(2),
                      child: RichText(
                            text: TextSpan(
                              children: textSpans,
                              style: const TextStyle(
                                fontSize: 20,
                                height: 1.6,
                                color: Colors.black,
                                fontFamily: 'Cambria',
                              ),
                            )
                          )
                      )
                    ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              thumbColor: Colors.grey[800],
                              activeTrackColor: Colors.grey[700],
                              inactiveTrackColor: Colors.grey[300],
                            ),
                            child: Slider(
                              value: totalDuration.inMilliseconds > 0 ? position.inMilliseconds.toDouble() / totalDuration.inMilliseconds.toDouble() : 0.0,
                              min: 0.0,
                              max: 1.0,
                              onChanged: (double value) async {
                                final seekMillis = (value * totalDuration.inMilliseconds).round();
                                await player.seek(Duration(milliseconds: seekMillis));
                                setState(() => position = Duration(milliseconds: seekMillis));
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              for (int i = 0; i < speeds.length; i++)
                                ElevatedButton(
                                  onPressed: () async {
                                    await player.setPlaybackRate(speeds[i]);
                                    setState(() {
                                      selectedButton = i;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: selectedButton == i ? selectedColor : notSelectedColor,
                                    onPrimary: selectedButton == i ? selectedTextColor : notSelectedTextColor,
                                    foregroundColor: selectedButton == i ? selectedTextColor : notSelectedTextColor,
                                    backgroundColor: selectedButton == i ? selectedColor : notSelectedColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    '${speeds[i]}x',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ),
            // This is the play/pause button that appears when the screen is tapped
            Container(
              margin: const EdgeInsets.only(right: 130, bottom: 40),
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 1000),
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 150,
                    color: Colors.grey[800],
                  ),
                  onPressed: null,
                )
              )
            ),
          ]
        )
      )
    );
  }
}
