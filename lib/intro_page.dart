import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key); // Make sure Key is nullable
  @override
  IntroPageState createState() => IntroPageState();
}

class IntroPageState extends State<IntroPage> {
  final PageController controller = PageController();
  double previousPage = 0;
  final List<Map<String, String>> introCards = [
    {
      'header': 'Master English,\nOne Minute at a Time',
      'paragraph': 'Boost English with 1-minute lessons. Repeat 5 times for skill improvement.',
      'backgroundColor': '#FFFFFF',
      'image': 'assets/images/clock-removed.png',
    },
    {
      'header': 'Learn from the Best',
      'paragraph': 'Lessons from native English speakers help you master pronunciation, rhythm, and the nuances of English.',
      'backgroundColor': '#808080',
      'image': 'assets/images/micro-removed.png',
    },
    {
      'header': 'Content That Grows with You',
      'paragraph': 'Our lesson library grows with you. Master English in a shared journey.',
      'backgroundColor': '#edb68b',
      'image': 'assets/images/book-removed.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.page! > introCards.length - 1 && previousPage < controller.page!) {
        Navigator.pushReplacementNamed(context, '/');
      }
      previousPage = controller.page!;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemCount: introCards.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index >= introCards.length) {
          return Container();
        }
        return Scaffold(
          backgroundColor: Color(int.parse(introCards[index]['backgroundColor']!.replaceFirst('#', '0xFF'))),
          body: Column(
            children: [
              Expanded(
                flex: 7,
                child: Center(
                  child: Image(
                    image: AssetImage(introCards[index]['image']!),
                    width: 600,
                    height: 600,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20, top: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Text(
                        introCards[index]['header']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[900],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          introCards[index]['paragraph']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(width: 280, height: 50),
                        child: MaterialButton(
                          onPressed: () {
                            if (controller.hasClients && index < introCards.length - 1) {
                              controller.animateToPage(
                                index + 1,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              Navigator.pushReplacementNamed(context, '/');
                            }
                          },
                          color: Colors.black,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          child: Text(
                            index < introCards.length - 1 ? 'Continue' : 'Let\'s Get Started',
                            style: const TextStyle(fontSize: 20),
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
