import 'package:flutter/material.dart';
import 'package:quiz_app/const/colors.dart';

class ResultsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> userAnswers;
  final int score;
  final int totalQuestions;
  final String categoryName;

  const ResultsScreen({
    super.key,
    required this.userAnswers,
    required this.score,
    required this.totalQuestions,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score / (totalQuestions * 10) * 100);
    final scoreColor =
        percentage >= 70
            ? Colors.greenAccent
            : percentage >= 40
            ? Colors.orangeAccent
            : Colors.redAccent;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resultados - $categoryName',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Color.fromRGBO(255, 255, 255, 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Resumen Final",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard(
                          "$score/${totalQuestions * 10}",
                          "Puntos",
                          Icons.star,
                          Colors.amber,
                        ),
                        _buildStatCard(
                          "${percentage.toStringAsFixed(1)}%",
                          "Aciertos",
                          Icons.percent,
                          scoreColor,
                        ),
                        _buildStatCard(
                          "$totalQuestions",
                          "Preguntas",
                          Icons.help_outline,
                          Colors.lightBlueAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: userAnswers.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final answer = userAnswers[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.9),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color:
                                                answer['isCorrect']
                                                    ? Color.fromRGBO(
                                                      0,
                                                      128,
                                                      0,
                                                      0.2,
                                                    )
                                                    : Color.fromRGBO(
                                                      255,
                                                      0,
                                                      0,
                                                      0.2,
                                                    ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            answer['isCorrect']
                                                ? Icons.check
                                                : Icons.close,
                                            color:
                                                answer['isCorrect']
                                                    ? Colors.green
                                                    : Colors.red,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            "Pregunta ${index + 1}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: darkBlue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      answer['question'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      "Tu respuesta: ${answer['userAnswer']}",
                                      style: TextStyle(
                                        color:
                                            answer['isCorrect']
                                                ? Colors.green
                                                : Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Respuesta correcta:",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      answer['correctAnswer'],
                                      style: const TextStyle(
                                        color: blue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  shadowColor: Color.fromRGBO(0, 0, 0, 0.2),
                ),
                child: const Text(
                  "Volver al Inicio",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color.fromRGBO(100, 150, 200, 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
