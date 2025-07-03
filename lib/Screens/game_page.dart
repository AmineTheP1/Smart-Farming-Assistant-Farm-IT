import 'dart:async';
import 'package:flutter/material.dart';

class FarmPlot {
  int stage; // 0 = seed, 1 = sprout, 2 = ready, 3 = wilted
  int water;
  static const int maxWater = 5;
  int growthProgress = 0;

  FarmPlot() : stage = 0, water = maxWater;

  void tick() {
    if (stage == 3) return;
    water--;
    if (water <= 0) {
      stage = 3;
      water = 0;
    } else {
      growthProgress++;
      if (growthProgress >= 5 && stage < 2) {
        stage++;
        growthProgress = 0;
      }
    }
  }

  void waterPlant() {
    water = maxWater;
    if (stage == 3) {
      stage = 0;
      growthProgress = 0;
    }
  }

  bool get readyToHarvest => stage == 2;
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<FarmPlot> _plots;
  Timer? _timer;
  int _score = 0;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _plots = List.generate(4, (_) => FarmPlot());
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    // Increased timer duration from 1 second to 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), _handleTimerTick);
  }

  void _handleTimerTick(Timer timer) {
    if (!mounted || _isGameOver) return;

    setState(() {
      for (var i = 0; i < _plots.length; i++) {
        _plots[i].tick();
      }
    });

    if (_plots.any((plot) => plot.stage == 3)) {
      _endGame();
    }
  }

  void _endGame() {
    _timer?.cancel();
    _isGameOver = true;
    if (mounted) {
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
                'Your plants need more care!',
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
  }

  void _restartGame() {
    setState(() {
      _plots = List.generate(4, (_) => FarmPlot());
      _score = 0;
      _isGameOver = false;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onPlotTap(int index) {
    if (_isGameOver) return;

    setState(() {
      final plot = _plots[index];
      if (plot.readyToHarvest) {
        _score++;
        plot.stage = 0;
        plot.water = FarmPlot.maxWater;
        plot.growthProgress = 0;
      } else {
        plot.waterPlant();
      }
    });
  }

  Color _getStageColor(int stage) {
    switch (stage) {
      case 0: return Colors.brown.shade300;
      case 1: return Colors.green.shade400;
      case 2: return Colors.amber.shade600;
      case 3: return Colors.grey.shade400;
      default: return Colors.black;
    }
  }

  IconData _getStageIcon(int stage) {
    switch (stage) {
      case 0: return Icons.eco;
      case 1: return Icons.grass;
      case 2: return Icons.spa;
      case 3: return Icons.warning;
      default: return Icons.error;
    }
  }

  String _getStageLabel(int stage) {
    switch (stage) {
      case 0: return 'Seed';
      case 1: return 'Sprout';
      case 2: return 'Ready!';
      case 3: return 'Wilted';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🌱 Farm Game',
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
            // Score card with shadow and better styling
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.emoji_events, color: Colors.green.shade800, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Score: $_score',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
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
                color: Colors.green.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.tips_and_updates, color: Colors.green.shade800),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tap to water plants or harvest when ready!',
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Farm plots grid with improved styling but no animations
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: _plots.length,
                itemBuilder: (context, index) {
                  final plot = _plots[index];
                  final bool isReadyToHarvest = plot.readyToHarvest;

                  return Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () => _onPlotTap(index),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                _getStageColor(plot.stage),
                                _getStageColor(plot.stage).withOpacity(0.85),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Visual cue for harvestable plants
                              if (isReadyToHarvest)
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.yellow.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _getStageIcon(plot.stage),
                                    size: 56,
                                    color: Colors.white,
                                  ),
                                )
                              else
                                Icon(
                                  _getStageIcon(plot.stage),
                                  size: 56,
                                  color: Colors.white,
                                ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _getStageLabel(plot.stage),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Stack(
                                  children: [
                                    // Background of progress bar
                                    Container(
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    // Simple non-animated water level
                                    FractionallySizedBox(
                                      widthFactor: plot.water / FarmPlot.maxWater,
                                      child: Container(
                                        height: 10,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Colors.blue.shade200, Colors.blue.shade400],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.blue.shade200.withOpacity(0.5),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.water_drop,
                                    color: Colors.white70,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${plot.water}/${FarmPlot.maxWater}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
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
          ],
        ),
      ),
    );
  }
}