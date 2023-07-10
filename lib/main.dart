import 'package:flutter/material.dart';
import 'article_page.dart';

void main() {
  runApp(const App());
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
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}): super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int unlockedLesson = 1;
  final lessonImages = [
    'https://stupid-english-app-1318830690.cos.ap-shanghai.myqcloud.com/images/lesson1.jpg',
    'https://stupid-english-app-1318830690.cos.ap-shanghai.myqcloud.com/images/lesson1.jpg',
    'https://stupid-english-app-1318830690.cos.ap-shanghai.myqcloud.com/images/lesson1.jpg',
    'https://stupid-english-app-1318830690.cos.ap-shanghai.myqcloud.com/images/lesson1.jpg',
    'https://stupid-english-app-1318830690.cos.ap-shanghai.myqcloud.com/images/lesson1.jpg',
    'https://stupid-english-app-1318830690.cos.ap-shanghai.myqcloud.com/images/lesson1.jpg',
    'https://stupid-english-app-1318830690.cos.ap-shanghai.myqcloud.com/images/lesson1.jpg',
    'https://stupid-english-app-1318830690.cos.ap-shanghai.myqcloud.com/images/lesson1.jpg',
    'https://stupid-english-app-1318830690.cos.ap-shanghai.myqcloud.com/images/lesson1.jpg',
    'https://stupid-english-app-1318830690.cos.ap-shanghai.myqcloud.com/images/lesson1.jpg',
  ];

  @override
  Widget build(BuildContext context) {
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
                  image: NetworkImage('https://stupid-english-app-1318830690.cos.ap-shanghai.myqcloud.com/images/cute_girl_after.jpg'),
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
                      Text(
                        'Improve your vocal English fast',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('10 Lessons', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                          Text('10 Minutes', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (index + 1 <= unlockedLesson) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ArticlePage(imageIndex: index + 1))).then((_) {
                                                if (index + 1 == unlockedLesson && unlockedLesson < 10) {
                                                  setState(() {
                                                    unlockedLesson++;
                                                  });
                                                }
                                      });
                                  }
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2.0, // reduced shadow effect
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0), // increased height
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      lessonImages[index],
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      ),
                                  ),
                                  title: Text(
                                    'Lesson ${index + 1}',
                                    style: Theme.of(context).textTheme.headline4,
                                  ),
                                  trailing: Icon(
                                    index + 1 <= unlockedLesson ? Icons.lock_open : Icons.lock,
                                    color: Colors.green[200],
                                    size: 30.0,
                                  ),
                                ),
                              ),
                            );
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
}
