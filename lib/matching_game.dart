import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'src/controllers/matching_game_controller.dart';
import 'src/models/question.dart';
export 'src/models/question.dart';

/// A widget that displays an interactive question-answer matching game.
class MatchingGame extends StatelessWidget {
  /// List of questions in the standard [Question] format.
  final List<Question> questions;

  /// Number of questions to display per set.
  final int questionsPerSet;

  /// Primary color for the UI.
  final Color primaryColor;

  final Color titleColor;

  /// Optional text style for questions.
  final TextStyle? questionTextStyle;

  /// Optional text style for answers.
  final TextStyle? answerTextStyle;



  const MatchingGame({
    super.key,
    required this.questions,
    this.questionsPerSet = 5,
    this.primaryColor = Colors.teal,
    this.questionTextStyle,
    this.answerTextStyle,
    this.titleColor = const Color(0xFFA5D6A7),
  });

  /// Creates a [QuestionMatchingGame] from a list of dynamic data.
  factory MatchingGame.fromDynamic(
      List<dynamic> dynamicQuestions, {
        required String Function(dynamic) textExtractor,
        required String Function(dynamic) answerExtractor,
        String? Function(dynamic)? hintExtractor,
        int questionsPerSet = 5,
        Color primaryColor = Colors.teal,
        TextStyle? questionTextStyle,
        TextStyle? answerTextStyle,
      }) {
    final questions = dynamicQuestions
        .map((item) => Question.fromDynamic(
      item,
      textExtractor: textExtractor,
      answerExtractor: answerExtractor,
      hintExtractor: hintExtractor,
    ))
        .toList();
    return MatchingGame(
      questions: questions,
      questionsPerSet: questionsPerSet,
      primaryColor: primaryColor,
      questionTextStyle: questionTextStyle,
      answerTextStyle: answerTextStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Center(child: Text('No questions provided'));
    }
    final controller = Get.put(
      MatchingGameController(
        questions: questions,
        questionsPerSet: questionsPerSet,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor.withOpacity(0.1), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Obx(
                () => Column(
              children: [
                // Table for Questions and Answers
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Table(
                    border: TableBorder.all(color: Colors.grey),
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(2),
                    },
                    children: [
                      // Header Row
                      TableRow(
                        decoration: BoxDecoration(color: titleColor),
                        children: const [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Question',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Answer',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Question Rows
                      ...List.generate(controller.currentQuestions.length, (index) {
                        return TableRow(
                          children: [
                            // Question
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            controller.truncateQuestion(
                                              controller.currentQuestions[index].text,
                                              50,
                                            ),
                                            style: questionTextStyle ?? const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        if (controller.matchResults[index] != null)
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Icon(
                                              controller.matchResults[index]!
                                                  ? Icons.check_circle
                                                  : Icons.cancel,
                                              color: controller.matchResults[index]! ? Colors.green : Colors.red,
                                              size: 20,
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (controller.isSetComplete.value)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: controller.matchResults[index]!
                                            ? const SizedBox()
                                            : Row(
                                          children: [
                                            const Icon(Icons.keyboard_double_arrow_right, color: Colors.red),
                                            Text(
                                              controller.currentQuestions[index].answer,
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            // Answer Drop Target
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DragTarget<String>(
                                  builder: (context, candidateData, rejectedData) {
                                    return Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: controller.userAnswers[index].isEmpty
                                            ? Colors.grey.shade200
                                            : Colors.teal.shade50,
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      child: Text(
                                        controller.userAnswers[index].isEmpty
                                            ? 'Drop Answer'
                                            : controller.userAnswers[index],
                                        style: TextStyle(
                                          color: controller.userAnswers[index].isEmpty ? Colors.grey : primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  },
                                  onAccept: (answer) => controller.handleAnswerDrop(index, answer),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                // Answer Cards
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Wrap(
                      spacing: 4.0,
                      runSpacing: 4.0,
                      alignment: WrapAlignment.center,
                      children: () {
                        final answerList = controller.currentQuestions.map((question) => question.answer).toList()
                          ..shuffle(Random());
                        return answerList.map((answer) {
                          if (controller.usedAnswers.contains(answer)) {
                            return const SizedBox.shrink();
                          }
                          return Draggable<String>(
                            data: answer,
                            feedback: Material(
                              elevation: 8,
                              borderRadius: BorderRadius.circular(4.0),
                              child: Container(
                                width: 100,
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Center(
                                  child: Text(
                                    answer,
                                    textAlign: TextAlign.center,
                                    style: answerTextStyle ??
                                        const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            childWhenDragging: Container(
                              width: 100,
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Container(
                                width: 100,
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                  child: Text(
                                    answer,
                                    textAlign: TextAlign.center,
                                    style: answerTextStyle ??
                                        TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList();
                      }(),
                    ),
                  ),
                ),
                // Reset and Next Set Buttons
                if (controller.isSetComplete.value)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: controller.resetCurrentSet,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.refresh, color: Colors.white),
                              Text(
                                ' Reset',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: controller.nextSet,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                'Next ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(Icons.double_arrow, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

