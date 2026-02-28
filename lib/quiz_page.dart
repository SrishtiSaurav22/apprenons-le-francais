import 'package:flutter/material.dart';
import 'home_page.dart';
import 'identify_the_numbers_page.dart';
import 'match_the_words_page.dart';
import 'fill_in_the_blanks_page.dart';

class MyQuizApp extends StatefulWidget {
  const MyQuizApp({super.key});

  @override
  State<MyQuizApp> createState() => _MyQuizAppState();
}

class _MyQuizAppState extends State<MyQuizApp> {

  Color primaryColorOfPage=Colors.green.shade900;

  // this is the default image
  String defaultOptionsDescriptionImagePathText="assets/images/description_images/default_options_description_transparent_background.png";
  String fillInTheBlanksDescriptionImagePathText="assets/images/description_images/fill_in_the_blanks_description_transparent_background.png";
  String matchTheWordsDescriptionImagePathText="assets/images/description_images/match_the_words_description_transparent_background.png";
  String identifyTheNumbersDescriptionImagePathText="assets/images/description_images/identify_the_numbers_description_transparent_background.png";
  String homeDescriptionImagePathText="assets/images/description_images/back_to_home_description_transparent_background.png";

  // this is the image path variable whose value will be changed
  // its default value is same as that of defaultOptionsDescriptionImagePathText
  String imagePathText="assets/images/description_images/default_options_description_transparent_background.png";

  Color selectedButtonBackgroundColor=Colors.indigo.shade900;
  //Color deselectedButtonBackgroundColor=Colors.deepOrange.shade900;
  Color deselectedButtonBackgroundColor=Colors.green.shade900;

  Color selectedButtonBorderColor=Colors.lightBlueAccent.shade100;
  //Color deselectedButtonBorderColor=Colors.orangeAccent.shade100;
  Color deselectedButtonBorderColor=Colors.lightGreenAccent.shade100;

  bool isFillInTheBlanksButtonSelected=false;
  bool isIdentifyTheNumbersButtonSelected=false;
  bool isMatchTheWordsButtonSelected=false;
  bool isHomeButtonSelected=false;

  /*
  I automatically got a back button after I came to this page from the HomePage widget through
  Navigator.push()! That's the default behavior in Flutter! When you use Navigator.push() to
  push a new page onto the navigation stack, Flutter automatically adds a back button to the
  AppBar of the new page (assuming it has an AppBar defined). This allows the user to easily
  navigate back to the previous page using this button.

  There are a few key points to understand:

  1. Automatic implication: The automaticallyImplyLeading property of the AppBar is set to
     true by default. This tells Flutter to automatically add a leading widget (usually the
     back button) to the left side of the AppBar based on the navigation context.

  2. Navigation stack: Each page pushed with Navigator.push() gets added to the navigation
     stack. When the user taps the back button, Flutter pops the current page from the stack,
     taking them back to the previous page.

  3. Customizability: While the back button comes automatically, you can customize its
     appearance by setting properties like icon, onPressed, and color within the leading
     property of the AppBar.
   */

  @override
  Widget build(BuildContext context) {

    // ADDING DYNAMIC SIZING
    //double quizButtonHeight=85.0;
    double quizButtonHeight=MediaQuery.sizeOf(context).height*0.095;
    //double navigButtonHeight=100.0;
    double navigButtonHeight=MediaQuery.sizeOf(context).height*0.11;
    //double navigButtonWidth=193.0;
    double navigButtonWidth=MediaQuery.sizeOf(context).width*0.45;

    double buttonTextFontSize=22;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // this is 'true' by default hence the unexpected back button
        title: const Center(
          child: Text(
            'Apprenons Le Francais',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        backgroundColor: primaryColorOfPage,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          // only centers inside the width of the column which is, right now, not covering the whole screen
          children: [

            // Dash image
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Image(
                  image: AssetImage(imagePathText),
                ),
              ),
            ),

            // Buttons
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  // Quiz Buttons
                  // FILL-IN-THE-BLANKS BUTTON________________________________________________________________________________________
                  Container(
                    height: quizButtonHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isFillInTheBlanksButtonSelected ? selectedButtonBackgroundColor : deselectedButtonBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: isFillInTheBlanksButtonSelected ? selectedButtonBorderColor : deselectedButtonBorderColor,
                        width: 6,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // show the description of this button option: Fill-In-The-Blanks quiz
                        setState(() {
                          isFillInTheBlanksButtonSelected=!isFillInTheBlanksButtonSelected;

                          if(isFillInTheBlanksButtonSelected) {
                            // change the image
                            imagePathText=fillInTheBlanksDescriptionImagePathText;

                            // perform deselection of the other buttons
                            isIdentifyTheNumbersButtonSelected=false;
                            isMatchTheWordsButtonSelected=false;
                            isHomeButtonSelected=false;
                          }

                          else {
                            // back to default image
                            imagePathText=defaultOptionsDescriptionImagePathText;
                          }

                        });
                      },
                      onLongPress: () {
                        // go to my-tiny-quiz-app
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return const MyTinyQuizApp();
                                },
                            ),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFillInTheBlanksButtonSelected ? selectedButtonBackgroundColor : deselectedButtonBackgroundColor,
                      ),
                      child: Text(
                        'Fill-In-The-Blanks',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: buttonTextFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // IDENTIFY-THE-NUMBERS BUTTON____________________________________________________________________________________
                  Container(
                    height: quizButtonHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isIdentifyTheNumbersButtonSelected ? selectedButtonBackgroundColor : deselectedButtonBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: isIdentifyTheNumbersButtonSelected ? selectedButtonBorderColor : deselectedButtonBorderColor,
                        width: 6,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // show the description of this button option: Identify-The-Numbers game
                        setState(() {
                          isIdentifyTheNumbersButtonSelected=!isIdentifyTheNumbersButtonSelected;

                          if(isIdentifyTheNumbersButtonSelected) {
                            // change the image
                            imagePathText=identifyTheNumbersDescriptionImagePathText;

                            // perform deselection of the other buttons
                            isFillInTheBlanksButtonSelected=false;
                            isMatchTheWordsButtonSelected=false;
                            isHomeButtonSelected=false;
                          }

                          else {
                            // back to default image
                            imagePathText=defaultOptionsDescriptionImagePathText;
                          }

                        });
                      },
                      onLongPress: () {
                        // go to match-the-words game
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const MyIdentifyTheNumberQuizApp();
                              },
                            ),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isIdentifyTheNumbersButtonSelected ? selectedButtonBackgroundColor : deselectedButtonBackgroundColor,
                      ),
                      child: Text(
                        'Identify-The-Numbers',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: buttonTextFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // MATCH-THE-WORDS BUTTON________________________________________________________________________________________
                  Container(
                    height: quizButtonHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isMatchTheWordsButtonSelected ? selectedButtonBackgroundColor : deselectedButtonBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: isMatchTheWordsButtonSelected ? selectedButtonBorderColor : deselectedButtonBorderColor,
                        width: 6,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // show the description of this button option: Match-The-Words game
                        setState(() {
                          isMatchTheWordsButtonSelected=!isMatchTheWordsButtonSelected;

                          if(isMatchTheWordsButtonSelected) {
                            // change the image
                            imagePathText=matchTheWordsDescriptionImagePathText;

                            // perform deselection of the other buttons
                            isFillInTheBlanksButtonSelected=false;
                            isIdentifyTheNumbersButtonSelected=false;
                            isHomeButtonSelected=false;
                          }

                          else {
                            // back to default image
                            imagePathText=defaultOptionsDescriptionImagePathText;
                          }

                        });
                      },
                      onLongPress: () {
                        // go to match-the-words game
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const MyTinyMatchingGameApp();
                              },
                            ),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isMatchTheWordsButtonSelected ? selectedButtonBackgroundColor : deselectedButtonBackgroundColor,
                      ),
                      child: Text(
                        'Match-The-Words',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: buttonTextFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Navigation Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      // HOME BUTTON______________________________________________________________________________________________
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 2.5),
                          child: Container(
                            height: navigButtonHeight,
                            width: navigButtonWidth,
                            decoration: BoxDecoration(
                              color: isHomeButtonSelected ? selectedButtonBackgroundColor : deselectedButtonBackgroundColor,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: isHomeButtonSelected ? selectedButtonBorderColor : deselectedButtonBorderColor,
                                width: 6,
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                // show the description of this button option: Back-To-Home page
                                setState(() {
                                  isHomeButtonSelected=!isHomeButtonSelected;

                                  if(isHomeButtonSelected) {
                                    // change the image
                                    imagePathText=homeDescriptionImagePathText;

                                    // perform deselection of the other buttons
                                    isFillInTheBlanksButtonSelected=false;
                                    isIdentifyTheNumbersButtonSelected=false;
                                    isMatchTheWordsButtonSelected=false;
                                  }

                                  else {
                                    // back to default image
                                    imagePathText=defaultOptionsDescriptionImagePathText;
                                  }

                                });
                              },
                              onLongPress: () {
                                // go to home page
                                setState(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const HomePage(); //CHANGE IT TO HOME-PAGE WIDGET
                                      },
                                    ),
                                  );
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isHomeButtonSelected ? selectedButtonBackgroundColor : deselectedButtonBackgroundColor,
                              ),
                              child: Text(
                                'HOME',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: buttonTextFontSize, // was 22...the quiz buttons were 25 i think
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // CLEAR BUTTON_____________________________________________________________________________________________
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.5),
                          child: Container(
                            height: navigButtonHeight,
                            width: navigButtonWidth,
                            decoration: BoxDecoration(
                              color: deselectedButtonBackgroundColor,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: deselectedButtonBorderColor,
                                width: 6,
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                // clear any selection
                                setState(() {
                                  isFillInTheBlanksButtonSelected=false;
                                  isIdentifyTheNumbersButtonSelected=false;
                                  isMatchTheWordsButtonSelected=false;
                                  isHomeButtonSelected=false;
                                  imagePathText=defaultOptionsDescriptionImagePathText;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: deselectedButtonBackgroundColor,
                              ),
                              child: Text(
                                'CLEAR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: buttonTextFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
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
