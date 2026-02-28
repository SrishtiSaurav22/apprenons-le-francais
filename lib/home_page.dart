import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'quiz_page.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    FlutterRingtonePlayer().play(fromAsset: "assets/audios/home_page_audio.mp3");
  }

  Widget homePageButton(
      String buttonText,
      Color buttonBackgroundColor,
      Color buttonBorderColor,
      {VoidCallback? onPressed}
      ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Container(
        // ADDING DYNAMIC SIZING
        //height: 100.0,
        height: MediaQuery.sizeOf(context).height*0.1,
        width: double.infinity,
        //width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: buttonBackgroundColor,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: buttonBorderColor,
            width: 6,
          ),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonBackgroundColor,
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    /*
    // to see the size of the screen
    double screenHeight=MediaQuery.sizeOf(context).height;
    double screenWidth=MediaQuery.sizeOf(context).width;

    print("Screen Height: $screenHeight\nScreen Width: $screenWidth\n");
     */

    return Scaffold(
      backgroundColor: Colors.indigo.shade900,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // why didn't this center the text?
          children: [

            Expanded(
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: <TextSpan>[

                      //Welcome to
                      TextSpan(
                        text: '\nWelcome To\n',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // space
                      TextSpan(
                        text: '\n',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Apprenons le Francais
                      TextSpan(
                        text: 'Apprenons\nLe Francais\n',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),

                ),

              ),
            ),

            const Expanded(
              child: Image(
                image: AssetImage('assets/images/flutter_dash_transparent_background.gif'),
                // ADDING DYNAMIC SIZING: the image will take up the size it can according to the screen and elements' sizes
                //height: 800,
                //width: 400,

              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  homePageButton(
                      'START',
                      Colors.green.shade900,
                      Colors.lightGreenAccent.shade100,
                      onPressed: () {
                        setState(() {
                          // go to the my-quiz-app
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return const MyQuizApp();
                                }
                            ),
                          );
                        });
                      },
                  ),

                  homePageButton(
                      'EXIT',
                      Colors.red.shade900,
                      Colors.redAccent.shade100,
                      onPressed: () {
                        // exit app button
                        SystemNavigator.pop();
                      }
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
