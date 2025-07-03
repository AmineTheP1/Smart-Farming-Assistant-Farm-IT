import 'package:flutter/material.dart';
import 'question.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // Shared colors for consistency across pages
  static const Color primaryGreen = Color(0xFF4CAF50); // Matching KidsHub
  static const Color darkGreen = Color(0xFF2E7D32);
  static const Color backgroundColor = Colors.white; // White background
  static const Color correctGreen = Color(0xFFAED581); // Softer correct color
  static const Color incorrectRed = Color(0xFFFFAB91); // Softer incorrect color

  final List<Question> _questions = [
    Question(
      text: '🌱 Pourquoi arrose‑t‑on les plantes ?',
      options: ['Pour les décorer', "Pour leur donner de l'eau 💧", 'Pour les réchauffer 🔥'],
      answerIndex: 1,
    ),
    Question(
      text: "🧪 Quel capteur mesure l'humidité du sol ?",
      options: ['Capteur de température 🌡️', "Capteur d'humidité 💦", 'Capteur de lumière 🌞'],
      answerIndex: 1,
    ),
    Question(
      text: '⏰ Quand vaut‑il mieux arroser ?',
      options: ['À midi 🕛', 'Le soir tard 🌙', 'Tôt le matin 🌄'],
      answerIndex: 2,
    ),
    Question(
      text: '🍃 Quelle plante a besoin d’un sol sec ?',
      options: ['Cactus 🌵', 'Rose 🌹', 'Tulipe 🌷'],
      answerIndex: 0,
    ),
    Question(
      text: '💧 Comment savoir si une plante a besoin d’eau ?',
      options: ['Les feuilles sont vertes 🍃', 'Les feuilles sont tombées 🍂', 'Le sol est sec 🌾'],
      answerIndex: 2,
    ),
    Question(
      text: '🌞 Quelle est l’importance du soleil pour les plantes ?',
      options: ['Donne de la chaleur 🔥', 'Aide à la photosynthèse 🌿', 'Les protège des insectes 🐞'],
      answerIndex: 1,
    ),
    Question(
      text: '🌻 Qu’est-ce qu’une serre ?',
      options: ['Un endroit pour stocker des outils 🛠️', 'Un endroit pour cultiver des plantes 🌱', 'Un endroit pour ranger les plantes malades 🤧'],
      answerIndex: 1,
    ),
  ];

  int _current = 0;
  int _score = 0;
  int? _selectedIndex;

  void _select(int index) {
    if (_selectedIndex != null) return;

    setState(() {
      _selectedIndex = index;
      if (index == _questions[_current].answerIndex) _score++;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (_current < _questions.length - 1) {
        setState(() {
          _current++;
          _selectedIndex = null;
        });
      } else {
        _showResult();
      }
    });
  }

  void _showResult() {
    String resultMessage;
    String titleMessage;

    // Update messages based on score
    if (_score >= 4) {
      titleMessage = '🎉 Bravo !';
      resultMessage = '🏆 Tu as eu $_score sur ${_questions.length} bonnes réponses !\n\n🌟 Continue comme ça, petit jardinier 👩‍🌾👨‍🌾 !';
    } else {
      titleMessage = '🤔 Hmmm, pense encore !';
      resultMessage = '🏆 Tu as eu $_score sur ${_questions.length} bonnes réponses.\n\n🌱 Pas de soucis, réessaie et apprends davantage !';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          titleMessage,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          resultMessage,
          style: const TextStyle(fontSize: 18, color: darkGreen),
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.replay, size: 20),
              label: const Text('Rejouer', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _current = 0;
                  _score = 0;
                  _selectedIndex = null;
                });
              },
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.only(bottom: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_current];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryGreen.withOpacity(0.5), width: 1),
              ),
              child: Text(
                '📖 Question ${_current + 1} / ${_questions.length}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: darkGreen,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryGreen.withOpacity(0.7), width: 1.5),
              ),
              child: Text(
                q.text,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(q.options.length, (i) {
              final isCorrect = i == q.answerIndex;
              final isSelected = _selectedIndex == i;
              Color? cardColor;

              if (_selectedIndex != null) {
                if (isCorrect) {
                  cardColor = correctGreen;
                } else if (isSelected) {
                  cardColor = incorrectRed;
                }
              } else {
                cardColor = Colors.white; // Clean white for unselected options
              }

              return Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: isCorrect && _selectedIndex != null
                        ? Colors.green
                        : isSelected && _selectedIndex != null
                        ? Colors.red
                        : primaryGreen.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () => _select(i),
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: _selectedIndex != null
                          ? (isCorrect
                          ? const Icon(Icons.check_circle, color: Colors.green, size: 28)
                          : isSelected
                          ? const Icon(Icons.cancel, color: Colors.red, size: 28)
                          : Icon(Icons.circle, color: primaryGreen.withOpacity(0.3), size: 28))
                          : Icon(Icons.circle_outlined, color: primaryGreen, size: 28),
                      title: Text(
                        q.options[i],
                        style: TextStyle(
                          fontSize: 18,
                          color: darkGreen,
                          fontWeight: _selectedIndex != null && (isCorrect || isSelected)
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
