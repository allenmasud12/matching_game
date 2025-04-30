import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:matching_game/src/controllers/matching_game_controller.dart';
import 'package:matching_game/src/models/question.dart';


void main() {
  group('Question Model', () {
    test('fromMap creates Question from Map', () {
      final map = {'text': 'What is 2+2?', 'answer': '4'};
      final question = Question.fromMap(map);
      expect(question.text, 'What is 2+2?');
      expect(question.answer, '4');
    });

    test('fromDynamic creates Question from custom data', () {
      final customData = {'quiz': 'Capital of France?', 'result': 'Paris'};
      final question = Question.fromDynamic(
        customData,
        textExtractor: (item) => item['quiz'].toString(),
        answerExtractor: (item) => item['result'].toString(),
      );
      expect(question.text, 'Capital of France?');
      expect(question.answer, 'Paris');
    });
  });

  group('QuestionMatchingGameController', () {
    late MatchingGameController controller;

    setUp(() {
      controller = MatchingGameController(
        questions: [
          Question(text: 'What is 2+2?', answer: '4'),
          Question(text: 'Capital of France?', answer: 'Paris'),
        ],
        questionsPerSet: 2,
      );
    });

    test('loadQuestions should populate currentQuestions', () {
      controller.loadQuestions();
      expect(controller.currentQuestions.length, 2);
    });

    test('checkAnswers should set matchResults', () {
      controller.userAnswers.assignAll(['4', 'Paris']);
      controller.checkAnswers();
      expect(controller.matchResults, [true, true]);
    });
  });
}