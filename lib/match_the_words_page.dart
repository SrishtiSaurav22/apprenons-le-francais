/*
 DO NOT REMOVE THE PRINT STATEMENTS OR THE COMMENTED CODE.
 THEY'LL HELP YOU IN THE FUTURE!
*/

import 'package:flutter/material.dart';
import 'home_page.dart';
import 'quiz_page.dart';
import 'common_result_page.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class WordPair {
  late String wordENG;
  late String wordFR;

  WordPair(this.wordENG, this.wordFR);
}

class ProgressReaction {
  final String _progressStatement;
  final int _progressStatementAudioNumber;

  ProgressReaction(this._progressStatement, this._progressStatementAudioNumber);

  String returnProgressStatement() {
    return _progressStatement;
  }

  int returnProgressStatementAudioNumber() {
    return _progressStatementAudioNumber;
  }
}

class CustomTextToDisplayOnButton extends StatelessWidget {
  final String textToDisplay;
  const CustomTextToDisplayOnButton({super.key, required this.textToDisplay});

  @override
  Widget build(BuildContext context) {
    return Text(
      textToDisplay,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }
}

class MyTinyMatchingGameApp extends StatefulWidget {
  const MyTinyMatchingGameApp({super.key});

  @override
  State<MyTinyMatchingGameApp> createState() => _MyTinyMatchingGameAppState();
}

class _MyTinyMatchingGameAppState extends State<MyTinyMatchingGameApp> {

  /*
  // CODE BY GEMINI FOR CALCULATING AND STORING THE TIME SPENT BY THE USER ON THE MATCHING GAME
  // STARTS HERE
  Duration _totalTimeSpent = Duration.zero;
  late Stopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _loadSpentTime();
    _startTimer();
  }

  void _loadSpentTime() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDuration = prefs.getString('totalTimeSpent');
    if (storedDuration != null) {
      _totalTimeSpent = Duration(milliseconds: int.parse(storedDuration));
    }
  }

  void _startTimer() {
    _stopwatch = Stopwatch()..start();
  }

  @override
  void dispose() {
    _stopwatch?.stop();
    _updateTimeSpent(_stopwatch.elapsed);
    super.dispose();
  }

  void _updateTimeSpent(Duration spentTime) {
    setState(() {
      _totalTimeSpent += spentTime;
      _saveSpentTime(_totalTimeSpent);
    });
  }

  void _saveSpentTime(Duration timeSpent) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('totalTimeSpent', timeSpent.inMilliseconds.toString());
  }

  String _getMessageBasedOnTime(Duration timeSpent) {
    if (timeSpent.inSeconds < 2) {
      return 'AAAAAAAAAAAAAAA';
    } else if (timeSpent.inSeconds>=2 && timeSpent.inSeconds < 5) {
      return 'BBBBBBBBBBBBBBBBBBBB';
    } else {
      return 'CCCCCCCCCCCCCCCCCC';
    }
  }
   */

  // The text of the word buttons remains white, hence no wordButtonText type of variable

  Color selectedWordButtonBackgroundColor=Colors.indigo.shade900;
  Color deselectedWordButtonBackgroundColor=Colors.pink.shade900;

  Color selectedWordButtonBorderColor=Colors.lightBlueAccent.shade100;
  Color deselectedWordButtonBorderColor=Colors.pinkAccent.shade100;

  Color correctlyMatchedWordButtonBackgroundColor=Colors.lightGreen.shade900;
  Color incorrectlyMatchedWordButtonBackgroundColor=Colors.red.shade900;

  Color correctlyMatchedWordButtonBorderColor=Colors.lightGreenAccent.shade100;
  Color incorrectlyMatchedWordButtonBorderColor=Colors.redAccent.shade100;

  // Button selection variables
  bool row0ENGButtonSelected=false;
  bool row1ENGButtonSelected=false;
  bool row2ENGButtonSelected=false;
  bool row3ENGButtonSelected=false;
  bool row4ENGButtonSelected=false;

  bool row0FRButtonSelected=false;
  bool row1FRButtonSelected=false;
  bool row2FRButtonSelected=false;
  bool row3FRButtonSelected=false;
  bool row4FRButtonSelected=false;

  /*
  Button CORRECT match check variables

  If these are made TRUE then the CORRECTLY matched buttons change
  their color and are no longer available for further matching
   */
  bool row0ENGButtonCorrectlyMatched=false;
  bool row1ENGButtonCorrectlyMatched=false;
  bool row2ENGButtonCorrectlyMatched=false;
  bool row3ENGButtonCorrectlyMatched=false;
  bool row4ENGButtonCorrectlyMatched=false;

  bool row0FRButtonCorrectlyMatched=false;
  bool row1FRButtonCorrectlyMatched=false;
  bool row2FRButtonCorrectlyMatched=false;
  bool row3FRButtonCorrectlyMatched=false;
  bool row4FRButtonCorrectlyMatched=false;

  /*
  Button INCORRECT match check variables

  If these are made TRUE then the INCORRECTLY matched buttons change
  their color for a few seconds and are available for further matching.
   */
  bool row0ENGButtonIncorrectlyMatched=false;
  bool row1ENGButtonIncorrectlyMatched=false;
  bool row2ENGButtonIncorrectlyMatched=false;
  bool row3ENGButtonIncorrectlyMatched=false;
  bool row4ENGButtonIncorrectlyMatched=false;

  bool row0FRButtonIncorrectlyMatched=false;
  bool row1FRButtonIncorrectlyMatched=false;
  bool row2FRButtonIncorrectlyMatched=false;
  bool row3FRButtonIncorrectlyMatched=false;
  bool row4FRButtonIncorrectlyMatched=false;

  // Button text variables
  String row0ENGButtonText="Garden";
  String row1ENGButtonText="Cat";
  String row2ENGButtonText="Dog";
  String row3ENGButtonText="Girl";
  String row4ENGButtonText="Street";

  String row0FRButtonText="Fille";
  String row1FRButtonText="Jardin";
  String row2FRButtonText="Chien";
  String row3FRButtonText="Chat";
  String row4FRButtonText="Rue";

  List<WordPair> listOfMatchingWordPairs=[
    WordPair('Garden', 'Jardin'),
    WordPair('Cat', 'Chat'),
    WordPair('Dog', 'Chien'),
    WordPair('Girl', 'Fille'),
    WordPair('Street', 'Rue'),
  ];

  List<WordPair> listOfDisplayedWordPairs=[
    WordPair('Garden','Fille'),
    WordPair('Cat','Jardin'),
    WordPair('Dog','Chien'),
    WordPair('Girl','Chat'),
    WordPair('Street','Rue'),
  ];

  // function that takes an input FRENCH word and returns its matching ENGLISH word.
  String returnMatchingENGWordText(String inputFRWordText) {
    for(int i=0;i<listOfMatchingWordPairs.length;i++) {
      if(inputFRWordText==listOfMatchingWordPairs[i].wordFR) {
        return listOfMatchingWordPairs[i].wordENG;
      }
    }
    return "";
    /*
    I've added this to remove the following error:
    The body might complete normally, causing 'null'
    to be returned, but the return type, 'String',
    is a potentially non-nullable type.
     */
  }

  // function that takes an input ENGLISH word and returns its matching FRENCH word.
  String returnMatchingFRWordText(String inputENGWordText) {
    for(int i=0;i<listOfMatchingWordPairs.length;i++) {
      if(inputENGWordText==listOfMatchingWordPairs[i].wordENG) {
        return listOfMatchingWordPairs[i].wordFR;
      }
    }
    return "";
    /*
    I've added this to remove the following error:
    The body might complete normally, causing 'null'
    to be returned, but the return type, 'String',
    is a potentially non-nullable type.
     */
  }

  bool checkMatching(String selectedButton1Text, String selectedButton2Text, String selectedButtonTextLanguage ) {
    // as in selectedButton1Text is an ENGLISH word
    if( selectedButtonTextLanguage=="ENG" ) {
      if ( selectedButton2Text == returnMatchingFRWordText(selectedButton1Text) ) {
        return true;
      }
      else {
        return false;
      }
    }

    // as in selectedButton1Text is a FRENCH word
    else {
      if( selectedButton2Text == returnMatchingENGWordText(selectedButton1Text) ) {
        return true;
      }
      else {
        return false;
      }
    }
  }

  Widget wordButtonMatched(String wordButtonText, bool matchingIsCorrect) {
    return Container(
      // ADDING DYNAMIC SIZING
      //height: 85.0,
      height: MediaQuery.sizeOf(context).height*0.08, // very slightly less than 85.0 but close enough
      //width: 175.0,
      width: MediaQuery.sizeOf(context).width*0.42,
      decoration: BoxDecoration(
        color: matchingIsCorrect ? correctlyMatchedWordButtonBackgroundColor : incorrectlyMatchedWordButtonBackgroundColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: matchingIsCorrect ? correctlyMatchedWordButtonBorderColor : incorrectlyMatchedWordButtonBorderColor,
          width: 6,
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          // I'll try to disable the button after it shows its color for a few seconds in case of CORRECT matching
          matchingIsCorrect ? print("This button cannot be used! It's already correctly matched!") : print("Button will go back to unselected in 1 second.");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: matchingIsCorrect ? correctlyMatchedWordButtonBackgroundColor : incorrectlyMatchedWordButtonBackgroundColor,
        ),
        child: CustomTextToDisplayOnButton(textToDisplay: wordButtonText),
      ),
    );
  }

  // function to display a message based on how you go on making matches
  String statementForNumOfCorrectMatchesMade(int numOfCorrectMatchesMade, int numOfPossibleMatches) {
    /*
    numOfCorrectMatchesMade is being compared with numbers directly for 5 pair of ENG-FR buttons,
    but it should be compared with some percentage of numOfPossibleMatches.
    CHANGE IT LATER IF YOU CAN.
     */

    String progressStatement="";
    // to remove any error concerned with the function potentially returning null.

    if(numOfCorrectMatchesMade==0) { progressStatement="Commencons!"; }
    else if(numOfCorrectMatchesMade==1) { progressStatement="Bravo!"; }
    else if(numOfCorrectMatchesMade==2) { progressStatement="Essayez plus!"; }
    else if(numOfCorrectMatchesMade==3) { progressStatement="N'arretez pas!"; }
    else if(numOfCorrectMatchesMade==4) { progressStatement="Proche de gagner!"; }
    else if(numOfCorrectMatchesMade==numOfPossibleMatches) { progressStatement="C'est super!"; }

    return progressStatement;
  }

  int numOfWordPairsCorrectlyMatched=0;
  int numOfWordPairMatchesPossible=5;

  int numOfWordPairsIncorrectlyMatched=0;
  int numOfWordPairMismatchesPossible=20; // every word in one language column is MISmatched with 4 words in the other language column

  bool allowSubmission() {
    if(numOfWordPairsCorrectlyMatched==numOfWordPairMatchesPossible) { return true; }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // this is 'true' by default hence the unexpected back button
        title: const Center(
          child: Text(
              'A Francophone Game',
            //textAlign: TextAlign.center, // why didn't this center the text?
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        backgroundColor: Colors.pink.shade900,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.home,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Are you sure?'),
                  content: const Text('If you leave the quiz now, your progress will be lost!'),
                  actions: [

                    TextButton(
                      onPressed: () {
                        // go 'back' to the first page of the app that welcomes you
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const HomePage();
                            },
                          ),
                        );
                      },
                      child: const Text("CONFIRM"),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("CANCEL"),
                    ),

                  ],
                );
              }
              );
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {

              setState(() {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Are you sure?'),
                      content: const Text('If you leave the quiz now, your progress will be lost!'),
                      actions: [

                        TextButton(
                          onPressed: () {
                            // go 'back' to the previous page i.e my-quiz-app page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const MyQuizApp();
                                },
                              ),
                            );
                          },
                          child: const Text("CONFIRM"),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("CANCEL"),
                        ),

                      ],
                    );
                  },
                );
              });
            },
            icon: const Icon(
              Icons.my_library_books,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            // INSTRUCTION TEXT---------------------------------------------------------------------------------
            const Text(
                '\nMatch the following words!\n',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            // ROW 0----------------------------------------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // row0ENG
                // ENGLISH WORD BUTTON----------------------------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: row0ENGButtonIncorrectlyMatched ? wordButtonMatched(row0ENGButtonText, false) : row0ENGButtonCorrectlyMatched ? wordButtonMatched(row0ENGButtonText, true) : Container(
                    // ADDING DYNAMIC SIZING
                    //height: 85.0,
                    height: MediaQuery.sizeOf(context).height*0.08, // very slightly less than 85.0 but close enough
                    //width: 175.0,
                    width: MediaQuery.sizeOf(context).width*0.42,
                    decoration: BoxDecoration(
                      color: row0ENGButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: row0ENGButtonSelected ? selectedWordButtonBorderColor : deselectedWordButtonBorderColor,
                          width: 6,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {

                        FlutterRingtonePlayer().play(fromAsset: "assets/audios/MTW_eng_audio/${row0ENGButtonText.toUpperCase()}.mp3");

                        setState(() {
                          row0ENGButtonSelected=!row0ENGButtonSelected;

                          if(row0ENGButtonSelected) {
                            /*
                            We don't need to check if THIS button is correctly matched because once correctly matched, it won't have these
                            conditions inside it.

                            We only need to check the 'correctly matched' variable for the other language rows buttons that will be matched
                            (correctly or incorrectly) with this button.
                             */

                            // deselect every other button in the same language column
                            row1ENGButtonSelected=false;
                            row2ENGButtonSelected=false;
                            row3ENGButtonSelected=false;
                            row4ENGButtonSelected=false;

                            print("\nrow0ENG i.e. $row0ENGButtonText is selected FIRST!");

                            // now check for the buttons of the other language column
                            if(row0FRButtonCorrectlyMatched==false && row0FRButtonSelected==true) {
                              print("row0FR i.e. $row0FRButtonText is selected SECOND!");
                              if(checkMatching(row0ENGButtonText, row0FRButtonText, "ENG")) {
                                // row0ENG and row0FR matched!
                                row0ENGButtonCorrectlyMatched=true;
                                row0FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                                print("$row0ENGButtonText and $row0FRButtonText are a match!");
                              }
                              else {
                                // row0ENG and row0FR DID NOT MATCH!
                                row0ENGButtonIncorrectlyMatched=true;
                                row0FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                print("$row0ENGButtonText and $row0FRButtonText are NOT a match!");
                                print("TIME FOR A NEW CHANGE!");
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row0ENGButtonIncorrectlyMatched=false;
                                    row0FRButtonIncorrectlyMatched=false;
                                    print("NEW CHANGE OVER, WE'RE BACK TO THE OLD WAYS!");
                                    row0ENGButtonSelected=false;
                                    row0FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row1FRButtonCorrectlyMatched==false && row1FRButtonSelected==true) {
                              print("row1FR i.e. $row1FRButtonText is selected SECOND!");
                              if(checkMatching(row0ENGButtonText, row1FRButtonText, "ENG")) {
                                // row0ENG and row1FR matched!
                                row0ENGButtonCorrectlyMatched=true;
                                row1FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                                print("$row0ENGButtonText and $row1FRButtonText are a match!");
                              }
                              else {
                                // row0ENG and row1FR DID NOT MATCH!
                                row0ENGButtonIncorrectlyMatched=true;
                                row1FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                print("$row0ENGButtonText and $row1FRButtonText are NOT a match!");
                                print("TIME FOR A NEW CHANGE!");
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row0ENGButtonIncorrectlyMatched=false;
                                    row1FRButtonIncorrectlyMatched=false;
                                    print("NEW CHANGE OVER, WE'RE BACK TO THE OLD WAYS!");
                                    row0ENGButtonSelected=false;
                                    row1FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row2FRButtonCorrectlyMatched==false && row2FRButtonSelected==true) {
                              if(checkMatching(row0ENGButtonText, row2FRButtonText, "ENG")) {
                                // row0ENG and row2FR matched!
                                row0ENGButtonCorrectlyMatched=true;
                                row2FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row0ENG and row2FR DID NOT MATCH!
                                row0ENGButtonIncorrectlyMatched=true;
                                row2FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;

                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row0ENGButtonIncorrectlyMatched=false;
                                    row2FRButtonIncorrectlyMatched=false;
                                    row0ENGButtonSelected=false;
                                    row2FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row3FRButtonCorrectlyMatched==false && row3FRButtonSelected==true) {
                              if(checkMatching(row0ENGButtonText, row3FRButtonText, "ENG")) {
                                // row0ENG and row3FR matched!
                                row0ENGButtonCorrectlyMatched=true;
                                row3FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row0ENG and row3FR DID NOT MATCH!
                                row0ENGButtonIncorrectlyMatched=true;
                                row3FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;

                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row0ENGButtonIncorrectlyMatched=false;
                                    row3FRButtonIncorrectlyMatched=false;
                                    row0ENGButtonSelected=false;
                                    row3FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row4FRButtonCorrectlyMatched==false && row4FRButtonSelected==true) {
                              if(checkMatching(row0ENGButtonText, row4FRButtonText, "ENG")) {
                                // row0ENG and row4FR matched!
                                row0ENGButtonCorrectlyMatched=true;
                                row4FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row0ENG and row4FR DID NOT MATCH!
                                row0ENGButtonIncorrectlyMatched=true;
                                row4FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;

                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row0ENGButtonIncorrectlyMatched=false;
                                    row4FRButtonIncorrectlyMatched=false;
                                    row0ENGButtonSelected=false;
                                    row4FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                          } // if(row0ENGButtonSelected==true)

                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: row0ENGButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      ),
                      child: CustomTextToDisplayOnButton(textToDisplay: listOfDisplayedWordPairs[0].wordENG),
                    ),
                  ),
                ),

                // row0FR
                // FRENCH WORD BUTTON-------------------------------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: row0FRButtonIncorrectlyMatched ? wordButtonMatched(row0FRButtonText, false) : row0FRButtonCorrectlyMatched ? wordButtonMatched(row0FRButtonText, true) : Container(
                    // ADDING DYNAMIC SIZING
                    //height: 85.0,
                    height: MediaQuery.sizeOf(context).height*0.08, // very slightly less than 85.0 but close enough
                    //width: 175.0,
                    width: MediaQuery.sizeOf(context).width*0.42,
                    decoration: BoxDecoration(
                      color: row0FRButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: row0FRButtonSelected ? selectedWordButtonBorderColor : deselectedWordButtonBorderColor,
                          width: 6,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {

                        FlutterRingtonePlayer().play(fromAsset: "assets/audios/MTW_fr_audio/${row0FRButtonText.toUpperCase()}.mp3");

                        setState(() {
                          row0FRButtonSelected=!row0FRButtonSelected;

                          if(row0FRButtonSelected) {

                            // deselect every other button in the same language column
                            row1FRButtonSelected=false;
                            row2FRButtonSelected=false;
                            row3FRButtonSelected=false;
                            row4FRButtonSelected=false;

                            print("\nrow0FR i.e. $row0FRButtonText is selected FIRST!");

                            // now check for the buttons of the other language column
                            if(row0ENGButtonCorrectlyMatched==false && row0ENGButtonSelected==true) {
                              print("row0ENG i.e. $row0ENGButtonText is selected SECOND!");
                              if(checkMatching(row0FRButtonText, row0ENGButtonText, "FR")) {
                                // row0FR and row0ENG matched!
                                row0FRButtonCorrectlyMatched=true;
                                row0ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                                print("$row0FRButtonText and $row0ENGButtonText are a match!");
                              }
                              else {
                                // row0FR and row0ENG DID NOT MATCH!
                                row0FRButtonIncorrectlyMatched=true;
                                row0ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                print("$row0FRButtonText and $row0ENGButtonText are NOT a match!");
                                print("TIME FOR A NEW CHANGE!");
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row0FRButtonIncorrectlyMatched=false;
                                    row0ENGButtonIncorrectlyMatched=false;
                                    print("NEW CHANGE OVER, WE'RE BACK TO THE OLD WAYS!");
                                    row0FRButtonSelected=false;
                                    row0ENGButtonSelected=false;
                                  });
                                });

                              }
                            }

                            else if(row1ENGButtonCorrectlyMatched==false && row1ENGButtonSelected==true) {
                              print("row1ENG i.e. $row1ENGButtonText is selected SECOND!");
                              if(checkMatching(row0FRButtonText, row1ENGButtonText, "FR")) {
                                // row0FR and row1ENG matched!
                                row0FRButtonCorrectlyMatched=true;
                                row1ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                                print("$row0FRButtonText and $row1ENGButtonText are a match!");
                              }
                              else {
                                // row0FR and row1ENG DID NOT MATCH!
                                row0FRButtonIncorrectlyMatched=true;
                                row1ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                print("$row0FRButtonText and $row1ENGButtonText are NOT a match!");
                                print("TIME FOR A NEW CHANGE!");
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row0FRButtonIncorrectlyMatched=false;
                                    row1ENGButtonIncorrectlyMatched=false;
                                    print("NEW CHANGE OVER, WE'RE BACK TO THE OLD WAYS!");
                                    row0FRButtonSelected=false;
                                    row1ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row2ENGButtonCorrectlyMatched==false && row2ENGButtonSelected==true) {
                              if(checkMatching(row0FRButtonText, row2ENGButtonText, "FR")) {
                                // row0FR and row2ENG matched!
                                row0FRButtonCorrectlyMatched=true;
                                row2ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row0FR and row2ENG DID NOT MATCH!
                                row0FRButtonIncorrectlyMatched=true;
                                row2ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row0FRButtonIncorrectlyMatched=false;
                                    row2ENGButtonIncorrectlyMatched=false;
                                    row0FRButtonSelected=false;
                                    row2ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row3ENGButtonCorrectlyMatched==false && row3ENGButtonSelected==true) {
                              if(checkMatching(row0FRButtonText, row3ENGButtonText, "FR")) {
                                // row0FR and row3ENG matched!
                                row0FRButtonCorrectlyMatched=true;
                                row3ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row0FR and row3ENG DID NOT MATCH!
                                row0FRButtonIncorrectlyMatched=true;
                                row3ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row0FRButtonIncorrectlyMatched=false;
                                    row3ENGButtonIncorrectlyMatched=false;
                                    row0FRButtonSelected=false;
                                    row3ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row4ENGButtonCorrectlyMatched==false && row4ENGButtonSelected==true) {
                              if(checkMatching(row0FRButtonText, row4ENGButtonText, "FR")) {
                                // row0FR and row4ENG matched!
                                row0FRButtonCorrectlyMatched=true;
                                row4ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row0FR and row4ENG DID NOT MATCH!
                                row0FRButtonIncorrectlyMatched=true;
                                row4ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row0FRButtonIncorrectlyMatched=false;
                                    row4ENGButtonIncorrectlyMatched=false;
                                    row0FRButtonSelected=false;
                                    row4ENGButtonSelected=false;
                                  });
                                });
                              }
                            }
                          } // if(row0FRButtonSelected==true)

                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: row0FRButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      ),
                      child: CustomTextToDisplayOnButton(textToDisplay: listOfDisplayedWordPairs[0].wordFR),
                    ),
                  ),
                ),

              ],
            ),

            // ROW 1-------------------------------------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // row1ENG
                // ENGLISH WORD BUTTON-------------------------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: row1ENGButtonIncorrectlyMatched ? wordButtonMatched(row1ENGButtonText, false) : row1ENGButtonCorrectlyMatched ? wordButtonMatched(row1ENGButtonText, true) : Container(
                    // ADDING DYNAMIC SIZING
                    //height: 85.0,
                    height: MediaQuery.sizeOf(context).height*0.08, // very slightly less than 85.0 but close enough
                    //width: 175.0,
                    width: MediaQuery.sizeOf(context).width*0.42,
                    decoration: BoxDecoration(
                      color: row1ENGButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: row1ENGButtonSelected ? selectedWordButtonBorderColor : deselectedWordButtonBorderColor,
                          width: 6,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {

                        FlutterRingtonePlayer().play(fromAsset: "assets/audios/MTW_eng_audio/${row1ENGButtonText.toUpperCase()}.mp3");

                        setState(() {
                          row1ENGButtonSelected=!row1ENGButtonSelected;

                          if(row1ENGButtonSelected) {

                            // deselect every other button in the same language column
                            row0ENGButtonSelected=false;
                            row2ENGButtonSelected=false;
                            row3ENGButtonSelected=false;
                            row4ENGButtonSelected=false;

                            print("\nrow1ENG i.e. $row1ENGButtonText is selected FIRST!");

                            // now check for the buttons of the other language column
                            if(row0FRButtonCorrectlyMatched==false && row0FRButtonSelected==true) {
                              print("row0FR i.e. $row0FRButtonText is selected SECOND!");
                              if(checkMatching(row1ENGButtonText, row0FRButtonText, "ENG")) {
                                // row1ENG and row0FR matched!
                                row1ENGButtonCorrectlyMatched=true;
                                row0FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                                print("$row1ENGButtonText and $row0FRButtonText are a match!");
                              }
                              else {
                                // row1ENG and row0FR DID NOT MATCH!
                                row1ENGButtonIncorrectlyMatched=true;
                                row0FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                print("$row1ENGButtonText and $row0FRButtonText are NOT a match!");
                                print("TIME FOR A NEW CHANGE!");
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row1ENGButtonIncorrectlyMatched=false;
                                    row0FRButtonIncorrectlyMatched=false;
                                    print("NEW CHANGE OVER, WE'RE BACK TO THE OLD WAYS!");
                                    row1ENGButtonSelected=false;
                                    row0FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row1FRButtonCorrectlyMatched==false && row1FRButtonSelected==true) {
                              print("row1FR i.e. $row1FRButtonText is selected SECOND!");
                              if(checkMatching(row1ENGButtonText, row1FRButtonText, "ENG")) {
                                // row1ENG and row1FR matched!
                                row1ENGButtonCorrectlyMatched=true;
                                row1FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                                print("$row1ENGButtonText and $row1FRButtonText are a match!");
                              }
                              else {
                                // row1ENG and row1FR DID NOT MATCH!
                                row1ENGButtonIncorrectlyMatched=true;
                                row1FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                print("$row1ENGButtonText and $row1FRButtonText are NOT a match!");
                                print("TIME FOR A NEW CHANGE!");
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row1ENGButtonIncorrectlyMatched=false;
                                    row1FRButtonIncorrectlyMatched=false;
                                    print("NEW CHANGE OVER, WE'RE BACK TO THE OLD WAYS!");
                                    row1ENGButtonSelected=false;
                                    row1FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row2FRButtonCorrectlyMatched==false && row2FRButtonSelected==true) {
                              if(checkMatching(row1ENGButtonText, row2FRButtonText, "ENG")) {
                                // row1ENG and row2FR matched!
                                row1ENGButtonCorrectlyMatched=true;
                                row2FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row1ENG and row2FR DID NOT MATCH!
                                row1ENGButtonIncorrectlyMatched=true;
                                row2FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row1ENGButtonIncorrectlyMatched=false;
                                    row2FRButtonIncorrectlyMatched=false;
                                    row1ENGButtonSelected=false;
                                    row2FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row3FRButtonCorrectlyMatched==false && row3FRButtonSelected==true) {
                              if(checkMatching(row1ENGButtonText, row3FRButtonText, "ENG")) {
                                // row1ENG and row3FR matched!
                                row1ENGButtonCorrectlyMatched=true;
                                row3FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row1ENG and row3FR DID NOT MATCH!
                                row1ENGButtonIncorrectlyMatched=true;
                                row3FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row1ENGButtonIncorrectlyMatched=false;
                                    row3FRButtonIncorrectlyMatched=false;
                                    row1ENGButtonSelected=false;
                                    row3FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row4FRButtonCorrectlyMatched==false && row4FRButtonSelected==true) {
                              if(checkMatching(row1ENGButtonText, row4FRButtonText, "ENG")) {
                                // row1ENG and row4FR matched!
                                row1ENGButtonCorrectlyMatched=true;
                                row4FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row1ENG and row4FR DID NOT MATCH!
                                row1ENGButtonIncorrectlyMatched=true;
                                row4FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row1ENGButtonIncorrectlyMatched=false;
                                    row4FRButtonIncorrectlyMatched=false;
                                    row1ENGButtonSelected=false;
                                    row4FRButtonSelected=false;
                                  });
                                });
                              }
                            }
                          } // if(row1ENGButtonSelected==true)

                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: row1ENGButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      ),
                      child: CustomTextToDisplayOnButton(textToDisplay: listOfDisplayedWordPairs[1].wordENG),
                    ),
                  ),
                ),

                // row1FR
                // FRENCH WORD BUTTON--------------------------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: row1FRButtonIncorrectlyMatched ? wordButtonMatched(row1FRButtonText, false) : row1FRButtonCorrectlyMatched ? wordButtonMatched(row1FRButtonText, true) : Container(
                    // ADDING DYNAMIC SIZING
                    //height: 85.0,
                    height: MediaQuery.sizeOf(context).height*0.08, // very slightly less than 85.0 but close enough
                    //width: 175.0,
                    width: MediaQuery.sizeOf(context).width*0.42,
                    decoration: BoxDecoration(
                      color: row1FRButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: row1FRButtonSelected ? selectedWordButtonBorderColor : deselectedWordButtonBorderColor,
                          width: 6,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {

                        FlutterRingtonePlayer().play(fromAsset: "assets/audios/MTW_fr_audio/${row1FRButtonText.toUpperCase()}.mp3");

                        setState(() {
                          row1FRButtonSelected=!row1FRButtonSelected;

                          if(row1FRButtonSelected) {

                            // deselect every other button in the same language column
                            row0FRButtonSelected=false;
                            row2FRButtonSelected=false;
                            row3FRButtonSelected=false;
                            row4FRButtonSelected=false;

                            print("\nrow1FR i.e. $row1FRButtonText is selected FIRST!");

                            // now check for the buttons of the other language column
                            if(row0ENGButtonCorrectlyMatched==false && row0ENGButtonSelected==true) {
                              print("row0ENG i.e. $row0ENGButtonText is selected SECOND!");
                              if(checkMatching(row1FRButtonText, row0ENGButtonText, "FR")) {
                                // row1FR and row0ENG matched!
                                row1FRButtonCorrectlyMatched=true;
                                row0ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                                print("$row1FRButtonText and $row0ENGButtonText are a match!");
                              }
                              else {
                                // row1FR and row0ENG DID NOT MATCH!
                                row1FRButtonIncorrectlyMatched=true;
                                row0ENGButtonIncorrectlyMatched=true;
                                print("$row1FRButtonText and $row0ENGButtonText are NOT a match!");
                                print("TIME FOR A NEW CHANGE!");
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row1FRButtonIncorrectlyMatched=false;
                                    row0ENGButtonIncorrectlyMatched=false;
                                    print("NEW CHANGE OVER, WE'RE BACK TO THE OLD WAYS!");
                                    row1FRButtonSelected=false;
                                    row0ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row1ENGButtonCorrectlyMatched==false && row1ENGButtonSelected==true) {
                              print("row1ENG i.e. $row1ENGButtonText is selected SECOND!");
                              if(checkMatching(row1FRButtonText, row1ENGButtonText, "FR")) {
                                // row1FR and row1ENG matched!
                                row1FRButtonCorrectlyMatched=true;
                                row1ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                                print("$row1FRButtonText and $row1ENGButtonText are a match!");
                              }
                              else {
                                // row1FR and row1ENG DID NOT MATCH!
                                row1FRButtonIncorrectlyMatched=true;
                                row1ENGButtonIncorrectlyMatched=true;
                                print("$row1FRButtonText and $row1ENGButtonText are NOT a match!");
                                print("TIME FOR A NEW CHANGE!");
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row1FRButtonIncorrectlyMatched=false;
                                    row1ENGButtonIncorrectlyMatched=false;
                                    print("NEW CHANGE OVER, WE'RE BACK TO THE OLD WAYS!");
                                    row1FRButtonSelected=false;
                                    row1ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row2ENGButtonCorrectlyMatched==false && row2ENGButtonSelected==true) {
                              if(checkMatching(row1FRButtonText, row2ENGButtonText, "FR")) {
                                // row1FR and row2ENG matched!
                                row1FRButtonCorrectlyMatched=true;
                                row2ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row1FR and row2ENG DID NOT MATCH!
                                row1FRButtonIncorrectlyMatched=true;
                                row2ENGButtonIncorrectlyMatched=true;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row1FRButtonIncorrectlyMatched=false;
                                    row2ENGButtonIncorrectlyMatched=false;
                                    row1FRButtonSelected=false;
                                    row2ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row3ENGButtonCorrectlyMatched==false && row3ENGButtonSelected==true) {
                              if(checkMatching(row1FRButtonText, row3ENGButtonText, "FR")) {
                                // row1FR and row3ENG matched!
                                row1FRButtonCorrectlyMatched=true;
                                row3ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row1FR and row3ENG DID NOT MATCH!
                                row1FRButtonIncorrectlyMatched=true;
                                row3ENGButtonIncorrectlyMatched=true;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row1FRButtonIncorrectlyMatched=false;
                                    row3ENGButtonIncorrectlyMatched=false;
                                    row1FRButtonSelected=false;
                                    row3ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row4ENGButtonCorrectlyMatched==false && row4ENGButtonSelected==true) {
                              if(checkMatching(row1FRButtonText, row4ENGButtonText, "FR")) {
                                // row1FR and row4ENG matched!
                                row1FRButtonCorrectlyMatched=true;
                                row4ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row1FR and row4ENG DID NOT MATCH!
                                row1FRButtonIncorrectlyMatched=true;
                                row4ENGButtonIncorrectlyMatched=true;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row1FRButtonIncorrectlyMatched=false;
                                    row4ENGButtonIncorrectlyMatched=false;
                                    row1FRButtonSelected=false;
                                    row4ENGButtonSelected=false;
                                  });
                                });
                              }
                            }
                          } // if(row1FRButtonSelected==true)

                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: row1FRButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      ),
                      child: CustomTextToDisplayOnButton(textToDisplay: listOfDisplayedWordPairs[1].wordFR),
                    ),
                  ),
                ),

              ],
            ),

            // ROW 2---------------------------------------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // row2ENG
                // ENGLISH WORD BUTTON-------------------------------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: row2ENGButtonIncorrectlyMatched ? wordButtonMatched(row2ENGButtonText, false) : row2ENGButtonCorrectlyMatched ? wordButtonMatched(row2ENGButtonText, true) : Container(
                    // ADDING DYNAMIC SIZING
                    //height: 85.0,
                    height: MediaQuery.sizeOf(context).height*0.08, // very slightly less than 85.0 but close enough
                    //width: 175.0,
                    width: MediaQuery.sizeOf(context).width*0.42,
                    decoration: BoxDecoration(
                      color: row2ENGButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: row2ENGButtonSelected ? selectedWordButtonBorderColor : deselectedWordButtonBorderColor,
                          width: 6,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {

                        FlutterRingtonePlayer().play(fromAsset: "assets/audios/MTW_eng_audio/${row2ENGButtonText.toUpperCase()}.mp3");

                        setState(() {
                          row2ENGButtonSelected=!row2ENGButtonSelected;

                          if(row2ENGButtonSelected==true) {

                            // deselect every other button in the same language column
                            row0ENGButtonSelected=false;
                            row1ENGButtonSelected=false;
                            row3ENGButtonSelected=false;
                            row4ENGButtonSelected=false;

                            if(row0FRButtonCorrectlyMatched==false && row0FRButtonSelected==true) {
                              if(checkMatching(row2ENGButtonText, row0FRButtonText, "ENG")) {
                                // row2ENG and row2FR matched!
                                row2ENGButtonCorrectlyMatched=true;
                                row0FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row2ENG and row0FR DID NOT MATCH!
                                row2ENGButtonIncorrectlyMatched=true;
                                row0FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row2ENGButtonIncorrectlyMatched=false;
                                    row0FRButtonIncorrectlyMatched=false;
                                    row2ENGButtonSelected=false;
                                    row0FRButtonSelected=false;
                                  });
                                });
                              }
                            }
                          }

                          if(row2ENGButtonSelected==true) {

                            // deselect every other button in the same language column
                            row0ENGButtonSelected=false;
                            row1ENGButtonSelected=false;
                            row3ENGButtonSelected=false;
                            row4ENGButtonSelected=false;

                            if(row0FRButtonCorrectlyMatched==false && row0FRButtonSelected==true) {
                              if(checkMatching(row2ENGButtonText, row0FRButtonText, "ENG")) {
                                // row1ENG and row2FR matched!
                                row2ENGButtonCorrectlyMatched=true;
                                row0FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row2ENG and row0FR DID NOT MATCH!
                                row2ENGButtonIncorrectlyMatched=true;
                                row0FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row2ENGButtonIncorrectlyMatched=false;
                                    row0FRButtonIncorrectlyMatched=false;
                                    row2ENGButtonSelected=false;
                                    row0FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row1FRButtonCorrectlyMatched==false && row1FRButtonSelected==true) {
                              if(checkMatching(row2ENGButtonText, row1FRButtonText, "ENG")) {
                                // row1ENG and row1FR matched!
                                row2ENGButtonCorrectlyMatched=true;
                                row1FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row2ENG and row1FR DID NOT MATCH!
                                row2ENGButtonIncorrectlyMatched=true;
                                row1FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row2ENGButtonIncorrectlyMatched=false;
                                    row1FRButtonIncorrectlyMatched=false;
                                    row2ENGButtonSelected=false;
                                    row1FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row2FRButtonCorrectlyMatched==false && row2FRButtonSelected==true) {
                              if(checkMatching(row2ENGButtonText, row2FRButtonText, "ENG")) {
                                // row1ENG and row2FR matched!
                                row2ENGButtonCorrectlyMatched=true;
                                row2FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row2ENG and row2FR DID NOT MATCH!
                                row2ENGButtonIncorrectlyMatched=true;
                                row2FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row2ENGButtonIncorrectlyMatched=false;
                                    row2FRButtonIncorrectlyMatched=false;
                                    row2ENGButtonSelected=false;
                                    row2FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row3FRButtonCorrectlyMatched==false && row3FRButtonSelected==true) {
                              if(checkMatching(row2ENGButtonText, row3FRButtonText, "ENG")) {
                                // row1ENG and row3FR matched!
                                row2ENGButtonCorrectlyMatched=true;
                                row3FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row2ENG and row3FR DID NOT MATCH!
                                row2ENGButtonIncorrectlyMatched=true;
                                row3FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row2ENGButtonIncorrectlyMatched=false;
                                    row3FRButtonIncorrectlyMatched=false;
                                    row2ENGButtonSelected=false;
                                    row3FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row1FRButtonCorrectlyMatched==false && row4FRButtonSelected==true) {
                              if(checkMatching(row2ENGButtonText, row4FRButtonText, "ENG")) {
                                // row1ENG and row4FR matched!
                                row2ENGButtonCorrectlyMatched=true;
                                row4FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row2ENG and row4FR DID NOT MATCH!
                                row2ENGButtonIncorrectlyMatched=true;
                                row4FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row2ENGButtonIncorrectlyMatched=false;
                                    row4FRButtonIncorrectlyMatched=false;
                                    row2ENGButtonSelected=false;
                                    row4FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: row2ENGButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      ),
                      child: CustomTextToDisplayOnButton(textToDisplay: listOfDisplayedWordPairs[2].wordENG),
                    ),
                  ),
                ),

                // row2FR
                // FRENCH WORD BUTTON--------------------------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: row2FRButtonIncorrectlyMatched ? wordButtonMatched(row2FRButtonText, false) : row2FRButtonCorrectlyMatched ? wordButtonMatched(row2FRButtonText, true) : Container(
                    // ADDING DYNAMIC SIZING
                    //height: 85.0,
                    height: MediaQuery.sizeOf(context).height*0.08, // very slightly less than 85.0 but close enough
                    //width: 175.0,
                    width: MediaQuery.sizeOf(context).width*0.42,
                    decoration: BoxDecoration(
                      color: row2FRButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: row2FRButtonSelected ? selectedWordButtonBorderColor : deselectedWordButtonBorderColor,
                          width: 6,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {

                        FlutterRingtonePlayer().play(fromAsset: "assets/audios/MTW_fr_audio/${row2FRButtonText.toUpperCase()}.mp3");

                        setState(() {
                          row2FRButtonSelected=!row2FRButtonSelected;

                          if(row2FRButtonSelected==true) {

                            // deselect every other button in the same language column
                            row0FRButtonSelected=false;
                            row1FRButtonSelected=false;
                            row3FRButtonSelected=false;
                            row4FRButtonSelected=false;

                            if(row0ENGButtonCorrectlyMatched==false && row0ENGButtonSelected==true) {
                              if(checkMatching(row2FRButtonText, row0ENGButtonText, "FR")) {
                               // row2FR and row0ENG matched!
                               row2FRButtonCorrectlyMatched=true;
                               row0ENGButtonCorrectlyMatched=true;
                               numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row2FR and row0ENG DID NOT MATCH!
                                row2FRButtonIncorrectlyMatched=true;
                                row0ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row2FRButtonIncorrectlyMatched=false;
                                    row0ENGButtonIncorrectlyMatched=false;
                                    row2FRButtonSelected=false;
                                    row0ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row1ENGButtonCorrectlyMatched==false && row1ENGButtonSelected==true) {
                              if(checkMatching(row2FRButtonText, row1ENGButtonText, "FR")) {
                                // row2FR and row1ENG matched!
                                row2FRButtonCorrectlyMatched=true;
                                row1ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row2FR and row1ENG DID NOT MATCH!
                                row2FRButtonIncorrectlyMatched=true;
                                row1ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row2FRButtonIncorrectlyMatched=false;
                                    row1ENGButtonIncorrectlyMatched=false;
                                    row2FRButtonSelected=false;
                                    row1ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row2ENGButtonCorrectlyMatched==false && row2ENGButtonSelected==true) {
                              if(checkMatching(row2FRButtonText, row2ENGButtonText, "FR")) {
                                // row2FR and row2ENG matched!
                                row2FRButtonCorrectlyMatched=true;
                                row2ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row2FR and row2ENG DID NOT MATCH!
                                row2FRButtonIncorrectlyMatched=true;
                                row2ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row2FRButtonIncorrectlyMatched=false;
                                    row2ENGButtonIncorrectlyMatched=false;
                                    row2FRButtonSelected=false;
                                    row2ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row3ENGButtonCorrectlyMatched==false && row3ENGButtonSelected==true) {
                              if(checkMatching(row2FRButtonText, row3ENGButtonText, "FR")) {
                                // row2FR and row3ENG matched!
                                row2FRButtonCorrectlyMatched=true;
                                row3ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row2FR and row3ENG DID NOT MATCH!
                                row2FRButtonIncorrectlyMatched=true;
                                row3ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row2FRButtonIncorrectlyMatched=false;
                                    row3ENGButtonIncorrectlyMatched=false;
                                    row2FRButtonSelected=false;
                                    row3ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row4ENGButtonCorrectlyMatched==false && row4ENGButtonSelected==true) {
                              if(checkMatching(row2FRButtonText, row4ENGButtonText, "FR")) {
                                // row2FR and row4ENG matched!
                                row2FRButtonCorrectlyMatched=true;
                                row4ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row2FR and row4ENG DID NOT MATCH!
                                row2FRButtonIncorrectlyMatched=true;
                                row4ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row2FRButtonIncorrectlyMatched=false;
                                    row4ENGButtonIncorrectlyMatched=false;
                                    row2FRButtonSelected=false;
                                    row4ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: row2FRButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      ),
                      child: CustomTextToDisplayOnButton(textToDisplay: listOfDisplayedWordPairs[2].wordFR),
                    ),
                  ),
                ),

              ],
            ),

            // ROW 3---------------------------------------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // row3ENG
                // ENGLISH WORD BUTTON--------------------------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: row3ENGButtonIncorrectlyMatched ? wordButtonMatched(row3ENGButtonText, false) : row3ENGButtonCorrectlyMatched ? wordButtonMatched(row3ENGButtonText, true) : Container(
                    // ADDING DYNAMIC SIZING
                    //height: 85.0,
                    height: MediaQuery.sizeOf(context).height*0.08, // very slightly less than 85.0 but close enough
                    //width: 175.0,
                    width: MediaQuery.sizeOf(context).width*0.42,
                    decoration: BoxDecoration(
                      color: row3ENGButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: row3ENGButtonSelected ? selectedWordButtonBorderColor : deselectedWordButtonBorderColor,
                          width: 6,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {

                        FlutterRingtonePlayer().play(fromAsset: "assets/audios/MTW_eng_audio/${row3ENGButtonText.toUpperCase()}.mp3");

                        setState(() {
                          row3ENGButtonSelected=!row3ENGButtonSelected;

                          if(row3ENGButtonSelected==true) {

                            // deselect every other button in the same language column
                            row0ENGButtonSelected=false;
                            row1ENGButtonSelected=false;
                            row2ENGButtonSelected=false;
                            row4ENGButtonSelected=false;

                            if(row0FRButtonCorrectlyMatched==false && row0FRButtonSelected==true) {
                              if(checkMatching(row3ENGButtonText, row0FRButtonText, "ENG")) {
                                // row3ENG and row2FR matched!
                                row3ENGButtonCorrectlyMatched=true;
                                row0FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row3ENG and row0FR DID NOT MATCH!
                                row3ENGButtonIncorrectlyMatched=true;
                                row0FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row3ENGButtonIncorrectlyMatched=false;
                                    row0FRButtonIncorrectlyMatched=false;
                                    row3ENGButtonSelected=false;
                                    row0FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row1FRButtonCorrectlyMatched==false && row1FRButtonSelected==true) {
                              if(checkMatching(row3ENGButtonText, row1FRButtonText, "ENG")) {
                                // row3ENG and row1FR matched!
                                row3ENGButtonCorrectlyMatched=true;
                                row1FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row3ENG and row1FR DID NOT MATCH!
                                row3ENGButtonIncorrectlyMatched=true;
                                row1FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row3ENGButtonIncorrectlyMatched=false;
                                    row1FRButtonIncorrectlyMatched=false;
                                    row3ENGButtonSelected=false;
                                    row1FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row2FRButtonCorrectlyMatched==false && row2FRButtonSelected==true) {
                              if(checkMatching(row3ENGButtonText, row2FRButtonText, "ENG")) {
                                // row3ENG and row2FR matched!
                                row3ENGButtonCorrectlyMatched=true;
                                row2FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row3ENG and row2FR DID NOT MATCH!
                                row3ENGButtonIncorrectlyMatched=true;
                                row2FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row3ENGButtonIncorrectlyMatched=false;
                                    row2FRButtonIncorrectlyMatched=false;
                                    row3ENGButtonSelected=false;
                                    row2FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row3FRButtonCorrectlyMatched==false && row3FRButtonSelected==true) {
                              if(checkMatching(row3ENGButtonText, row3FRButtonText, "ENG")) {
                                // row3ENG and row3FR matched!
                                row3ENGButtonCorrectlyMatched=true;
                                row3FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row3ENG and row3FR DID NOT MATCH!
                                row3ENGButtonIncorrectlyMatched=true;
                                row3FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row3ENGButtonIncorrectlyMatched=false;
                                    row3FRButtonIncorrectlyMatched=false;
                                    row3ENGButtonSelected=false;
                                    row3FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row4FRButtonCorrectlyMatched==false && row4FRButtonSelected==true) {
                              if(checkMatching(row3ENGButtonText, row1FRButtonText, "ENG")) {
                                // row3ENG and row4FR matched!
                                row3ENGButtonCorrectlyMatched=true;
                                row4FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row3ENG and row4FR DID NOT MATCH!
                                row3ENGButtonIncorrectlyMatched=true;
                                row4FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row3ENGButtonIncorrectlyMatched=false;
                                    row4FRButtonIncorrectlyMatched=false;
                                    row3ENGButtonSelected=false;
                                    row4FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: row3ENGButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      ),
                      child: CustomTextToDisplayOnButton(textToDisplay: listOfDisplayedWordPairs[3].wordENG),
                    ),
                  ),
                ),

                // row3FR
                // FRENCH WORD BUTTON------------------------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: row3FRButtonIncorrectlyMatched ? wordButtonMatched(row3FRButtonText, false) : row3FRButtonCorrectlyMatched ? wordButtonMatched(row3FRButtonText, true) : Container(
                    // ADDING DYNAMIC SIZING
                    //height: 85.0,
                    height: MediaQuery.sizeOf(context).height*0.08, // very slightly less than 85.0 but close enough
                    //width: 175.0,
                    width: MediaQuery.sizeOf(context).width*0.42,
                    decoration: BoxDecoration(
                      color: row3FRButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: row3FRButtonSelected ? selectedWordButtonBorderColor : deselectedWordButtonBorderColor,
                          width: 6,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {

                        FlutterRingtonePlayer().play(fromAsset: "assets/audios/MTW_fr_audio/${row3FRButtonText.toUpperCase()}.mp3");

                        setState(() {
                          row3FRButtonSelected=!row3FRButtonSelected;

                          if(row3FRButtonSelected==true) {

                            // deselect every other button in the same language column
                            row0FRButtonSelected=false;
                            row1FRButtonSelected=false;
                            row2FRButtonSelected=false;
                            row4FRButtonSelected=false;

                            if(row0ENGButtonCorrectlyMatched==false && row0ENGButtonSelected==true) {
                              if(checkMatching(row3FRButtonText, row0ENGButtonText, "FR")) {
                                // row3FR and row0ENG matched!
                                row3FRButtonCorrectlyMatched=true;
                                row0ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row3FR and row0ENG DID NOT MATCH!
                                row3FRButtonIncorrectlyMatched=true;
                                row0ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row3FRButtonIncorrectlyMatched=false;
                                    row0ENGButtonIncorrectlyMatched=false;
                                    row3FRButtonSelected=false;
                                    row0ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row1ENGButtonCorrectlyMatched==false && row1ENGButtonSelected==true) {
                              if(checkMatching(row3FRButtonText, row1ENGButtonText, "FR")) {
                                // row3FR and row1ENG matched!
                                row3FRButtonCorrectlyMatched=true;
                                row1ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row3FR and row1ENG DID NOT MATCH!
                                row3FRButtonIncorrectlyMatched=true;
                                row1ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row3FRButtonIncorrectlyMatched=false;
                                    row1ENGButtonIncorrectlyMatched=false;
                                    row3FRButtonSelected=false;
                                    row1ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row2ENGButtonCorrectlyMatched==false && row2ENGButtonSelected==true) {
                              if(checkMatching(row3FRButtonText, row2ENGButtonText, "FR")) {
                                // row3FR and row2ENG matched!
                                row3FRButtonCorrectlyMatched=true;
                                row2ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row3FR and row2ENG DID NOT MATCH!
                                row3FRButtonIncorrectlyMatched=true;
                                row2ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row3FRButtonIncorrectlyMatched=false;
                                    row2ENGButtonIncorrectlyMatched=false;
                                    row3FRButtonSelected=false;
                                    row2ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row3ENGButtonCorrectlyMatched==false && row3ENGButtonSelected==true) {
                              if(checkMatching(row3FRButtonText, row3ENGButtonText, "FR")) {
                                // row3FR and row3ENG matched!
                                row3FRButtonCorrectlyMatched=true;
                                row3ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row3FR and row3ENG DID NOT MATCH!
                                row3FRButtonIncorrectlyMatched=true;
                                row3ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row3FRButtonIncorrectlyMatched=false;
                                    row3ENGButtonIncorrectlyMatched=false;
                                    row3FRButtonSelected=false;
                                    row3ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row4ENGButtonCorrectlyMatched==false && row4ENGButtonSelected==true) {
                              if(checkMatching(row3FRButtonText, row4ENGButtonText, "FR")) {
                                // row3FR and row4ENG matched!
                                row3FRButtonCorrectlyMatched=true;
                                row4ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row3FR and row4ENG DID NOT MATCH!
                                row3FRButtonIncorrectlyMatched=true;
                                row4ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row3FRButtonIncorrectlyMatched=false;
                                    row4ENGButtonIncorrectlyMatched=false;
                                    row3FRButtonSelected=false;
                                    row4ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: row3FRButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      ),
                      child: CustomTextToDisplayOnButton(textToDisplay: listOfDisplayedWordPairs[3].wordFR),
                    ),
                  ),
                ),

              ],
            ),

            // ROW 4--------------------------------------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // row4ENG
                // ENGLISH WORD BUTTON---------------------------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: row4ENGButtonIncorrectlyMatched ? wordButtonMatched(row4ENGButtonText, false) : row4ENGButtonCorrectlyMatched ? wordButtonMatched(row4ENGButtonText, true) : Container(
                    // ADDING DYNAMIC SIZING
                    //height: 85.0,
                    height: MediaQuery.sizeOf(context).height*0.08, // very slightly less than 85.0 but close enough
                    //width: 175.0,
                    width: MediaQuery.sizeOf(context).width*0.42,
                    decoration: BoxDecoration(
                      color: row4ENGButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: row4ENGButtonSelected ? selectedWordButtonBorderColor : deselectedWordButtonBorderColor,
                          width: 6,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {

                        FlutterRingtonePlayer().play(fromAsset: "assets/audios/MTW_eng_audio/${row4ENGButtonText.toUpperCase()}.mp3");

                        setState(() {
                          row4ENGButtonSelected=!row4ENGButtonSelected;

                          if(row4ENGButtonSelected==true) {

                            // deselect every other button in the same language column
                            row0ENGButtonSelected=false;
                            row1ENGButtonSelected=false;
                            row2ENGButtonSelected=false;
                            row3ENGButtonSelected=false;

                            if(row0FRButtonCorrectlyMatched==false && row0FRButtonSelected==true) {
                              if(checkMatching(row4ENGButtonText, row0FRButtonText, "ENG")) {
                                // row4ENG and row0FR matched!
                                row4ENGButtonCorrectlyMatched=true;
                                row0FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row4ENG and row0FR DID NOT MATCH!
                                row4ENGButtonIncorrectlyMatched=true;
                                row0FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row4ENGButtonIncorrectlyMatched=false;
                                    row0FRButtonIncorrectlyMatched=false;
                                    row4ENGButtonSelected=false;
                                    row0FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row1FRButtonCorrectlyMatched==false && row1FRButtonSelected==true) {
                              if(checkMatching(row4ENGButtonText, row1FRButtonText, "ENG")) {
                                // row4ENG and row1FR matched!
                                row4ENGButtonCorrectlyMatched=true;
                                row1FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row4ENG and row1FR DID NOT MATCH!
                                row4ENGButtonIncorrectlyMatched=true;
                                row1FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row4ENGButtonIncorrectlyMatched=false;
                                    row1FRButtonIncorrectlyMatched=false;
                                    row4ENGButtonSelected=false;
                                    row1FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row2FRButtonCorrectlyMatched==false && row2FRButtonSelected==true) {
                              if(checkMatching(row4ENGButtonText, row2FRButtonText, "ENG")) {
                                // row4ENG and row2FR matched!
                                row4ENGButtonCorrectlyMatched=true;
                                row2FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row4ENG and row2FR DID NOT MATCH!
                                row4ENGButtonIncorrectlyMatched=true;
                                row2FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row4ENGButtonIncorrectlyMatched=false;
                                    row2FRButtonIncorrectlyMatched=false;
                                    row4ENGButtonSelected=false;
                                    row2FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row3FRButtonCorrectlyMatched==false && row3FRButtonSelected==true) {
                              if(checkMatching(row4ENGButtonText, row3FRButtonText, "ENG")) {
                                // row4ENG and row3FR matched!
                                row4ENGButtonCorrectlyMatched=true;
                                row3FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row4ENG and row3FR DID NOT MATCH!
                                row4ENGButtonIncorrectlyMatched=true;
                                row3FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row4ENGButtonIncorrectlyMatched=false;
                                    row3FRButtonIncorrectlyMatched=false;
                                    row4ENGButtonSelected=false;
                                    row3FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row4FRButtonCorrectlyMatched==false && row4FRButtonSelected==true) {
                              if(checkMatching(row4ENGButtonText, row4FRButtonText, "ENG")) {
                                // row4ENG and row4FR matched!
                                row4ENGButtonCorrectlyMatched=true;
                                row4FRButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row4ENG and row4FR DID NOT MATCH!
                                row4ENGButtonIncorrectlyMatched=true;
                                row4FRButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row4ENGButtonIncorrectlyMatched=false;
                                    row4FRButtonIncorrectlyMatched=false;
                                    row4ENGButtonSelected=false;
                                    row4FRButtonSelected=false;
                                  });
                                });
                              }
                            }

                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: row4ENGButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      ),
                      child: CustomTextToDisplayOnButton(textToDisplay: listOfDisplayedWordPairs[4].wordENG),
                    ),
                  ),
                ),

                // row4FR
                // FRENCH WORD BUTTON------------------------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: row4FRButtonIncorrectlyMatched ? wordButtonMatched(row4FRButtonText, false) : row4FRButtonCorrectlyMatched ? wordButtonMatched(row4FRButtonText, true) : Container(
                    // ADDING DYNAMIC SIZING
                    //height: 85.0,
                    height: MediaQuery.sizeOf(context).height*0.08, // very slightly less than 85.0 but close enough
                    //width: 175.0,
                    width: MediaQuery.sizeOf(context).width*0.42,
                    decoration: BoxDecoration(
                      color: row4FRButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: row4FRButtonSelected ? selectedWordButtonBorderColor : deselectedWordButtonBorderColor,
                          width: 6,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {

                        FlutterRingtonePlayer().play(fromAsset: "assets/audios/MTW_fr_audio/${row4FRButtonText.toUpperCase()}.mp3");

                        setState(() {
                          row4FRButtonSelected=!row4FRButtonSelected;

                          if(row4FRButtonSelected==true) {

                            // deselect every other button in the same language column
                            row0FRButtonSelected=false;
                            row1FRButtonSelected=false;
                            row2FRButtonSelected=false;
                            row3FRButtonSelected=false;

                            if(row0ENGButtonCorrectlyMatched==false && row0ENGButtonSelected==true) {
                              if(checkMatching(row4FRButtonText, row0ENGButtonText, "FR")) {
                                // row4FR and row0ENG matched!
                                row4FRButtonCorrectlyMatched=true;
                                row0ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row4FR and row0ENG DID NOT MATCH!
                                row4FRButtonIncorrectlyMatched=true;
                                row0ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row4FRButtonIncorrectlyMatched=false;
                                    row0ENGButtonIncorrectlyMatched=false;
                                    row4FRButtonSelected=false;
                                    row0ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row1ENGButtonCorrectlyMatched==false && row1ENGButtonSelected==true) {
                              if(checkMatching(row4FRButtonText, row1ENGButtonText, "FR")) {
                                // row4FR and row1ENG matched!
                                row4FRButtonCorrectlyMatched=true;
                                row1ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row4FR and row1ENG DID NOT MATCH!
                                row4FRButtonIncorrectlyMatched=true;
                                row1ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row4FRButtonIncorrectlyMatched=false;
                                    row1ENGButtonIncorrectlyMatched=false;
                                    row4FRButtonSelected=false;
                                    row1ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row2ENGButtonCorrectlyMatched==false && row2ENGButtonSelected==true) {
                              if(checkMatching(row4FRButtonText, row2ENGButtonText, "FR")) {
                                // row4FR and row2ENG matched!
                                row4FRButtonCorrectlyMatched=true;
                                row2ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row4FR and row2ENG DID NOT MATCH!
                                row4FRButtonIncorrectlyMatched=true;
                                row2ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row4FRButtonIncorrectlyMatched=false;
                                    row2ENGButtonIncorrectlyMatched=false;
                                    row4FRButtonSelected=false;
                                    row2ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row3ENGButtonCorrectlyMatched==false && row3ENGButtonSelected==true) {
                              if(checkMatching(row4FRButtonText, row3ENGButtonText, "FR")) {
                                // row4FR and row3ENG matched!
                                row4FRButtonCorrectlyMatched=true;
                                row3ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row4FR and row3ENG DID NOT MATCH!
                                row4FRButtonIncorrectlyMatched=true;
                                row3ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row4FRButtonIncorrectlyMatched=false;
                                    row3ENGButtonIncorrectlyMatched=false;
                                    row4FRButtonSelected=false;
                                    row3ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                            else if(row4ENGButtonCorrectlyMatched==false && row4ENGButtonSelected==true) {
                              if(checkMatching(row4FRButtonText, row4ENGButtonText, "FR")) {
                                // row4FR and row4ENG matched!
                                row4FRButtonCorrectlyMatched=true;
                                row4ENGButtonCorrectlyMatched=true;
                                numOfWordPairsCorrectlyMatched+=1;
                              }
                              else {
                                // row4FR and row4ENG DID NOT MATCH!
                                row4FRButtonIncorrectlyMatched=true;
                                row4ENGButtonIncorrectlyMatched=true;
                                numOfWordPairsIncorrectlyMatched+=1;
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    row4FRButtonIncorrectlyMatched=false;
                                    row4ENGButtonIncorrectlyMatched=false;
                                    row4FRButtonSelected=false;
                                    row4ENGButtonSelected=false;
                                  });
                                });
                              }
                            }

                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: row4FRButtonSelected ? selectedWordButtonBackgroundColor : deselectedWordButtonBackgroundColor,
                      ),
                      child: CustomTextToDisplayOnButton(textToDisplay: listOfDisplayedWordPairs[4].wordFR),
                    ),
                  ),
                ),

              ],
            ),

            // SOME SHORT REACTION TEXT BASED ON CORRECT/INCORRECT MATCHING-----------------------------------------
            Expanded(
              child: Center(
                child: Text(
                  statementForNumOfCorrectMatchesMade(numOfWordPairsCorrectlyMatched, numOfWordPairMatchesPossible),
                  //_getMessageBasedOnTime(_totalTimeSpent),
                  // skipping the time-spent-on-the-app criteria for now
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // SUBMIT BUTTON-----------------------------------------------------------------------------------------
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    // ADDING DYNAMIC SIZING
                    //height: 80.0, // initially it was 70
                    height: MediaQuery.sizeOf(context).height*0.09,
                    // this is recommended so that the submit button spreads itself according to the screen
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: allowSubmission() ? () {
                        setState(() {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return MyCommonResultPage(
                                    quizAcronym: 'MTW',
                                    value: numOfWordPairsIncorrectlyMatched,
                                    maxValue: numOfWordPairMismatchesPossible,
                                  );
                                }
                            ),
                          );

                        });
                      } : null,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.green.shade900,
                      ),
                      child: const Text(
                          'SUBMIT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
