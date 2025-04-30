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
      title: 'Question Matching Game Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Matching Game Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Example 1: Using Standard Question Model
          ListTile(
            title: const Text('Example 1: Standard Question Model'),
            subtitle: const Text('Using the Question class directly'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StandardQuestionExample(),
                ),
              );
            },
          ),
          // Example 2: Using JSON Data
          ListTile(
            title: const Text('Example 2: JSON Data'),
            subtitle: const Text('Using JSON data with dynamic extractor'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JsonDataExample(),
                ),
              );
            },
          ),
          // Example 3: Using Custom Class
          ListTile(
            title: const Text('Example 3: Custom Class'),
            subtitle: const Text('Using a custom class with dynamic extractor'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomClassExample(),
                ),
              );
            },
          ),
          // Example 4: Using Map Data
          ListTile(
            title: const Text('Example 4: Map Data'),
            subtitle: const Text('Using Map data with Question.fromMap'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapDataExample(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Example 1: Standard Question Model
class StandardQuestionExample extends StatelessWidget {
  const StandardQuestionExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Standard Question Model')),
      body: MatchingGame(
        questions: [
          Question(text: 'What is 2+2?', answer: '4'),
          Question(text: 'Capital of France?', answer: 'Paris'),
          Question(text: 'Largest planet?', answer: 'Jupiter'),
        ],
        primaryColor: Colors.blue,
        questionsPerSet: 3,
        questionTextStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold),
        answerTextStyle: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }
}

// Example 2: JSON Data
class JsonDataExample extends StatelessWidget {
  const JsonDataExample({super.key});

  @override
  Widget build(BuildContext context) {
    final jsonData = [
      {'question': 'What is the capital of Japan?', 'correct_answer': 'Tokyo'},
      {'question': 'What is 5x5?', 'correct_answer': '25'},
      {
        'question': 'Who wrote Romeo and Juliet?',
        'correct_answer': 'Shakespeare'
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('JSON Data')),
      body: MatchingGame.fromDynamic(
        jsonData,
        textExtractor: (item) => item['question'].toString(),
        answerExtractor: (item) => item['correct_answer'].toString(),
        primaryColor: Colors.green,
        questionsPerSet: 3,
      ),
    );
  }
}

// Example 3: Custom Class
class CustomClassExample extends StatelessWidget {
  const CustomClassExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Custom class definition
    class QuizItem {
    final String quizText;
    final String result;

    QuizItem(this.quizText, this.result);
    }

    final customData = [
    QuizItem('What is the currency of USA?', 'Dollar'),
    QuizItem('Who painted the Mona Lisa?', 'Da Vinci'),
    QuizItem('What is H2O?', 'Water'),
    ];

    return Scaffold(
    appBar: AppBar(title: const Text('Custom Class')),
    body: MatchingGame.fromDynamic(
    customData,
    textExtractor: (item) => item.quizText,
    answerExtractor: (item) => item.result,
    primaryColor: Colors.purple,
    questionsPerSet: 3,
    ),
    );
    }
}

// Example 4: Map Data
class MapDataExample extends StatelessWidget {
  const MapDataExample({super.key});

  @override
  Widget build(BuildContext context) {
    final mapData = [
      {'text': 'What is the tallest mountain?', 'answer': 'Everest'},
      {'text': 'What is the smallest country?', 'answer': 'Vatican City'},
      {'text': 'What is the longest river?', 'answer': 'Nile'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Map Data')),
      body: MatchingGame(
        questions: mapData.map((item) => Question.fromMap(item)).toList(),
        primaryColor: Colors.orange,
        questionsPerSet: 3,
      ),
    );
  }
}