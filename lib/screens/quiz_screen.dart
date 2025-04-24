import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_app/const/colors.dart';
import 'package:quiz_app/screens/results_screen.dart';

class QuizScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final String categoryName;

  const QuizScreen({
    super.key,
    required this.questions,
    required this.categoryName,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int seconds = 10;
  Timer? timer;
  int points = 0;
  List<Color> optionsColor = [];
  Color timerColor = Colors.white;
  List<Map<String, dynamic>> userAnswers = [];
  late AnimationController _timerAnimationController;

  @override
  void initState() {
    super.initState();
    optionsColor = List.filled(
      widget.questions.first['options'].length,
      Colors.white,
    );
    _timerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..forward();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    _timerAnimationController.dispose();
    super.dispose();
  }

  void resetColors() {
    setState(() {
      optionsColor = List.filled(
        widget.questions[currentQuestionIndex]['options'].length,
        Colors.white,
      );
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        if (seconds > 0) {
          seconds--;
          timerColor = seconds <= 3 ? Colors.red : Colors.white;
        } else {
          gotoNextQuestion();
        }
      });
    });
  }

  void gotoNextQuestion() {
    if (!mounted) return;

    // Registrar respuesta no contestada solo si no hay respuesta previa
    if (!userAnswers.any(
      (answer) =>
          answer['question'] ==
          widget.questions[currentQuestionIndex]['question'],
    )) {
      userAnswers.add({
        'question': widget.questions[currentQuestionIndex]['question'],
        'userAnswer': 'No respondio',
        'correctAnswer':
            widget.questions[currentQuestionIndex]['correctAnswer'],
        'isCorrect': false,
      });
    }

    _timerAnimationController.reset();
    _timerAnimationController.forward();

    setState(() {
      if (currentQuestionIndex < widget.questions.length - 1) {
        currentQuestionIndex++;
        resetColors();
        timer?.cancel();
        seconds = 10;
        timerColor = Colors.white;
        startTimer();
      } else {
        timer?.cancel();
        _showResults();
      }
    });
  }

  void _showResults() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => ResultsScreen(
              userAnswers: userAnswers,
              score: points,
              totalQuestions: widget.questions.length,
              categoryName: widget.categoryName,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _answerQuestion(int index) {
    final currentQuestion = widget.questions[currentQuestionIndex];
    final options = currentQuestion['options'] as List<String>;
    final correctAnswer = currentQuestion['correctAnswer'] as String;
    final isCorrect = correctAnswer == options[index];

    setState(() {
      userAnswers.add({
        'question': currentQuestion['question'],
        'userAnswer': options[index],
        'correctAnswer': correctAnswer,
        'isCorrect': isCorrect,
      });

      if (isCorrect) {
        optionsColor[index] = Colors.green;
        points += 10;
      } else {
        optionsColor[index] = Colors.red;
      }

      Future.delayed(const Duration(milliseconds: 800), () {
        gotoNextQuestion();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[currentQuestionIndex];
    final options = currentQuestion['options'] as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [blue, darkBlue],
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [blue, darkBlue],
            stops: [0.2, 0.8],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Color.fromRGBO(255, 255, 255, 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                          color: const Color.fromARGB(255, 184, 198, 230),
                        ),
                      ),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color.fromRGBO(39, 174, 109, 0.2),
                            width: 3,
                          ),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _timerAnimationController,
                        builder: (context, child) {
                          return SizedBox(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(
                              value: _timerAnimationController.value,
                              strokeWidth: 4,
                              valueColor: AlwaysStoppedAnimation(timerColor),
                              backgroundColor: Color.fromRGBO(
                                100,
                                150,
                                200,
                                0.2,
                              ),
                            ),
                          );
                        },
                      ),
                      Text(
                        "$seconds",
                        style: TextStyle(
                          color: timerColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 28,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Color.fromRGBO(255, 255, 255, 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                          color: Color.fromRGBO(211, 211, 211, 0.3),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pregunta ${currentQuestionIndex + 1} de ${widget.questions.length}",
                        style: TextStyle(
                          color: Color.fromRGBO(211, 211, 211, 0.8),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        currentQuestion['question'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(253, 246, 50, 0.89),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(221, 26, 59, 0.298),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () => _answerQuestion(index),
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Center(
                                    child: Text(
                                      options[index],
                                      style: TextStyle(
                                        color:
                                            optionsColor[index] == Colors.white
                                                ? blue
                                                : Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
