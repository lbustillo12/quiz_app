import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/const/colors.dart';
import 'package:quiz_app/data/quiz_data.dart';
import 'package:quiz_app/screens/quiz_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "quick",
        scaffoldBackgroundColor: darkBlue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [blue, Color.fromARGB(255, 12, 26, 130)],
            stops: [0.3, 0.7],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  style: IconButton.styleFrom(
                    backgroundColor: Color.fromRGBO(255, 255, 255, 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(
                        color: Color.fromRGBO(211, 211, 211, 0.5),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/balloon2.png',
                        width: 280,
                        height: 250,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Bienvenido a nuestra",
                        style: TextStyle(
                          color: lightgrey,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Quiz App",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Color.fromRGBO(0, 0, 0, 0.3),
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "¿Te sientes preparado? ¡Demuestra tus conocimientos!",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 205, 212, 231),
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
                _buildCategoryButton(
                  context: context,
                  category: 'Cultura General',
                  icon: Icons.public,
                  color: const Color.fromARGB(255, 229, 250, 40),
                ),
                const SizedBox(height: 15),
                _buildCategoryButton(
                  context: context,
                  category: 'Programación',
                  icon: Icons.code,
                  color: const Color.fromARGB(255, 68, 232, 254),
                ),
                const SizedBox(height: 15),
                _buildCategoryButton(
                  context: context,
                  category: 'Ciencia',
                  icon: Icons.science,
                  color: const Color.fromARGB(255, 42, 248, 121),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton({
    required BuildContext context,
    required String category,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => QuizScreen(
                  questions: quizCategories[category]!,
                  categoryName: category,
                ),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Color.fromRGBO(107, 160, 234, 0.824),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Color.fromRGBO(49, 88, 247, 0.09),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(177, 177, 177, 0.675),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 15),
            Text(
              category,
              style: const TextStyle(
                color: Color.fromARGB(255, 247, 246, 246),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Color.fromRGBO(39, 39, 39, 0.675),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
