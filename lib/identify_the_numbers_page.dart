import 'package:flutter/material.dart';
import 'common_result_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'quiz_page.dart';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

bool submissionDone=false;

Future<void> _writeBooleanValue(bool valueToWrite) async {
  // function can also be _setBooleanValue()
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('submissionDone', valueToWrite); // Change 'true' to 'false' for false value
}

int totalScore=0;
// for now it's global, later I'll move it somewhere else later if I can

//_______________________________________MY-SINGLE-QUESTION-CUSTOM-NUMBER-KEYPAD______________________________________________
class MySingleQuestionCustomNumberKeypad extends StatefulWidget {

  final String questionText;
  final String correctAnswer;

  const MySingleQuestionCustomNumberKeypad({super.key, required this.questionText, required this.correctAnswer});

  @override
  State<MySingleQuestionCustomNumberKeypad> createState() => _MySingleQuestionCustomNumberKeypadState();
}

class _MySingleQuestionCustomNumberKeypadState extends State<MySingleQuestionCustomNumberKeypad> {
  final TextEditingController _controller = TextEditingController();
  late TextSelection _selection;

  String correctAnswerImagePath="assets/images/identify_the_number_images/green_check_mark.gif";
  String incorrectAnswerImagePath="assets/images/identify_the_number_images/red_cross_mark.gif";
  String noAnswerImagePath="assets/images/identify_the_number_images/blue_question_mark.gif";

  String currentImagePath="assets/images/identify_the_number_images/blue_question_mark.gif";

  Color correctAnswerTextFieldColor=Colors.green.shade700;
  Color incorrectAnswerTextFieldColor=Colors.red.shade700;
  Color noAnswerTextFieldColor=Colors.black;

  Color currentTextFieldColor=Colors.black;

  bool submissionPerformed=false; // made 'true' when the check button is pressed
  bool correctAnswerFound=false; // made 'true' if the answer is found to be correct (inside the check function)

  /*
EXPLAINING THE CODE BELOW THIS COMMENT:

1. "void _initState() {":

This declares a method named _initState with a return type of void, meaning it
doesn't return any value. The underscore (_) at the beginning indicates that this
method is private and only accessible within the current class and its subclasses.

2. "super.initState();":

This line calls the initState method of the superclass (which is typically
StatefulWidget). This is important because the superclass' initState might contain
essential initialization logic that needs to be executed before your own code in
this method.

3. "_controller = widget.controller;":

This line assigns the value of the controller property from the widget itself to
a private variable named _controller within the state class. By using widget.controller,
you're accessing a property passed down from the parent widget to this stateful widget.
This assumes that the parent widget provides a controller property of some type, and
you're storing a reference to it in the state class.

IMPORTANCE: Accessing a controller property from the parent widget and storing it in a
private variable within the state class. This allows the state class to interact with
the controller provided by the parent widget, potentially using it to control or update
UI elements based on its state.
   */

  int score=0;
  bool isScoreUpdated=false;
  /*
  to check if the score is updated (should be updated only once)
  needed this variable because the function below is called several
  times and the score gets updated everytime it is called
   */

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSelectionChanged);
    _selection=_controller.selection;
  }

  /*
PURPOSE OF THE CODE BELOW THE COMMENT:

The dispose method is called when a stateful widget is removed from the widget tree,
typically when the user navigates away from the screen or the app is closed. Its
primary purpose is to:

1. Release any resources held by the widget: This could include closing streams,
canceling timers, removing event listeners, or disposing of objects that hold
references to external resources.

2. Prevent memory leaks: By properly disposing of resources, you ensure that the widget
doesn't hold onto unnecessary data or objects, even after it's no longer displayed.

3. Examples of resources to dispose:

    a. Streams: If your widget uses a stream to listen for data updates, you should
       cancel the subscription in dispose to prevent memory leaks.

    b. Timers: If your widget uses a timer to trigger events, you should cancel the
       timer in dispose to prevent it from continuing to run even when the widget is
       no longer visible.

    c. Event listeners: If your widget registers event listeners (e.g., for keyboard
       input or sensor data), you should remove them in dispose to prevent the widget
       from receiving events it no longer needs.

REMEMBER: It's crucial to properly implement the dispose method in your stateful widgets
to maintain good resource management and prevent memory leaks in your Flutter app. The
specific code you place in dispose will depend on the resources used by your widget.
   */

  @override
  void dispose() {
    // dispose stuff later
    _controller.removeListener(_onSelectionChanged);
    super.dispose();
  }

  void _onSelectionChanged() {
    setState(() {
      // update selection on change (updating position too)
      _selection=_controller.selection;
    });
    print("Cursor position: ${_selection.base.offset}");
  }

  // method to construct our text input
  void _input(String text) {
    print("Hello there $text!");

    int position=_selection.base.offset; // gets the position of the cursor
    var value=_controller.text; // text in our text field

    if(value.isNotEmpty) {
      var suffix=value.substring(position, value.length);
      /*
      suffix: the string from the position of the cursor to the end of the
      text in the controller
       */
      value=value.substring(0, position) + text + suffix;
      /*
      value.substring gets a new string from the start of the string in our
      text field, appends the new input to our new string and appends the
      suffix to it.
       */

      _controller.text=value;
      _controller.selection=TextSelection.fromPosition(
        TextPosition( offset: position+1 ),
      );
    } // if(value.isNotEmpty)

    else {
      value=_controller.text+text;
      /*
      appends controller text and new input and assigns the result to the
      variable value
       */
      _controller.text=value;
      // set our controller text to the gotten value
      _controller.selection=TextSelection.fromPosition(
        const TextPosition( offset: 1 ),
      );
      /*
      set position of cursor to 1, so the cursor is placed at the end
       */
    }
  }

  /*
  IN THE ABOVE FUNCTION:

  We had to take into consideration two scenarios when the TextField is empty
  and when it's not.

  1. When it’s not empty:

    a. suffix - the string from the position of the cursor to the end of the
       text in the controller, basically all text after the cursor.

    b. value.substring(0, position) gets all the text before the cursor, appends
       the new input to the text and appends the suffix to it.

    c. The controller text is updated to the value (updated text input).

    d. The cursor position is updated.

  2. When it’s empty:

    a. Append controller text to new input and assign to value.

    b. The controller text is updated.

    c. Since this is the first input set the position of the cursor to 1, so the
       cursor is placed at the end
   */

  // method to implement the backspace feature
  void _backspace() {
    print("User pressed the backspace button!");

    int position=_selection.base.offset; // cursor position
    final value=_controller.text; // string in out text field

    if(value.isNotEmpty && position!=0) {
      /*
      Only erase when the string in text field is not empty and
      when the position is not zero (at the start).
       */
      var suffix=value.substring(position, value.length);
      // get the string AFTER the cursor position
      _controller.text=value.substring( 0, position-1 ) + suffix;
      /*
       get the string BEFORE the cursor position and append to the
       suffix after removing the last character before the cursor
       */
      _controller.selection=TextSelection.fromPosition(
        TextPosition(offset: position-1),
      );
      // update the cursor
    }
  }

  void _clearInput() {
    print("Clearing the input completely because user long pressed the backspace button!");
    _controller.text="";
    _controller.selection=TextSelection.fromPosition(
        const TextPosition(offset: 0),
    );
  }

  // method to perform checking of the text input so far
  void _checkAnswer() {
    print("Time to check if the input text is correct!");

    if(_controller.text.isEmpty){
      setState(() {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: const Text("NO TEXT ENTERED!"),
              content: const Text("You need to enter some text using the buttons, before you can check your answer!"),
              actions: [
                TextButton(
                  child: const Text("OKAY"),
                  onPressed: () { Navigator.pop(context); },
                ),
              ],
            );
          },
        );
      });
    }

    else if(_controller.text==widget.correctAnswer) {

      print("YAYYY CORRECT ANSWER!");
      FlutterRingtonePlayer().play(fromAsset: "assets/audios/check_answer_audio/correct_answer.mp3");

      setState(() {
        submissionPerformed=true;
        /*
        should only be true when submission is ALLOWED to be performed i.e when
        the text field is submitted with some text and not while it's empty
         */
        correctAnswerFound=true;
        currentImagePath=correctAnswerImagePath;
        currentTextFieldColor=correctAnswerTextFieldColor;

        // the user should be allowed to move to the next question is the answer has been CHECKED
        submissionDone=true;
        _writeBooleanValue(true);

        if(isScoreUpdated==false) {
          ++score;
          totalScore+=score;
          print("Score now for the CORRECT answer ${_controller.text}: $score");
          isScoreUpdated=true;
        } // update the score IF the score hasn't already been updated
      });
    }

    else {

      print("NOOOO WRONG ANSWER!");
      FlutterRingtonePlayer().play(fromAsset: "assets/audios/check_answer_audio/incorrect_answer.mp3");

      setState(() {
        submissionPerformed=true;
        /*
        should only be true when submission is ALLOWED to be performed i.e when
        the text field is submitted with some text and not while it's empty
         */
        correctAnswerFound=false;
        currentImagePath=incorrectAnswerImagePath;
        currentTextFieldColor=incorrectAnswerTextFieldColor;

        // the user should be allowed to move to the next question is the answer has been CHECKED
        submissionDone=true;
        _writeBooleanValue(true);

        print("Score now for the WRONG or INCORRECT answer ${_controller.text}: $score");
      });
    }
  }

  /*
  IN THE ABOVE FUNCTION:

  1: For our backspace, we only need erasing to work when our
     Textfield is not empty and the cursor position is not equal
     to 0 (at the start).

  2: suffix = string after the cursor position.

  3: Get all strings before the cursor and remove the last char
     in the string and append our suffix to it.

  4: The cursor position is updated.
   */

  // method to return a single key
  // takes text and onPressed callback to input
  Widget _numKeyButton(String text, {Color? buttonColor=Colors.orangeAccent, VoidCallback? onPressed, VoidCallback? onLongPress}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 40.0,
          child: ElevatedButton(
            onPressed: submissionPerformed ? null : onPressed ?? () {
              FlutterRingtonePlayer().play(fromAsset: "assets/audios/ITN_number_keypad_audio/$text.mp3");
              print("Yes, we registered the onPress event!");
              _input(text);
            },
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(),
              // you can use either minimumSize to actually increase the of the button
              minimumSize: const Size(20,50),
              // you can also use padding to give the illusion of increasing the size of the button
              //padding: const EdgeInsets.all(50.0),
              backgroundColor: buttonColor,
            ), // ElevatedButton.styleFrom
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        /* Here, we build our 3x4 numeric  keypad consisting of our
            desired individual keys.
             */
        children: [

          Align(
            alignment: Alignment.topLeft,
            child: Text(
              submissionPerformed ? "It's ${widget.correctAnswer}!" : "What's the number for?\n",
              //textAlign: TextAlign.start, // DOUBT: this not working? But Align widget does the job?
              style: TextStyle(
                fontSize: 15,
                fontWeight: submissionPerformed ? FontWeight.bold : FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      // QUESTION-TEXT
                      TextButton(
                        onPressed: () {
                          FlutterRingtonePlayer().play(fromAsset: "assets/audios/ITN_question_audio/${(widget.questionText).toUpperCase()}.mp3");
                        },
                        child: Text(
                          widget.questionText,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      // REACTION IMAGE
                      Image(
                        image: AssetImage(currentImagePath),
                        height: 40,
                        width: 40,
                      ),

                    ],
                  ),

                  // TEXT-FIELD
                  TextField(
                    onChanged: (text) {
                      print("Okay, the text field did take this value: $text!");
                    },
                    controller: _controller,
                    keyboardType: TextInputType.none,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: submissionPerformed ? FontWeight.bold : FontWeight.normal,
                      color: currentTextFieldColor,
                    ),
                    // we do not need our default keyboard to pop up when we tap on the text field
                  ),

                ],
              ),
            ),
          ),

          // NUMBER KEYPAD
          Column(
            children: [
              Row(
                children: [

                  _numKeyButton("1"),
                  _numKeyButton("2"),
                  _numKeyButton("3"),
                ],
              ),

              Row(
                children: [
                  _numKeyButton("4"),
                  _numKeyButton("5"),
                  _numKeyButton("6"),
                ],
              ),

              Row(
                children: [
                  _numKeyButton("7"),
                  _numKeyButton("8"),
                  _numKeyButton("9"),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _numKeyButton("0"),
                ],
              ),

              // CHECK, BACKSPACE BUTTONS' ROW
              // try possible solution: make these buttons different since from the word/number keys
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // CHECK/SUBMIT BUTTON
                  _numKeyButton(
                      "✓",
                      buttonColor: Colors.lightGreenAccent,
                      onPressed: () {
                        setState(() {
                          _checkAnswer();
                        });
                      }
                  ),
                  // BACKSPACE BUTTON
                  _numKeyButton(
                    "⌫",
                    buttonColor: Colors.redAccent.shade200,
                    onPressed: () {
                      setState(() {
                        _backspace();
                      });
                    },
                    onLongPress: () {
                      // long press is not being registered here....in this app....
                      // might work on another device so I'm leaving it here
                      print("LONG PRESSED REGISTERED!");
                      setState(() {
                        _clearInput();
                      });
                    }
                  ),
                ],
              ),

            ],
          ),

        ],
      ),
    );
  }
}


//________________________________MY-SINGLE-QUESTION-CUSTOM-WORD-KEYPAD__________________________________________________________
class MySingleQuestionCustomWordKeypad extends StatefulWidget {

  final String questionText;
  final List<String> row0NumberWordList;
  final List<String> row1NumberWordList;
  final List<String> row2NumberWordList;
  final List<String> row3NumberWordList;
  final List<String> row4NumberWordList;
  final List<String> row5NumberWordList;
  final String correctAnswer;

  const MySingleQuestionCustomWordKeypad({
    super.key,
    required this.questionText,
    required this.row0NumberWordList,
    required this.row1NumberWordList,
    required this.row2NumberWordList,
    required this.row3NumberWordList,
    required this.row4NumberWordList,
    required this.row5NumberWordList,
    required this.correctAnswer,

  });

  @override
  State<MySingleQuestionCustomWordKeypad> createState() => _MySingleQuestionCustomWordKeypadState();
}

class _MySingleQuestionCustomWordKeypadState extends State<MySingleQuestionCustomWordKeypad> {

  final TextEditingController _controller = TextEditingController();

  String correctAnswerImagePath="assets/images/identify_the_number_images/green_check_mark.gif";
  String incorrectAnswerImagePath="assets/images/identify_the_number_images/red_cross_mark.gif";
  String noAnswerImagePath="assets/images/identify_the_number_images/blue_question_mark.gif";

  String currentImagePath="assets/images/identify_the_number_images/blue_question_mark.gif";

  Color correctAnswerTextFieldColor=Colors.green.shade700;
  Color incorrectAnswerTextFieldColor=Colors.red.shade700;
  Color noAnswerTextFieldColor=Colors.black;

  Color currentTextFieldColor=Colors.black;

  bool submissionPerformed=false; // made 'true' when the check button is pressed
  bool correctAnswerFound=false; // made 'true' if the answer is found to be correct (inside the check function)

  /*
  List<String> row0NumberWordList=["BIG-WORD", "SW", "SW"];
  List<String> row1NumberWordList=["SW", "BIG-WORD", "SW"];
  List<String> row2NumberWordList=["BIG-WORD", "SW", "SW"];
  List<String> row3NumberWordList=["SW", "BIG-WORD", "SW"];
  List<String> row4NumberWordList=["SW", "SW", "BIG-WORD"];
  List<String> row5NumberWordList=["SW", "SW", "BIG-WORD"];

  String correctAnswer="BIG-WORD SW SW";
   */

  int score=0;
  bool isScoreUpdated=false;
  /*
  to check if the score is updated (should be updated only once)
  needed this variable because the function below is called several
  times and the score gets updated everytime it is called
   */

  // method to construct our text input
  void _input(String text) {
    print("Hello there $text!");

    var controllerText=_controller.text;

    if(controllerText.isEmpty) { _controller.text=text; }
    else { _controller.text="${_controller.text} $text"; }
  }

  // method to implement the backspace feature
  void _backspace() {
    print("User pressed the backspace button!");

    final value=_controller.text;
    if(value.isNotEmpty) {
      _controller.text=value.substring(0, value.length-1);
      // removes the last character from the original string
    }
  }

  void _clearInput() {
    _controller.text="";
  }

  // method to perform checking of the text input so far
  void _checkAnswer() {
    print("Time to check if the input text is correct!");

    if(_controller.text.isEmpty){
      setState(() {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: const Text("NO TEXT ENTERED!"),
              content: const Text("You need to enter some text using the buttons, before you can check your answer!"),
              actions: [
                TextButton(
                  child: const Text("OKAY"),
                  onPressed: () { Navigator.pop(context); },
                ),
              ],
            );
          },
        );
      });
    }

    else if(_controller.text==widget.correctAnswer) {

      print("YAYYY CORRECT ANSWER!");
      FlutterRingtonePlayer().play(fromAsset: "assets/audios/check_answer_audio/correct_answer.mp3");

      setState(() {
        submissionPerformed=true;
        _writeBooleanValue(true);
        /*
        should only be true when submission is ALLOWED to be performed i.e when
        the text field is submitted with some text and not while it's empty
         */
        correctAnswerFound=true;
        currentImagePath=correctAnswerImagePath;
        currentTextFieldColor=correctAnswerTextFieldColor;

        // the user should be allowed to move to the next question is the answer has been CHECKED
        submissionDone=true;
        _writeBooleanValue(true);

        if(isScoreUpdated==false) {
          ++score;
          totalScore+=score;
          print("Score now for the CORRECT answer ${_controller.text}: $score");
          isScoreUpdated=true;
        } // update the score IF the score hasn't already been updated

      });
    }

    else {

      print("NOOOO WRONG ANSWER!");
      FlutterRingtonePlayer().play(fromAsset: "assets/audios/check_answer_audio/incorrect_answer.mp3");

      setState(() {
        submissionPerformed=true;
        _writeBooleanValue(true);
        /*
        should only be true when submission is ALLOWED to be performed i.e when
        the text field is submitted with some text and not while it's empty
         */
        correctAnswerFound=false;
        currentImagePath=incorrectAnswerImagePath;
        currentTextFieldColor=incorrectAnswerTextFieldColor;

        // the user should be allowed to move to the next question is the answer has been CHECKED
        submissionDone=true;
        _writeBooleanValue(true);

        print("Score now for the WRONG or INCORRECT answer ${_controller.text}: $score");
      });
    }
  }

  // method to return a single key
  // takes text and onPressed callback to input
  Widget _wordKeyButton(String text, {Color? buttonColor=Colors.orangeAccent, VoidCallback? onPressed, VoidCallback? onLongPress}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        height: 40.0,
        child: ElevatedButton(
          onPressed: submissionPerformed ? null : onPressed ?? () {
            FlutterRingtonePlayer().play(fromAsset: "assets/audios/ITN_word_keypad_audio/${(text).toUpperCase()}.mp3");
            print("Yes, we registered the onPress event!");
            _input(text);
          },
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(), // looks much better than circleBorder()
            // you can use either minimumSize to actually increase the of the button
            minimumSize: const Size(20,50),
            // you can also use padding to give the illusion of increasing the size of the button
            //padding: const EdgeInsets.all(50.0),
            backgroundColor: buttonColor,
          ), // ElevatedButton.styleFrom
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Align(
            alignment: Alignment.topLeft, // "textAlign: TextAlign.start," did not work but THIS did? Why?
            child: Text(
              submissionPerformed ? "It's ${widget.correctAnswer}!" : "What's the number for?\n",
              //textAlign: TextAlign.start, // DOUBT: this not working? But Align widget does the job?
              style: TextStyle(
                fontSize: 20,
                fontWeight: submissionPerformed ? FontWeight.bold : FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),

          Expanded(
            // removed 'center' parent widget
            child: Column(
              // ADDING DYNAMIC SIZING
              //mainAxisAlignment: MainAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    // QUESTION TEXT
                    TextButton(
                      onPressed: () {
                        // plays its sound
                        FlutterRingtonePlayer().play(fromAsset: "assets/audios/ITN_question_audio/${widget.questionText}.mp3");
                      },
                      child: Text(
                        widget.questionText,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // REACTION IMAGE
                    Image(
                      image: AssetImage(currentImagePath),
                      height: 40,
                      width: 40,
                    ),

                  ],
                ),

                // TEXT-FIELD
                TextField(
                  onChanged: (text) {
                    print("Okay, the text field did take this value: $text!");
                  },
                  controller: _controller,
                  keyboardType: TextInputType.none,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: submissionPerformed ? FontWeight.bold : FontWeight.normal,
                    color: currentTextFieldColor,
                  ),
                  // we do not need our default keyboard to pop up when we tap on the text field
                ),

              ],
            ),
          ),

          // WORD KEYPAD
          Column(
            /* Here, we build our 3x4 numeric keypad consisting of our
                desired individual keys.
              */
            children: [

              // ROW 0
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: _wordKeyButton(widget.row0NumberWordList[0])), //BIG-WORD
                  _wordKeyButton(widget.row0NumberWordList[1]), // SMALL-WORD
                  _wordKeyButton(widget.row0NumberWordList[2]), // SMALL-WORD
                ],
              ),

              // ROW 1
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _wordKeyButton(widget.row1NumberWordList[0]), // SMALL-WORD
                  Expanded(child: _wordKeyButton(widget.row1NumberWordList[1])), // BIG-WORD
                  _wordKeyButton(widget.row1NumberWordList[2]), // SMALL-WORD
                ],
              ),

              // ROW 2
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: _wordKeyButton(widget.row2NumberWordList[0])), //BIG-WORD
                  _wordKeyButton(widget.row2NumberWordList[1]), // SMALL-WORD
                  _wordKeyButton(widget.row2NumberWordList[2]), // SMALL-WORD
                ],
              ),

              // ROW 3
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _wordKeyButton(widget.row3NumberWordList[0]), // SMALL-WORD
                  Expanded(child: _wordKeyButton(widget.row3NumberWordList[1])), // BIG-WORD
                  _wordKeyButton(widget.row3NumberWordList[2]), // SMALL-WORD
                ],
              ),

              // ROW 4
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _wordKeyButton(widget.row4NumberWordList[0]), // SMALL-WORD
                  _wordKeyButton(widget.row4NumberWordList[1]), // SMALL-WORD
                  Expanded(child: _wordKeyButton(widget.row4NumberWordList[2])), // BIG-WORD
                ],
              ),

              // ROW 5
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _wordKeyButton(widget.row5NumberWordList[0]), // SMALL-WORD
                  _wordKeyButton(widget.row5NumberWordList[1]), // SMALL-WORD
                  Expanded(child: _wordKeyButton(widget.row5NumberWordList[2])), // BIG-WORD
                ],
              ),

              // CHECK, BACKSPACE BUTTONS' ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: _wordKeyButton(
                          "✓",
                          buttonColor: Colors.lightGreenAccent,
                          onPressed: () {
                            setState(() {
                              _checkAnswer();
                            });
                          }
                      )),
                  Expanded(
                      child: _wordKeyButton(
                        "⌫",
                        buttonColor: Colors.redAccent.shade200,
                        onPressed: () {
                          setState(() {
                            _backspace();
                          });
                        },
                          onLongPress: () {
                            // long press is not being registered here....in this app....
                            // might work on another device so I'm leaving it here
                            print("LONG PRESSED REGISTERED!");
                            setState(() {
                              _clearInput();
                            });
                          }
                      )),
                ],
              ),

            ],
          ),

        ],
      ),
    );
  }
}

class SingleQuestionForWordKeypad {
  late String questionText;
  late List<String> row0NumberWordList;
  late List<String> row1NumberWordList;
  late List<String> row2NumberWordList;
  late List<String> row3NumberWordList;
  late List<String> row4NumberWordList;
  late List<String> row5NumberWordList;
  late String correctAnswer;

  SingleQuestionForWordKeypad(
      this.questionText,
      this.row0NumberWordList,
      this.row1NumberWordList,
      this.row2NumberWordList,
      this.row3NumberWordList,
      this.row4NumberWordList,
      this.row5NumberWordList,
      this.correctAnswer,
  );
}

class SingleQuestionForNumberKeypad {
  late String questionText;
  late String correctAnswer;

  SingleQuestionForNumberKeypad(this.questionText, this.correctAnswer);
}

//________________________________MY-IDENTIFY-THE-NUMBER-QUIZ-APP_____________________________________________________________
class MyIdentifyTheNumberQuizApp extends StatefulWidget {
  const MyIdentifyTheNumberQuizApp({super.key});

  @override
  State<MyIdentifyTheNumberQuizApp> createState() => _MyIdentifyTheNumberQuizAppState();
}

class _MyIdentifyTheNumberQuizAppState extends State<MyIdentifyTheNumberQuizApp> {

  List<SingleQuestionForWordKeypad> wordKeypadQuestionList=[
    SingleQuestionForWordKeypad(
      "20",
      ["QUATORZE", "DIX", "CENT"] ,
      ["SIX", "QUARANTE", "TREIZE"],
      ["CINQUANTE", "HUIT", "UN"],
      ["DEUX", "SOIXANTE", "SEIZE"],
      ["ONZE", "VINGT", "MILLION"],
      ["TROIS", "NEUF", "MILLIARD"],
      "VINGT",
    ),
    SingleQuestionForWordKeypad(
      "45",
      ["MILLIARD", "NEUF", "DOUZE"] ,
      ["HUIT", "MILLION", "QUINZE"],
      ["SOIXANTE", "TRENTE", "UN"],
      ["VINGT", "CINQUANTE", "DIX"],
      ["CINQ", "CENT", "QUARANTE"],
      ["SEPT", "SIX", "QUATORZE"],
      "QUARANTE CINQ",
    ),
    SingleQuestionForWordKeypad(
      "908",
      ["QUATORZE", "SEIZE", "SEPT"] ,
      ["TROIS", "QUARANTE", "TRENTE"],
      ["CINQUANTE", "SIX", "CINQ"],
      ["HUIT", "MILLIARD", "UN"],
      ["DEUX", "NEUF", "MILLION"],
      ["DIX", "CENT", "SOIXANTE"],
      "NEUF CENT HUIT",
    ),
  ];

  List<SingleQuestionForNumberKeypad> numberKeypadQuestionList=[
    SingleQuestionForNumberKeypad("Quatre-Vingt-Quatre", "84"),
    SingleQuestionForNumberKeypad("Soixante-Dix-Huit", "78"),
    SingleQuestionForNumberKeypad("Deux", "2"),
  ];

  /*
  Use late keyword: Dart 2.12 comes with late keyword which helps you do the lazy initialization
  which means until the field 'maxScore' is used it would remain uninitialized.
   */
  int pointForEveryQuestion=1; // every question carries 1 point
  late int maxScore=
      ( wordKeypadQuestionList.length * pointForEveryQuestion )
          +
          ( numberKeypadQuestionList.length * pointForEveryQuestion );

  final PageController _pageController=PageController();
  late final int _pageCount=wordKeypadQuestionList.length+numberKeypadQuestionList.length;
  // both of their lengths should be equal to scroll through them alternatively
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

  @override
  Widget build(BuildContext context) {

    // to see the size of the screen
    double screenHeight=MediaQuery.sizeOf(context).height;
    double screenWidth=MediaQuery.sizeOf(context).width;

    print("Screen Height: $screenHeight\nScreen Width: $screenWidth\n");

    return Scaffold(
      appBar: AppBar(
        // add the two required buttons similar to the other two quizzes
        title: const Center(
          child: Text(
            'Identify The Number Quiz',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.deepOrange.shade900,
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // ADDING DYNAMIC SIZING
          //mainAxisAlignment: MainAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            // ADDING DYNAMIC SIZING
            // added 'expanded' parent widget
            Expanded(
              /*
              removed 'sizedBox' parent widget, it's parameters were:

              1. before adding dynamic sizing:
              //height: MediaQuery.sizeOf(context).height/1.15, // this caused rendering problems
              height: 678.0, // should not hard code values....try to change this later
              width: double.infinity
              2. after adding dynamic sizing
              height: MediaQuery.sizeOf(context).height*0.75,
              width: MediaQuery.sizeOf(context).width,
               */
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                itemCount: _pageCount,
                itemBuilder: (context,index){
                  if (index % 2 == 0) {
                    return MySingleQuestionCustomWordKeypad(
                      // index~/2 is effective integer division
                      questionText: wordKeypadQuestionList[index~/2].questionText,
                      row0NumberWordList: wordKeypadQuestionList[index~/2].row0NumberWordList,
                      row1NumberWordList: wordKeypadQuestionList[index~/2].row1NumberWordList,
                      row2NumberWordList: wordKeypadQuestionList[index~/2].row2NumberWordList,
                      row3NumberWordList: wordKeypadQuestionList[index~/2].row3NumberWordList,
                      row4NumberWordList: wordKeypadQuestionList[index~/2].row4NumberWordList,
                      row5NumberWordList: wordKeypadQuestionList[index~/2].row5NumberWordList,
                      correctAnswer: wordKeypadQuestionList[index~/2].correctAnswer,
                    );
                  }
                  else {
                    return MySingleQuestionCustomNumberKeypad(
                      questionText: numberKeypadQuestionList[index~/2].questionText,
                      correctAnswer: numberKeypadQuestionList[index~/2].correctAnswer,
                    );
                  }
                }
              ),
            ),

            // 'NEXT' button
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: SizedBox(
                // ADDING DYNAMIC SIZING
                //height: 80.0,
                height: MediaQuery.sizeOf(context).height*0.09,
                width: double.infinity,
                child: ElevatedButton(

                  onPressed: () {
                    setState(() {
                      print("$submissionDone is the value of the variable submisionDone!");

                      if(submissionDone==true) {
                        print("because _readBooleanValue()=true, MOVE TO THE NEXT PAGE/FINISH THE QUIZ!!!!");
                        submissionDone=false;
                        _writeBooleanValue(false);
                        if(_currentPage>=(_pageCount-1)) {
                          // navigate to the result page if we are on the last page
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) {
                                    return MyCommonResultPage(quizAcronym: "ITN", value: totalScore, maxValue: maxScore);
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
