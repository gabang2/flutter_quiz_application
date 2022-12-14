import 'package:flutter/material.dart';
import 'package:quiz/model/api_adaptor.dart';
import 'package:quiz/model/model_quiz.dart';
import 'package:quiz/screen/screen_quiz.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    List<Quiz> quizs = [];
    bool isLoading = false; // api로 부터 데이터를 가지고 오고 있는지?
    _fetchQuizs() async {
      setState(() {
        isLoading = true;
      });
      final response = await http.get('https://flutter-quiz-app-api.herokuapp.com/quiz/3/');
      if (response.statusCode == 200) {
        setState(() {
          quizs = parseQuizs(utf8.decode(response.bodyBytes));
          isLoading = false;
        });
      } else {
        throw Exception('failed to load data');
      }
    }
    List<Quiz> quizss = [
      Quiz.fromMap({
        'title': 'text',
        'candidates': ['a', 'b', 'c', 'd'],
        'answer': 0
      }),
      Quiz.fromMap({
        'title': 'text',
        'candidates': ['a', 'b', 'c', 'd'],
        'answer': 0
      }),
      Quiz.fromMap({
        'title': 'text',
        'candidates': ['a', 'b', 'c', 'd'],
        'answer': 0
      })
    ];

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text('My Quize App'),
          backgroundColor: Colors.deepPurple,
          leading: Container(),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'images/image.jpg',
                width: width * 0.8,
              ),
            ),
            Padding(padding: EdgeInsets.all((width * 0.024))),
            Text(
              '플러터 퀴즈 앱',
              style: TextStyle(
                  fontSize: width * 0.065, fontWeight: FontWeight.bold),
            ),
            Text('퀴즈를 풀기 전 안내사항입니다.\n꼼꼼히 읽고 퀴즈 풀기를 눌러주세요.',
                textAlign: TextAlign.center),
            Padding(padding: EdgeInsets.all(width * 0.048)),
            _buildStep(width, '1. 랜덤으로 나오는 퀴즈 3개를 풀어보세요.'),
            _buildStep(width, '2. 문제를 잘 읽고 정답을 고른 뒤 \n 다음 문제 버튼을 눌러주세요.'),
            _buildStep(width, '3. 만점을 향해 도전해보세요!'),
            Padding(padding: EdgeInsets.all(width * 0.048)),
            Container(
              padding: EdgeInsets.only(bottom: width * 0.036),
              child: Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurple)),
                  child:
                      Text('지금 퀴즈 풀기', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    _fetchQuizs().whenComplete(() {
                      return Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuizScreen(quizs: quizs)));
                    });
                  },
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Widget _buildStep(double width, String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          width * 0.048, width * 0.024, width * 0.048, width * 0.024),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_box,
            size: width * 0.04,
          ),
          Padding(padding: EdgeInsets.only(right: width * 0.024)),
          Text(title)
        ],
      ),
    );
  }
}
