import 'package:flutter/material.dart';
import 'package:matching_game/matching_game.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matching Game Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const QuestionExample(),
    );
  }
}



class QuestionExample extends StatelessWidget {
  const QuestionExample({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Question Example')),
      body: MatchingGame(
        questions: [
          Question(text: 'Question:1 ', answer: 'Answer: 1'),
          Question(text: 'Question:2 ', answer: 'Answer: 2'),
          Question(text: 'Question:3 ', answer: 'Answer: 3'),
          Question(text: 'Question:4 ', answer: 'Answer: 4'),
          Question(text: 'Question:5 ', answer: 'Answer: 5'),
          Question(text: 'Question:6 ', answer: 'Answer: 6'),
        ],
        primaryColor: Colors.blue,
        questionsPerSet: 5,
        questionTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        // answerTextStyle: const TextStyle(
        //   fontSize: 14,
        //   color: Colors.white,
        // ),
      ),
    );
  }
}
