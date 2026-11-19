import '../../models/question.dart';
import 'package:flutter/material.dart';

import '../../data/quiz_data.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String level; // "easy", "medium", "hard"

  const QuizScreen({
    super.key,
    this.level = "easy",
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestion = 0;
  int score = 0;
  int? selectedAnswer;

  // Soal akan diisi berdasarkan level
  late List<Question> quizQuestions;

  @override
  void initState() {
    super.initState();
    // Pilih soal berdasarkan level
    switch (widget.level) {
      case "easy":
        quizQuestions = questionsEasy;
        break;
      case "medium":
        quizQuestions = questionsMedium;
        break;
      case "hard":
        quizQuestions = questionsHard;
        break;
      default:
        quizQuestions = questionsEasy;
    }
  }

  void nextQuestion() {
    if (selectedAnswer == null) return;

    if (selectedAnswer == quizQuestions[currentQuestion].answerIndex) {
      score++;
    }

    if (currentQuestion == quizQuestions.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            score: score,
            total: quizQuestions.length,
          ),
        ),
      );
    } else {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
      });
    }
  }

  // Label level untuk AppBar
  String get levelLabel {
    switch (widget.level) {
      case "easy":
        return "Mudah";
      case "medium":
        return "Sedang";
      case "hard":
        return "Sulit";
      default:
        return "Quiz";
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = quizQuestions[currentQuestion];
    final progress = (currentQuestion + 1) / quizQuestions.length;

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Quiz Investasi • $levelLabel",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER PROGRESS =================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        height: 10,
                        width: MediaQuery.of(context).size.width *
                            progress *
                            0.9,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff16A34A),
                              Color(0xff22C55E),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Soal ${currentQuestion + 1} dari ${quizQuestions.length}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff4B5563),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffDCFCE7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Skor: $score",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff16A34A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ================= SOAL + OPSI =================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffDCFCE7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Pertanyaan",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff16A34A),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            q.question,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                              color: Color(0xff1F2937),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    ...List.generate(q.options.length, (index) {
                      final selected = selectedAnswer == index;
                      final alphabet = String.fromCharCode(65 + index);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            setState(() {
                              selectedAnswer = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xff16A34A)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xff16A34A)
                                    : Colors.grey.shade300,
                                width: selected ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: selected
                                      ? const Color(0xff16A34A)
                                          .withOpacity(0.3)
                                      : Colors.black.withOpacity(0.04),
                                  blurRadius: selected ? 12 : 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 250),
                                  width: 36,
                                  height: 36,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? Colors.white.withOpacity(0.25)
                                        : const Color(0xffF3F4F6),
                                    borderRadius:
                                        BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    alphabet,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: selected
                                          ? Colors.white
                                          : const Color(0xff4B5563),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    q.options[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: selected
                                          ? Colors.white
                                          : const Color(0xff1F2937),
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                                AnimatedSwitcher(
                                  duration:
                                      const Duration(milliseconds: 250),
                                  child: Icon(
                                    selected
                                        ? Icons.check_circle_rounded
                                        : Icons.circle_outlined,
                                    key: ValueKey(selected),
                                    color: selected
                                        ? Colors.white
                                        : Colors.grey.shade400,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ================= BOTTOM BUTTON =================
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedAnswer == null
                          ? Colors.grey.shade300
                          : const Color(0xff16A34A),
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: selectedAnswer == null ? 0 : 5,
                      shadowColor:
                          const Color(0xff16A34A).withOpacity(0.5),
                    ),
                    onPressed:
                        selectedAnswer == null ? null : nextQuestion,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentQuestion == quizQuestions.length - 1
                              ? "Selesai & Lihat Hasil"
                              : "Selanjutnya",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}