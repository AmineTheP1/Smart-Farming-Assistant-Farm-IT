import 'dart:math';
import 'package:flutter/material.dart';

class CropItem {
  final String name;
  final IconData icon;
  final String category;
  final Color color;

  CropItem({
    required this.name,
    required this.icon,
    required this.category,
    required this.color,
  });
}

class FarmSorterGame extends StatefulWidget {
  const FarmSorterGame({Key? key}) : super(key: key);

  @override
  State<FarmSorterGame> createState() => _FarmSorterGameState();
}

class _FarmSorterGameState extends State<FarmSorterGame> {
  int _score = 0;
  int _lives = 3;
  bool _isGameOver = false;
  List<CropItem> _currentItems = [];
  final Random _random = Random();
  
  final List<CropItem> _allCrops = [
    // Vegetables
    CropItem(name: 'Carrot', icon: Icons.eco, category: 'Vegetable', color: Colors.orange),
    CropItem(name: 'Tomato', icon: Icons.brightness_1, category: 'Vegetable', color: Colors.red),
    CropItem(name: 'Lettuce', icon: Icons.spa, category: 'Vegetable', color: Colors.green.shade300),
    CropItem(name: 'Potato', icon: Icons.circle, category: 'Vegetable', color: Colors.brown.shade300),
    CropItem(name: 'Broccoli', icon: Icons.nature, category: 'Vegetable', color: Colors.green),
    
    // Fruits
    CropItem(name: 'Apple', icon: Icons.brightness_1, category: 'Fruit', color: Colors.red.shade700),
    CropItem(name: 'Banana', icon: Icons.crop_portrait, category: 'Fruit', color: Colors.yellow),
    CropItem(name: 'Orange', icon: Icons.circle, category: 'Fruit', color: Colors.orange),
    CropItem(name: 'Strawberry', icon: Icons.favorite, category: 'Fruit', color: Colors.red),
    CropItem(name: 'Blueberry', icon: Icons.circle, category: 'Fruit', color: Colors.blue),
    
    // Grains
    CropItem(name: 'Wheat', icon: Icons.grass, category: 'Grain', color: Colors.amber),
    CropItem(name: 'Corn', icon: Icons.grass, category: 'Grain', color: Colors.yellow),
    CropItem(name: 'Rice', icon: Icons.grain, category: 'Grain', color: Colors.white70),
    CropItem(name: 'Oats', icon: Icons.grass, category: 'Grain', color: Colors.brown.shade200),
    CropItem(name: 'Barley', icon: Icons.grass, category: 'Grain', color: Colors.amber.shade700),
  ];
  
  final List<String> _categories = ['Vegetable', 'Fruit', 'Grain'];
  String _currentCategory = '';
  
  @override
  void initState() {
    super.initState();
    _startNewRound();
  }
  
  void _startNewRound() {
    if (_lives <= 0) {
      _endGame();
      return;
    }
    
    // Select a random category for this round
    _currentCategory = _categories[_random.nextInt(_categories.length)];
    
    // Generate 6 random items (2 from the correct category, 4 from other categories)
    List<CropItem> correctItems = _allCrops
        .where((crop) => crop.category == _currentCategory)
        .toList()
        ..shuffle(_random);
    
    List<CropItem> incorrectItems = _allCrops
        .where((crop) => crop.category != _currentCategory)
        .toList()
        ..shuffle(_random);
    
    _currentItems = [
      ...correctItems.take(2),
      ...incorrectItems.take(4),
    ]..shuffle(_random);
    
    setState(() {});
  }
  
  void _checkAnswer(CropItem selectedCrop) {
    setState(() {
      if (selectedCrop.category == _currentCategory) {
        _score += 10;
        
        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Correct! ${selectedCrop.name} is a ${selectedCrop.category}!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        _lives--;
        
        // Show error feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Oops! ${selectedCrop.name} is a ${selectedCrop.category}, not a $_currentCategory!'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1),
          ),
        );
      }
      
      // Start a new round after a short delay
      Future.delayed(const Duration(milliseconds: 1200), () {
        _startNewRound();
      });
    });
  }
  
  void _endGame() {
    setState(() {
      _isGameOver = true;
    });
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🌱 Game Over',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.agriculture, size: 48, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              'Final Score: $_score',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'You\'re becoming a farming expert!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        actions: [
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.replay),
              label: const Text('Play Again', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _restartGame();
              },
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.only(bottom: 16),
      ),
    );
  }
  
  void _restartGame() {
    setState(() {
      _score = 0;
      _lives = 3;
      _isGameOver = false;
    });
    _startNewRound();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🌱 Farm Sorter',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade50,
        elevation: 0,
      ),
      backgroundColor: Colors.green.shade50.withOpacity(0.5),
      body: SafeArea(
        child: Column(
          children: [
            // Score and lives card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.emoji_events, color: Colors.green.shade800, size: 24),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Score: $_score',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.favorite, color: Colors.red.shade800, size: 24),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Lives: $_lives',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Game instruction card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Card(
                color: Colors.amber.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        'Find all the $_currentCategory items!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap on the correct items to earn points',
                        style: TextStyle(
                          color: Colors.amber.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Crop items grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                itemCount: _currentItems.length,
                itemBuilder: (context, index) {
                  final crop = _currentItems[index];
                  
                  return GestureDetector(
                    onTap: () => _checkAnswer(crop),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: crop.color.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              crop.icon,
                              size: 40,
                              color: crop.color,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            crop.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}