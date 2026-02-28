class Question {
  late final String _questionText;
  //late List<String> optionsTextList=[]; // list size will be 4 for now i.e. only 4 options are available
  late final String _optionAText;
  late final String _optionBText;
  late final String _optionCText;
  late final String _optionDText;
  late final String _correctAnswerText;

  Question(this._questionText, this._optionAText, this._optionBText, this._optionCText, this._optionDText, this._correctAnswerText);

  String returnQuestionText()
  {
    return _questionText;
  }

  String returnOptionAText()
  {
    return _optionAText;
  }

  String returnOptionBText()
  {
    return _optionBText;
  }

  String returnOptionCText()
  {
    return _optionCText;
  }

  String returnOptionDText()
  {
    return _optionDText;
  }

  String returnCorrectAnswerText()
  {
    return _correctAnswerText;
  }
}