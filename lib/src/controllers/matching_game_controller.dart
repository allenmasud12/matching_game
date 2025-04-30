import 'dart:math';
import 'package:get/get.dart';
import '../models/question.dart';

class MatchingGameController extends GetxController {
  final List<Question> questions;
  final int questionsPerSet;
  late List<Question> allQuestions;
  final RxList<Question> currentQuestions = <Question>[].obs;
  final RxList<String> userAnswers = <String>[].obs;
  final RxList<bool?> matchResults = <bool?>[].obs;
  final RxList<String> usedAnswers = <String>[].obs;
  final RxBool isSetComplete = false.obs;

  MatchingGameController({
    required this.questions,
    this.questionsPerSet = 5,
  });

  @override
  void onInit() {
    super.onInit();
    allQuestions = questions;
    loadQuestions();
  }

  void loadQuestions() {
    final random = Random();
    final availableQuestions = List<Question>.from(allQuestions)..shuffle(random);
    currentQuestions.assignAll(availableQuestions.take(questionsPerSet));
    userAnswers.assignAll(List.filled(questionsPerSet, ''));
    matchResults.assignAll(List.filled(questionsPerSet, null));
    usedAnswers.clear();
    isSetComplete.value = false;
  }

  void resetCurrentSet() {
    userAnswers.assignAll(List.filled(questionsPerSet, ''));
    matchResults.assignAll(List.filled(questionsPerSet, null));
    usedAnswers.clear();
    isSetComplete.value = false;
  }

  void checkAnswers() {
    for (int i = 0; i < currentQuestions.length; i++) {
      matchResults[i] = userAnswers[i] == currentQuestions[i].answer;
    }
    isSetComplete.value = true;
  }

  void nextSet() {
    loadQuestions();
  }

  void handleAnswerDrop(int index, String answer) {
    if (userAnswers[index].isNotEmpty) {
      usedAnswers.remove(userAnswers[index]);
    }
    userAnswers[index] = answer;
    usedAnswers.add(answer);
    if (!userAnswers.contains('')) {
      checkAnswers();
    }
  }

  String truncateQuestion(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }
}