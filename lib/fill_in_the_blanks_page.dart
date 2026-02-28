import 'package:flutter/material.dart';
import 'common_result_page.dart';
import 'quiz_page.dart';
import 'question_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

bool isAnswered=false;

/*
 This variable is to prevent the user from scrolling to the next page
 using the 'NEXT' button. Unless this variable is true, the 'NEXT'
 button will be disabled.
 */

bool submissionDone=false;

/*
   These functions are to share the value of the boolean variable 'isAnswered'
   across the two widgets: 'SingleQuestionQuizPage' and 'MyTinyQuizApp'.
   */

Future<void> _writeBooleanValue(bool valueToWrite) async { // function can also be _setBooleanValue()
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isAnswered', valueToWrite); // Change 'true' to 'false' for false value
}

/*
// it's not referenced anywhere
Future<bool> _readBooleanValue() async { // function can also be _getBooleanValue()
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isAnswered') ?? false; // Default to false if key not found
}
*/

Future<void> _writeBooleanValue1(bool valueToWrite) async { // function can also be _setBooleanValue()
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('submissionDone', valueToWrite); // Change 'true' to 'false' for false value
}

/*
// it's not referenced anywhere
Future<bool> _readBooleanValue1() async { // function can also be _getBooleanValue()
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('submissionDone') ?? false; // Default to false if key not found
}
*/

int totalScore=0;
// for now it's global, later I'll move it somewhere else later if I can

//---------------------------MY CUSTOM CIRCLE AVATAR---------------------------------------------------------------------------------------------------------------
class MyCustomCircleAvatar extends StatelessWidget {
  final String optionLetter;
  final Color optionBackgroundColor;

  const MyCustomCircleAvatar({super.key, required this.optionLetter, required this.optionBackgroundColor});

  @override
  Widget build(BuildContext context) {

    return CircleAvatar(
      backgroundColor: optionBackgroundColor,
      child: Text(
        optionLetter,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

//--------------------------MY SINGLE QUESTION QUIZ PAGE----------------------------------------------------------------------------------------------------------
class SingleQuestionQuizPage extends StatefulWidget {
  final String questionText;
  final String optionAText;
  final String optionBText;
  final String optionCText;
  final String optionDText;
  final String correctAnswerText;

  const SingleQuestionQuizPage({
    super.key,
    required this.questionText,
    required this.optionAText,
    required this.optionBText,
    required this.optionCText,
    required this.optionDText,
    required this.correctAnswerText,
  });

  @override
  State<SingleQuestionQuizPage> createState() => _SingleQuestionQuizPageState();
}

class _SingleQuestionQuizPageState extends State<SingleQuestionQuizPage> {

  /*
   These functions are to share the value of the boolean variable 'isAnswered'
   across the two widgets: 'SingleQuestionQuizPage' and 'MyTinyQuizApp'.
   */

  /*
  Future<void> _writeBooleanValue(bool valueToWrite) async { // function can also be _setBooleanValue()
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAnswered', valueToWrite); // Change 'true' to 'false' for false value
  }

  Future<bool> _readBooleanValue() async { // function can also be _getBooleanValue()
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAnswered') ?? false; // Default to false if key not found
  }
   */

  //var isAnswered=false;
  // _writeBooleanValue(false); // I can't call any functions here?

  bool _optionAHasBeenPressed=false;
  bool _optionBHasBeenPressed=false;
  bool _optionCHasBeenPressed=false;
  bool _optionDHasBeenPressed=false;

  var blankToBeFilled="_________";

  // Button colors for different scenarios
  Color selectedButtonBorderColor=Colors.blue.shade100;
  Color selectedButtonBackgroundColor=Colors.indigo.shade900;
  Color selectedButtonTextColor=Colors.white;

  Color deselectedButtonBorderColor=Colors.black;
  Color deselectedButtonBackgroundColor=Colors.white;
  Color deselectedButtonTextColor=Colors.black;

  Color correctButtonBorderColor=Colors.green.shade100;
  Color correctButtonBackgroundColor=Colors.green.shade900;
  Color correctButtonTextColor=Colors.white;

  Color incorrectButtonBorderColor=Colors.redAccent.shade100;
  Color incorrectButtonBackgroundColor=Colors.red.shade900;
  Color incorrectButtonTextColor=Colors.white;

  // Button color variables to be assigned the color variables for different scenarios
  late Color buttonBorderColor=deselectedButtonBorderColor;
  late Color buttonBackgroundColor=deselectedButtonBackgroundColor;
  late Color buttonTextColor=deselectedButtonTextColor;

  bool makeSubmission=false;

  int score=0;
  bool isScoreUpdated=false;
  /*
  to check if the score is updated (should be updated only once)
  needed this variable because the function below is called several
  times and the score gets updated everytime it is called
   */

  String optionTextToBeSubmitted="";

  bool isThisAnswerCorrect(String answerToCheck)
  {
    if(answerToCheck==widget.correctAnswerText) {
      return true;
    } // return true if the answer is correct

    else {
      return false;
    } // return false if the answer is incorrect
  }

  Row ElevatedButtonShowingResult(String optionText, bool optionHasBeenPressedVariable)
  {
    return Row(
      children: [

        ElevatedButton(
          onPressed: () {
            // option A result
          },
          style: ElevatedButton.styleFrom(
            side: BorderSide(
              color: isThisAnswerCorrect(optionText) ? correctButtonBorderColor : incorrectButtonBorderColor,
              width: 1.0,
            ),
            backgroundColor: isThisAnswerCorrect(optionText) ? correctButtonBackgroundColor : incorrectButtonBackgroundColor,
          ), // ElevatedButton.styleFrom
          child: Text(
            optionText,
            style: TextStyle(
              color: isThisAnswerCorrect(optionText) ? correctButtonTextColor : incorrectButtonTextColor,
              fontSize: 20.0,
            ),
          ),
        ),

        // The tick or cross is only displayed for the option that was selected (and submitted) as the answer.
        Visibility(
          visible: optionHasBeenPressedVariable? true : false,
          child: Icon(
            isThisAnswerCorrect(optionText)? Icons.check : Icons.close,
            color: isThisAnswerCorrect(optionText)? Colors.green.shade900 : Colors.red.shade900,
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[

          // question text
          Container(
            width: double.infinity,
            alignment: Alignment.topLeft,
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: widget.questionText,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                    ),
                  ),
                  TextSpan(
                    text: '$blankToBeFilled!\n',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(
                    text: '(Fill in the blank)\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Container containing only the option buttons
          Column(
            children: [
              // OPTION A
              Row(
                children: <Widget>[

                  MyCustomCircleAvatar(
                    optionLetter: 'A',
                    optionBackgroundColor: Colors.indigo.shade900,
                  ),

                  const Text('  '),

                  // ELEVATED BUTTON FOR OPTION A
                  Container(
                    child: makeSubmission? ElevatedButtonShowingResult(widget.optionAText, _optionAHasBeenPressed) : ElevatedButton(
                      onPressed: () {

                        String textToPrint=((((widget.optionAText).toUpperCase()).replaceAll(", ", "_")).replaceAll(" ", "_")).replaceAll("'", "_");

                        FlutterRingtonePlayer().play(fromAsset: "assets/audios/FITB_options_audio/$textToPrint.mp3");

                        // user pressed option A
                        setState(() {
                          _optionAHasBeenPressed=!_optionAHasBeenPressed;

                          /*
                          Here, I used two 'if' blocks because if I had used 'else' block for the statement:
                          blankToBeFilled="_________";
                          then, if the first 'if' block is true then the 'else' block will not run.
                           */

                          if(_optionAHasBeenPressed==true)
                          {
                            blankToBeFilled=widget.optionAText;
                            isAnswered=true;
                            _writeBooleanValue(true);
                            print("isAnswered=true because you SELECTED option A.");
                            _optionBHasBeenPressed=false;
                            _optionCHasBeenPressed=false;
                            _optionDHasBeenPressed=false;
                          } // if option A has been selected

                          if(_optionAHasBeenPressed==false)
                          {
                            blankToBeFilled="_________";
                            isAnswered=false;
                            _writeBooleanValue(false);
                            print("isAnswered=false because you DESELECTED option A.");
                          } // if option has been deselected
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: _optionAHasBeenPressed ? selectedButtonBorderColor : deselectedButtonBorderColor,
                          width: 1.0,
                        ),
                        backgroundColor: _optionAHasBeenPressed ? selectedButtonBackgroundColor : deselectedButtonBackgroundColor,
                        enableFeedback: false,
                      ), // ElevatedButton.styleFrom
                      child: Text(
                        widget.optionAText,
                        style: TextStyle(
                          color: _optionAHasBeenPressed ? selectedButtonTextColor : deselectedButtonTextColor,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // OPTION B
              Row(
                children: <Widget>[

                  MyCustomCircleAvatar(
                    optionLetter: 'B',
                    optionBackgroundColor: Colors.indigo.shade900,
                  ),

                  const Text('  '),

                  // ELEVATED BUTTON FOR OPTION B
                  Container(
                    child: makeSubmission? ElevatedButtonShowingResult(widget.optionBText, _optionBHasBeenPressed) : ElevatedButton(
                      onPressed: () {

                        String textToPrint=((((widget.optionBText).toUpperCase()).replaceAll(", ", "_")).replaceAll(" ", "_")).replaceAll("'", "_");

                        FlutterRingtonePlayer().play(fromAsset: "assets/audios/FITB_options_audio/$textToPrint.mp3");

                        // user pressed option B
                        setState(() {
                          _optionBHasBeenPressed=!_optionBHasBeenPressed;

                          if(_optionBHasBeenPressed==true)
                          {
                            blankToBeFilled=widget.optionBText;
                            isAnswered=true;
                            _writeBooleanValue(true);
                            print("isAnswered=true because you SELECTED option B.");
                            _optionAHasBeenPressed=false;
                            _optionCHasBeenPressed=false;
                            _optionDHasBeenPressed=false;
                          }

                          if(_optionBHasBeenPressed==false)
                          {
                            blankToBeFilled="_________";
                            isAnswered=false;
                            _writeBooleanValue(false);
                            print("isAnswered=false because you DESELECTED option B.");
                          }

                        });
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: _optionBHasBeenPressed? selectedButtonBorderColor : deselectedButtonBorderColor,
                          width: 1.0,
                        ),
                        backgroundColor: _optionBHasBeenPressed? selectedButtonBackgroundColor : deselectedButtonBackgroundColor,
                        enableFeedback: false,
                      ),
                      child: Text(
                        widget.optionBText,
                        style: TextStyle(
                          color: _optionBHasBeenPressed? selectedButtonTextColor : deselectedButtonTextColor,
                          fontSize: 20.0,
                        ),
                      ), // ElevatedButton.styleFrom
                    ),
                  ),
                ],
              ),

              // OPTION C
              Row(
                children: <Widget>[

                  MyCustomCircleAvatar(
                    optionLetter: 'C',
                    optionBackgroundColor: Colors.indigo.shade900,
                  ),

                  const Text('  '),

                  // ELEVATED BUTTON FOR OPTION C
                  Container(
                    child: makeSubmission? ElevatedButtonShowingResult(widget.optionCText, _optionCHasBeenPressed) : ElevatedButton(
                      onPressed: () {

                        String textToPrint=((((widget.optionCText).toUpperCase()).replaceAll(", ", "_")).replaceAll(" ", "_")).replaceAll("'", "_");

                        FlutterRingtonePlayer().play(fromAsset: "assets/audios/FITB_options_audio/$textToPrint.mp3");

                        // user pressed option C
                        setState(() {
                          _optionCHasBeenPressed=!_optionCHasBeenPressed;

                          if(_optionCHasBeenPressed==true)
                          {
                            blankToBeFilled=widget.optionCText;
                            isAnswered=true;
                            _writeBooleanValue(true);
                            print("isAnswered=true because you SELECTED option C.");
                            _optionAHasBeenPressed=false;
                            _optionBHasBeenPressed=false;
                            _optionDHasBeenPressed=false;
                          }

                          if(_optionCHasBeenPressed==false)
                          {
                            blankToBeFilled="_________";
                            isAnswered=false;
                            _writeBooleanValue(false);
                            print("isAnswered=false because you DESELECTED option C.");
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: _optionCHasBeenPressed? selectedButtonBorderColor : deselectedButtonBorderColor,
                          width: 1.0,
                        ),
                        backgroundColor: _optionCHasBeenPressed? selectedButtonBackgroundColor : deselectedButtonBackgroundColor,
                        enableFeedback: false,
                      ),
                      child: Text(
                        widget.optionCText,
                        style: TextStyle(
                          color: _optionCHasBeenPressed? selectedButtonTextColor : deselectedButtonTextColor,
                          fontSize: 20.0,
                        ),
                      ), // ElevatedButton.styleFrom
                    ),
                  ),
                ],
              ),

              // OPTION D
              Row(
                children: <Widget>[

                  MyCustomCircleAvatar(
                    optionLetter: 'D',
                    optionBackgroundColor: Colors.indigo.shade900,
                  ),

                  const Text('  '),

                  // ELEVATED BUTTON FOR OPTION D
                  Container(
                    child: makeSubmission? ElevatedButtonShowingResult(widget.optionDText, _optionDHasBeenPressed) : ElevatedButton(
                      onPressed: () {

                        String textToPrint=((((widget.optionDText).toUpperCase()).replaceAll(", ", "_")).replaceAll(" ", "_")).replaceAll("'", "_");

                        FlutterRingtonePlayer().play(fromAsset: "assets/audios/FITB_options_audio/$textToPrint.mp3");

                        // user pressed option D
                        setState(() {
                          _optionDHasBeenPressed=!_optionDHasBeenPressed;

                          if(_optionDHasBeenPressed==true)
                          {
                            blankToBeFilled=widget.optionDText;
                            isAnswered=true;
                            _writeBooleanValue(true);
                            print("isAnswered=true because you SELECTED option D.");
                            _optionAHasBeenPressed=false;
                            _optionBHasBeenPressed=false;
                            _optionCHasBeenPressed=false;
                          }

                          if(_optionDHasBeenPressed==false)
                          {
                            blankToBeFilled="_________";
                            isAnswered=false;
                            _writeBooleanValue(false);
                            print("isAnswered=false because you DESELECTED option D.");
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: _optionDHasBeenPressed? selectedButtonBorderColor : deselectedButtonBorderColor,
                          width: 1.0,
                        ),
                        backgroundColor: _optionDHasBeenPressed? selectedButtonBackgroundColor : deselectedButtonBackgroundColor,
                        enableFeedback: false,
                      ),
                      child: Text(
                        widget.optionDText,
                        style: TextStyle(
                          color: _optionDHasBeenPressed? selectedButtonTextColor : deselectedButtonTextColor,
                          fontSize: 20.0,
                        ),
                      ), // ElevatedButton.styleFrom
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Text('\n'), // again, LMAO

          // This was to push the 'SUBMIT' and 'CLEAR' buttons to the bottom of the screen
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                // 'SUBMIT' BUTTON
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    // ADDING DYNAMIC SIZING
                    //height: 80.0,
                    height: MediaQuery.sizeOf(context).height*0.09,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submissionDone? null : () {
                        // user submits the selected answer
                        setState(() {

                          //_submitButtonHasBeenPressed=!_submitButtonHasBeenPressed;
                          // not needed for the submit button

                          if(_optionAHasBeenPressed==false &&
                              _optionBHasBeenPressed==false &&
                              _optionCHasBeenPressed==false &&
                              _optionDHasBeenPressed==false)
                          {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('NO OPTION SELECTED!'),
                                  content: const Text('Please select an option to submit!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OKAY'),
                                    ),
                                  ], // actions
                                );
                              }, // builder
                            ); // showDialog
                          } // if submit button was pressed without the selection of any option

                          else
                          {
                            makeSubmission=true;
                            submissionDone=true;
                            _writeBooleanValue1(true);
                            print("\nInside SingleQuestionQuizPage(), the value of submissionDone: $submissionDone\n");

                            // get the text of the option selected
                            optionTextToBeSubmitted=(_optionAHasBeenPressed) ?
                            widget.optionAText : (_optionBHasBeenPressed) ?
                            widget.optionBText : (_optionCHasBeenPressed) ?
                            widget.optionCText : widget.optionDText ;

                            // check if the text of the option selected is the correct answer then update the score variable
                            if(optionTextToBeSubmitted==widget.correctAnswerText) {

                              FlutterRingtonePlayer().play(fromAsset: "assets/audios/check_answer_audio/correct_answer.mp3");

                              print("Congrats, $optionTextToBeSubmitted is the right answer!");
                              if(isScoreUpdated==false) {
                                ++score;
                                totalScore+=score;
                                print("Score now: $score");
                                print('isAnswered: $isAnswered');
                                isScoreUpdated=true;
                              } // update the score IF the score hasn't already been updated
                            }
                            else {

                              FlutterRingtonePlayer().play(fromAsset: "assets/audios/check_answer_audio/incorrect_answer.mp3");

                              print("Sorry, $optionTextToBeSubmitted is the wrong answer!");
                              print("Score now: $score");
                              print('isAnswered: $isAnswered');
                            }

                          }

                        }); // setState
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'SUBMIT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // ElevatedButton.styleFrom
                    ),
                  ),
                ),

                // 'CLEAR' BUTTON
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    // ADDING DYNAMIC SIZING
                    //height: 80.0,
                    height: MediaQuery.sizeOf(context).height*0.09,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submissionDone? null : () {
                        // DOUBT: Not working. Not able to clear the selected option.

                        // clear any user selection
                        setState(() {
                          blankToBeFilled="_________";
                          _optionAHasBeenPressed=false;
                          _optionBHasBeenPressed=false;
                          _optionCHasBeenPressed=false;
                          _optionDHasBeenPressed=false;
                          isAnswered=false;
                          _writeBooleanValue(false);
                          print("isAnswered=false, because you pressed CLEAR!");
                        });

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'CLEAR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // ElevatedButton.styleFrom
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

//--------------------------------MY TINY QUIZ APP--------------------------------------------------------------------------------------------------------------
class MyTinyQuizApp extends StatefulWidget {
  const MyTinyQuizApp({super.key});

  @override
  State<MyTinyQuizApp> createState() => _MyTinyQuizAppState();
}

class _MyTinyQuizAppState extends State<MyTinyQuizApp> {

  var questionBank=<Question>[

    /*
    Question(
      "You guys sound just like the enemies of ",
      "GroundGourmet",
      "WindWaffles",
      "Seabiscuit",
      "ForestFrosties",
      "Seabiscuit",
    ),

    Question(
      "Well, well, well.... How the ",
      "turntables",
      "chasechairs",
      "drinkdesks",
      "floatfloors",
      "turntables",
    ),

    Question(
      "Fact: Bears beat ",
      "Robowar Ranger",
      "Battlestar Universelia",
      "Battlestar Gallactica",
      "Fireborn Destroyer",
      "Battlestar Gallactica",
    ),

    Question(
      "It's just rum. I'm not bored. I'm a ",
      "terrorist",
      "murderer",
      "pirate",
      "robber",
      "pirate",
    ),

    Question(
      "Sometimes, I think she holds onto ",
      "emails",
      "faxes",
      "calls",
      "meetings",
      "faxes",
    ),

    Question(
      "Scotch and Splenda. Tastes like Splenda, gets you drunk like ",
      "Splenda",
      "Red Wine",
      "Scotch",
      "Moonshine",
      "Scotch",
    ),
     */

    Question(
      "The capital city of France is ",
      "Paris",
      "Lyon",
      "Lille",
      "Nantes",
      "Paris",
    ),

    Question(
      "The river that flows through Paris is ",
      "La Fleur",
      "Le Camembert",
      "La Seine",
      "Le Fromage",
      "La Seine",
    ),

    Question(
      "The French delicacy consisting of snails cooked with garlic butter is ",
      "Quiche Lorraine",
      "Croque Monsieur",
      "L'Escargot",
      "Le Pain du Chocolat",
      "L'Escargot",
    ),

    Question(
      "The national motto of France is ",
      "Amitie, Amour, Hostilite",
      "Liberte, Egalite, Fraternite",
      "Rester, Marcher, Courir",
      "Citoyen, Ville, Pays",
      "Liberte, Egalite, Fraternite",
    ),

    Question(
      "When making a festive toast, the French say ",
      "Beaute",
      "Sante",
      "Amitie",
      "Bonheur",
      "Sante",
    ),

    Question(
      "One of the most famous museums of the world, in Paris, is called Musee du ",
      "Visage",
      "Sac",
      "Printemps",
      "Louvre",
      "Louvre",
    ),

  ];
  //var maxScore = questionBank.length;
  // I get the error here: The instance member 'questionBank' can't be accessed in an initializer.

  /*
  Use late keyword: Dart 2.12 comes with late keyword which helps you do the lazy initialization
  which means until the field 'maxScore' is used it would remain uninitialized.
   */
  int pointForEveryQuestion=1; // every question carries 1 point
  late int maxScore=questionBank.length*pointForEveryQuestion;

  final PageController _pageController=PageController();

  late final int _pageCount=questionBank.length;
  int _currentPage=0;

  void _goToTheNextPage() {

    print("FROM THE FUNCTION _GOTOTHENEXTQUESTION(): HELLOOOOOOOOOOO!!!!");

    //submissionDone=false;
    //print("\nInside _goToNextPage(), value of submissionDone: $submissionDone\n");

    if(_currentPage < _pageCount -1) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /*
   These functions are to share the value of the boolean variable 'isAnswered'
   across the two widgets: 'SingleQuestionQuizPage' and 'MyTinyQuizApp'.
   */

  /*
  Future<void> _writeBooleanValue() async { // function can also be _setBooleanValue()
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAnswered', true); // Change 'true' to 'false' for false value
  }

  Future<bool> _readBooleanValue() async { // function can also be _getBooleanValue()
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAnswered') ?? false; // Default to false if key not found
  }
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        title: const Center(
          child: Text(
            'A Francophile Quiz!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.home,
            color: Colors.white,
            weight: 15,
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
                  },
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
          children: [

            /*
            removed the 'sizedBox' parent widget, it's parameters were:

            height: MediaQuery.sizeOf(context).height/1.25,
             */

            // ADDING DYNAMIC SIZING
            // added 'expanded' parent widget
            // PageView.builder building with SingleQuestionQuizPage stateful widget is here
            Expanded(
              child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  itemCount: _pageCount,
                  itemBuilder: (context,index){
                    return SingleQuestionQuizPage(
                      questionText: questionBank[index].returnQuestionText(),
                      optionAText: questionBank[index].returnOptionAText(),
                      optionBText: questionBank[index].returnOptionBText(),
                      optionCText: questionBank[index].returnOptionCText(),
                      optionDText: questionBank[index].returnOptionDText(),
                      correctAnswerText: questionBank[index].returnCorrectAnswerText(),
                    );
                  }),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: SizedBox(
                // ADDING DYNAMIC SIZING
                //height: 80.0,
                height: MediaQuery.sizeOf(context).height*0.09,
                width: double.infinity,
                child: ElevatedButton(

                  /*
                 Can't do this if submissionDone is of type Future<bool>, otherwise you'll get the error:
                 Conditions must have a static type of 'bool'.

                 However, I can use it inside setState()! Using an if-else block.

                 If I use submissionDone directly here, using shared_preferences plugin, the NEXT button
                 remains disabled due to some state issue.

                 I can use submissionDone with the CLEAR button though....I'm not sure why. Something to do with state.

                 So far, I cannot disable and then enable the NEXT button, but I can disable (and then the next
                 time the page options with a new State, it will be enabled) the SUBMIT and CLEAR buttons.
                  */
                  onPressed: () {
                    setState(() {
                      if(submissionDone==true) {
                        print("because _readBooleanValue()=true, MOVE TO THE NEXT PAGE/FINISH THE QUIZ!!!!");
                        isAnswered=false;
                        _writeBooleanValue(false);
                        submissionDone=false;
                        _writeBooleanValue1(false);
                        if(_currentPage>=(_pageCount-1)) {
                          // navigate to the result page
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) {
                                    return MyCommonResultPage(
                                        quizAcronym: 'FITB',
                                        value: totalScore,
                                        maxValue: maxScore,
                                    );
                                  }
                              )
                          );
                        } // if(_currentPage>=(_pageCount-1))

                        // if we are not at the last page then we can call this function:
                        _goToTheNextPage();
                      }

                      else {
                        print("because _readBooleanValue()=false, SHOW THE DIALOG BOX ASKING THE USER TO AT LEAST SELECT AN OPTION BEFORE MOVING ONTO THE NEXT QUESTION!!!!");
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('TRY THIS QUESTION!'),
                                content: const Text(
                                    'Submit an answer for this question before moving on to the next one! You can\'t win if you don\'t try!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OKAY'),
                                  ),
                                ],
                              );
                            }
                        );
                      }

                    });

                    //_goToTheNextPage();
                  },

                  // change color of 'NEXT' button to that of 'FINISH' button when you reach the last page
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (_currentPage>=(_pageCount-1)) ? Colors.deepOrange.shade900 : Colors.pink.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),

                  // change text of 'NEXT' button to that of 'FINISH' button when you reach the last page
                  child: Text(
                    (_currentPage>=(_pageCount-1)) ? 'FINISH' : 'NEXT',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ), // ElevatedButton.styleFrom
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
