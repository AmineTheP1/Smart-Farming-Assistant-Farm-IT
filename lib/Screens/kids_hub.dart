import 'package:flutter/material.dart';
import 'learn_page.dart';
import 'quiz_page.dart';
import 'game_page.dart';

class KidsHub extends StatelessWidget {
  const KidsHub({super.key});

  @override
  Widget build(BuildContext context) {
    // Définition des couleurs qui correspondent au style de QuizPage
    const Color primaryGreen = Color(0xFF4CAF50); // More appealing green
    const Color darkGreen = Color(0xFF2E7D32);
    const Color backgroundColor = Colors.white; // White background

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text(
            '🌾 Farm IT – Kids Zone 🌱',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: primaryGreen,
          centerTitle: true,
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
          bottom: TabBar(
            indicator: BoxDecoration(
              color: const Color(0xFF388E3C), // Softer dark green
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            tabs: const [
              Tab(icon: Icon(Icons.book), text: 'Learn'),
              Tab(icon: Icon(Icons.quiz), text: 'Quiz'),
              Tab(icon: Icon(Icons.games), text: 'Game'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LearnPage(),
            QuizPage(),
            GamePage(),
          ],
        ),
      ),
    );
  }
}