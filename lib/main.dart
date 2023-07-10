import 'package:flutter/material.dart';
import 'article_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const myColor = Color(0XE9F1F0FF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English Practice Application',
      theme: ThemeData(
        primaryColor: myColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: myColor,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        )
      ),
      home: MyHomePage(), // default Route -> MyHomePage
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<String> images = [
    'assets/images/img1.jpg',
    'assets/images/img1.jpg',
    'assets/images/img1.jpg',
    'assets/images/img1.jpg',
    'assets/images/img1.jpg',
    'assets/images/img1.jpg',
    'assets/images/img1.jpg',
    'assets/images/img1.jpg',
    'assets/images/img1.jpg',
    'assets/images/img1.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final availableHeight = screenHeight - appBarHeight;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Padding(
          padding: EdgeInsets.only(left:16),
          child: Text('我的语料'),
        )
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: availableHeight, // set Height of available height
          child: GridView.builder(
            itemCount: images.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // number of items per row
            ),
            itemBuilder: (context, index) {
              // increase marginTop for very top two images while keeping the rest the same
              EdgeInsets padding = const EdgeInsets.all(10);
              if (index == 0 || index == 1) {
                padding = padding.copyWith(top: 20);
              }

              return Padding(
                padding: padding,
                child: InkWell(
                    onTap: () {
                      // define what happens when you tap on the image
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ArticlePage(imageIndex: index + 1)
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(images[index]),
                    )
                ),
              );
            },
          ),
        )
      )


    );
  }
}
