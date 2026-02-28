import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'identify_the_numbers_page.dart';
import 'quiz_page.dart';
import 'match_the_words_page.dart';
import 'fill_in_the_blanks_page.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

// FlutterRingtonePlayer().play(fromAsset: "assets/audios/ITN_question_audio/${(widget.questionText).toUpperCase()}.mp3");

class Reaction {
  final String _scoreSpecifyingText;
  final String _scoreReactionText;
  final String _scoreReactionImagePath;

  Reaction(this._scoreSpecifyingText, this._scoreReactionText, this._scoreReactionImagePath);

  String getScoreSpecifyingText() {
    return _scoreSpecifyingText;
  }

  String getScoreReactionText() {
    return _scoreReactionText;
  }

  String getScoreReactionImagePath() {
    return _scoreReactionImagePath;
  }
}

class MyCommonResultPage extends StatefulWidget {

  final String quizAcronym;
  /*
  This variable is used to refer to the correct quiz, its values are:

  1. FITB: Fill-In-The-Blanks quiz
  2. MTW: Match-The-Words quiz/game
  3. ITN: Identify-The-Number quiz
   */

  final int value;
  final int maxValue;
  /*
  The reason why I have used 'value' and 'maxValue' instead of 'score' and 'maxScore'
  is that 'value' can refer to a word with both positive and negative connotations,
  while 'score' has positive connotation.

  Here, 'value' can be a score and the higher the 'value', the more positive is the
  reaction image and text.

  However, 'value' can be the number of mismatches made by the user in the match
  game and so higher the 'value', the less positive is the reaction image and text.
   */

  const MyCommonResultPage({
    super.key,
    required this.quizAcronym,
    required this.value,
    required this.maxValue
  });

  @override
  State<MyCommonResultPage> createState() => _MyCommonResultPageState();
}

class _MyCommonResultPageState extends State<MyCommonResultPage> {

  /*
  The reaction images and text are as follows:

  0)
  value==0
  emoji0: burnout
  statement0: Vous devez plus pratiquer!

  1)
  value>0 and value<=(maxValue*0.25)
  emoji1: wondering
  statement1: La prochain fois, peut-etre!

  2)
  value>(maxValue*0.25) and value<=(maxValue*0.5)
  emoji2: straight face
  statement2: Assez bien!

  3)
  value>(maxValue*0.5) and value<=(maxValue*0.75)
  emoji3: smile
  statement3: C'est bien!

  4)
  value>(macValue*0.75) and value<maxValue
  emoji4: starry eyed
  statement4: Bravo!

  5)
  value==maxValue
  emoji5: celebrate
  statement5: C'est super!

  NOTE:
  1. For the quizzes Fill-In-The-Blanks and Identify-The-Numbers:
     The higher the value, the better.

  2. For the quiz Match-The-Word:
     The higher the value, the worse.
   */

  Reaction getReaction(String quizAcronym, int value, int maxValue) {

    String scoreSpecifyingText="";
    String scoreReactionText="";
    String scoreReactionImagePath="";

    int statementNumber=5;
    // by default, let the positive statement audio be played

    // value=0
    if(value==0) {
      if(quizAcronym=="FITB" || quizAcronym=="ITN") {
        scoreSpecifyingText="You scored $value out $maxValue!";
        scoreReactionText="Vous devez plus pratiquer!";
        scoreReactionImagePath="assets/images/match_game/burnout_emoji.jpg";
        statementNumber=0;
      }

      else if(quizAcronym=="MTW") {
        scoreSpecifyingText="You made $value mistakes!";
        scoreReactionText="C'est super!";
        scoreReactionImagePath="assets/images/match_game/celebrate_emoji.jpg";
        statementNumber=5;
      }
    }

    // value lies between 1 and (maxValue*0.25)
    else if(value>0 && value<=(maxValue*0.25)) {
      if(quizAcronym=="FITB" || quizAcronym=="ITN") {
        scoreSpecifyingText="You scored $value out $maxValue!";
        scoreReactionText="La prochain fois, peut-etre!";
        scoreReactionImagePath="assets/images/match_game/wondering_emoji.jpg";
        statementNumber=1;
      }

      else if(quizAcronym=="MTW") {
        scoreSpecifyingText="You made $value mistakes!";
        scoreReactionText="Bravo!";
        scoreReactionImagePath="assets/images/match_game/starry_eyed_emoji.jpg";
        statementNumber=4;
      }
    }

    // value lies between (maxValue*0.25) and (maxValue*0.5)
    else if(value>(maxValue*0.25) && value<=(maxValue*0.5)) {
      if(quizAcronym=="FITB" || quizAcronym=="ITN") {
        scoreSpecifyingText="You scored $value out $maxValue!";
        scoreReactionText="Assez bien!";
        scoreReactionImagePath="assets/images/match_game/straight_face_emoji.jpg";
        statementNumber=2;
      }

      else if(quizAcronym=="MTW") {
        scoreSpecifyingText="You made $value mistakes!";
        scoreReactionText="C'est bien!";
        scoreReactionImagePath="assets/images/match_game/smile_emoji.jpg";
        statementNumber=3;
      }
    }

    // value lies between (maxValue*0.5) and (maxValue*0.75)
    else if(value>(maxValue*0.5) && value<=(maxValue*0.75)) {
      if(quizAcronym=="FITB" || quizAcronym=="ITN") {
        scoreSpecifyingText="You scored $value out $maxValue!";
        scoreReactionText="C'est bien!";
        scoreReactionImagePath="assets/images/match_game/smile_emoji.jpg";
        statementNumber=3;
      }

      else if(quizAcronym=="MTW") {
        scoreSpecifyingText="You made $value mistakes!";
        scoreReactionText="Assez bien!";
        scoreReactionImagePath="assets/images/match_game/straight_face_emoji.jpg";
        statementNumber=2;
      }
    }

    // value lies between (maxValue*0.75) and (maxValue-1)
    else if(value>(maxValue*0.75) && value<maxValue) {
      if(quizAcronym=="FITB" || quizAcronym=="ITN") {
        scoreSpecifyingText="You scored $value out $maxValue!";
        scoreReactionText="Bravo!";
        scoreReactionImagePath="assets/images/match_game/starry_eyed_emoji.jpg";
        statementNumber=4;
      }

      else if(quizAcronym=="MTW") {
        scoreSpecifyingText="You made $value mistakes!";
        scoreReactionText="La prochain fois, peut-etre!";
        scoreReactionImagePath="assets/images/match_game/wondering_emoji.jpg";
        statementNumber=1;
      }
    }

    // value=maxValue
    else {
      if(quizAcronym=="FITB" || quizAcronym=="ITN") {
        scoreSpecifyingText="You scored $value out $maxValue!";
        scoreReactionText="C'est super!";
        scoreReactionImagePath="assets/images/match_game/celebrate_emoji.jpg";
        statementNumber=5;
      }

      else if(quizAcronym=="MTW") {
        scoreSpecifyingText="You made $value mistakes!";
        scoreReactionText="Vous devez plus pratiquer!";
        scoreReactionImagePath="assets/images/match_game/burnout_emoji.jpg";
        statementNumber=0;
      }
    }

    FlutterRingtonePlayer().play(fromAsset: "assets/audios/result_page_audio/statement$statementNumber.mp3");
    return Reaction(scoreSpecifyingText, scoreReactionText, scoreReactionImagePath);
  }

  Widget resultPageButton(
      String buttonText,
      double buttonHeight,
      double buttonTextFontSize,
      Color buttonBackgroundColor,
      Color buttonBorderColor,
      {VoidCallback? onPressed}
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: buttonHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: buttonBorderColor,
            width: 6,
          ),
          color: buttonBackgroundColor,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonBackgroundColor,
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.white,
              fontSize: buttonTextFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      //appBar: AppBar(),

      One way of pushing the TEXT-SPECIFYING-THE-SCORE text a bit away from the
      top of the screen is to use an appBar (white colored so it's not visible)
      because this will adjust as per the screen size and you can avoid setting
      any fixed dimensions.

      Or wrap that text with SafeArea widget!
       */
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            // TEXT SPECIFYING THE SCORE________________________________________________________________________________
            SafeArea(
              child: Text(
                getReaction(widget.quizAcronym, widget.value, widget.maxValue).getScoreSpecifyingText(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // REACTION BASED ON THE SCORE___________________________________________________________________________________
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // REACTION IMAGE_______________________________________________
                Image(
                  image: AssetImage(getReaction(widget.quizAcronym, widget.value, widget.maxValue).getScoreReactionImagePath()),
                  //height: 400.0,
                  height: MediaQuery.sizeOf(context).width*0.85,
                  width: MediaQuery.sizeOf(context).width*0.85,
                ),

                // REACTION TEXT________________________________________________
                Text(
                  "${getReaction(widget.quizAcronym, widget.value, widget.maxValue).getScoreReactionText()}\n\n",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

              ],
            ),

            // RESULT PAGE BUTTONS____________________________________________________________________________________________
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                // PLAY-AGAIN BUTTON____________________________
                resultPageButton(
                    'PLAY AGAIN',
                  // ADDING DYNAMIC SIZING
                    //80.0,
                    MediaQuery.sizeOf(context).height*0.09,
                    25.0,
                    Colors.green.shade900,
                    Colors.lightGreenAccent.shade100,
                    onPressed: () {
                      // play again button
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) {
                              if(widget.quizAcronym=="FITB") {
                                return const MyTinyQuizApp();
                              }

                              else if(widget.quizAcronym=="MTW") {
                                return const MyTinyMatchingGameApp();
                              }

                              else if(widget.quizAcronym=="ITN") {
                                return const MyIdentifyTheNumberQuizApp();
                              }

                              // this 'else' case is just a final default case
                              // it mostly will never be reached
                              else {
                                return const MyQuizApp();
                              }
                            }
                        ),
                      );
                    },
                ),

                // SEE-MORE BUTTON_____________________________
                resultPageButton(
                    'SEE MORE',
                    // ADDING DYNAMIC SIZING
                    // 80.0
                    MediaQuery.sizeOf(context).height*0.09,
                    25.0,
                    Colors.indigo.shade900,
                    Colors.lightBlueAccent.shade100,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) {
                              return const MyQuizApp();
                            }
                        ),
                      );
                    }
                  ),

                // EXIT BUTTON_________________________________
                resultPageButton(
                    'EXIT',
                    // ADDING DYNAMIC SIZING
                    // 80.0,
                    MediaQuery.sizeOf(context).height*0.09,
                    25.0,
                    Colors.red.shade900,
                    Colors.redAccent.shade100,
                      onPressed: () {
                        SystemNavigator.pop();
                      }
                  ),

              ],
            ),

          ],
        ),
      ),
    );
  }
}
