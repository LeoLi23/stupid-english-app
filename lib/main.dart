import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'article_page.dart';
import 'intro_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const App());
}

Future<int> getLessonsCount() async {
  final response = await http.get(
    Uri.parse('https://guangzhou-2gfa4ym6a2e500c2-1318830690.ap-guangzhou.app.tcloudbase.com/getLessonsCount'),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> result = jsonDecode(response.body);
    return result['fileCount'] as int;
  } else {
    throw Exception('Failed to load file count');
  }
}

class LessonImage extends StatelessWidget {
  final String url;

  const LessonImage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
      placeholder: (context, url) => const SizedBox(
        width: 50,
        height: 50,
      ),
      fadeInDuration: const Duration(milliseconds: 500),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English APP',
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: Color(0xff060B26),
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.0,
          ),
          headline4: TextStyle(
            color: Color(0xff060B26),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bodyText2: TextStyle(
            color: Color(0xff060B26),
            fontSize: 16,
          ),
        ),
      ),
      home: const MyHomePage(),
      initialRoute: '/intro',
      routes: {
        '/intro': (context) => IntroPage(),
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}): super(key: key);
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int unlockedLesson = 1;
  late Future<int> lessonsCount;

  Future<void> cacheImages() async {
    await precacheImage(const AssetImage('assets/images/cute_girl_after.jpg'), context);
  }

  Future<void> loadData(BuildContext context) async {
    lessonsCount = getLessonsCount();
    await Future.wait([
      lessonsCount,
      cacheImages(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: loadData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data!'));
          }

          return Scaffold(
            body: Stack(
              children: <Widget>[
                const SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xfff4c098),
                        )
                    )
                ),
                // This is the background image.
                Padding(
                  padding: const EdgeInsets.only(top:50), // adjust this padding value as you need
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        alignment: FractionalOffset.topCenter,
                        image: AssetImage('assets/images/cute_girl_after.jpg'),
                      ),
                    ),
                  ),
                ),
                // This is the lesson list section.
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                    child: Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height * 0.58,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Text.rich(
                                TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Practice',
                                          style: TextStyle(
                                            color: Colors.purple[300],
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: -1.0,
                                          )),
                                      const TextSpan(
                                          text: ' with',
                                          style: TextStyle(
                                            color: Color(0xff060B26),
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: -1.0,
                                          )),
                                      const TextSpan(
                                          text: ' Native Speakers',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: -1.0,
                                          )
                                      )
                                    ]
                                )
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FutureBuilder<int>(
                                  future: lessonsCount,
                                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return Text('${snapshot.data} Lessons', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20));
                                    }
                                  },
                                )
                              ],
                            ),
                            Expanded(
                              child: FutureBuilder<int>(
                                future: lessonsCount,
                                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return const Center(child: Text('Error loading lessons!'));
                                  } else {
                                    return ListView.builder(
                                      itemCount: snapshot.data, // Here we use the lessons count from the future
                                      itemBuilder: (context, index) {
                                        //print('current index: ${index}');
                                        return InkWell(
                                          onTap: () {
                                            if (index + 1 <= unlockedLesson) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ArticlePage(
                                                              imageIndex: index + 1,
                                                              onFinished: () {
                                                                if (kDebugMode) {
                                                                  print('The user has finished');
                                                                }
                                                                if (index + 1 == unlockedLesson && unlockedLesson < (snapshot.data ?? 0)) { // Check against lessons count here too
                                                                  setState(() {
                                                                    unlockedLesson++;
                                                                  });
                                                                }
                                                              }
                                                          )));
                                            }},
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            elevation: 2.0,
                                            child: ListTile(
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                              leading: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: LessonImage(url: 'https://stupid-english-app-1318830690.cos.ap-shanghai.myqcloud.com/images/lesson${index + 1}.jpg'), // This might need to change if you have dynamic URLs
                                              ),
                                              title: Text(
                                                'Lesson ${index + 1}', // Lesson number is now dynamic
                                                style: Theme.of(context).textTheme.headline4,
                                              ),
                                              trailing: index + 1 <= unlockedLesson ?
                                              Container(
                                                decoration: const BoxDecoration(
                                                  color: Colors.green, // Gold color
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.white,
                                                  size: 36,
                                                ),
                                              ) :
                                              const Icon(
                                                Icons.lock,
                                                color: Colors.grey,
                                                size: 36,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
