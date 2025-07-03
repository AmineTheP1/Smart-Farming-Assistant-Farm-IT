import 'package:flutter/material.dart';
import 'kids_hub.dart';
import 'dart:math' as math;

class KidsScreen extends StatefulWidget {
  const KidsScreen({super.key});

  @override
  State<KidsScreen> createState() => _KidsScreenState();
}

class _KidsScreenState extends State<KidsScreen> with SingleTickerProviderStateMixin {
  // Define the green colors from the provided hex values
  static const Color lightGreen = Color(0xFF4CAF50);
  static const Color darkGreen = Color(0xFF2E7D32);

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
      // Cool animated background with subtle leaf patterns
      Positioned.fill(
      child: AnimatedBuilder(
      animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: BackgroundPainter(
              animation: _controller,
              lightGreen: lightGreen,
              darkGreen: darkGreen,
            ),
          );
        },
      ),
    ),

    // Main content
    SafeArea(
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    const SizedBox(height: 40),

    // Modern app logo/icon
    Center(
    child: Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
    BoxShadow(
    color: darkGreen.withOpacity(0.3),
    blurRadius: 15,
    offset: const Offset(0, 8),
    ),
    ],
    ),
    child: Stack(
    alignment: Alignment.center,
    children: [
    // Water droplet background element
    Positioned(
    right: 0,
    bottom: 0,
    child: Icon(
    Icons.water_drop,
    size: 40,
    color: Colors.blue.withOpacity(0.2),
    ),
    ),

    // Main icon
    const Icon(
    Icons.child_friendly,
    size: 80,
    color: lightGreen,
    ),
    ],
    ),
    ),
    ),

    const SizedBox(height: 40),

    // Title with fresh modern typography
    ShaderMask(
    shaderCallback: (bounds) {
    return LinearGradient(
    colors: [
    darkGreen,
    lightGreen,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ).createShader(bounds);
    },
    child: Text(
    "Apprenons l'irrigation en jouant !",
    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
    fontWeight: FontWeight.bold,
    color: Colors.white, // This will be replaced by gradient
    fontSize: 26,
    ),
    textAlign: TextAlign.center,
    ),
    ),

    const SizedBox(height: 30),

    // Description card with a modern design
    Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
    BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 10,
    spreadRadius: 0,
    offset: const Offset(0, 4),
    ),
    ],
    ),
    child: Column(
    children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(Icons.videogame_asset, color: lightGreen),
    const SizedBox(width: 8),
    Icon(Icons.smart_display, color: lightGreen),
    const SizedBox(width: 8),
    Icon(Icons.science, color: lightGreen),
    ],
    ),
    const SizedBox(height: 16),
    Text(
    "Ici, les enfants trouveront des jeux et des vidéos pour comprendre comment poussent les plantes et pourquoi l'eau est si importante.",
    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    fontSize: 16,
    color: Colors.black87,
    height: 1.5,
    ),
    textAlign: TextAlign.center,
    ),
    ],
    ),
    ),

    const Spacer(),

    // Cool animated button
    Padding(
    padding: const EdgeInsets.only(bottom: 48.0),
    child: TweenAnimationBuilder<double>(
    tween: Tween<double>(begin: 1.0, end: 1.05),
    duration: const Duration(seconds: 2),
    curve: Curves.easeInOut,
    builder: (context, value, child) {
    return Transform.scale(
    scale: math.sin(_controller.value * math.pi * 2) * 0.02 + 1.0,
    child: child,
    );
    },
    child: ElevatedButton(
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const KidsHub()),
    );
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: darkGreen,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 20),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
    ),
    elevation: 4,
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    const SizedBox(width: 10),
    Text(
    'Commencer',
    style: Theme.of(context).textTheme.titleLarge?.copyWith(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    ],
    ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final Animation<double> animation;
  final Color lightGreen;
  final Color darkGreen;

  BackgroundPainter({
    required this.animation,
    required this.lightGreen,
    required this.darkGreen,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white,
          const Color(0xFFEDF7ED),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Draw subtle leaf patterns
    drawLeafPatterns(canvas, size);
  }

  void drawLeafPatterns(Canvas canvas, Size size) {
    final leafPaint = Paint()
      ..color = lightGreen.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Create some randomly positioned leaf shapes
    final random = math.Random(42); // Fixed seed for consistent pattern

    for (int i = 0; i < 15; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final leafSize = 10.0 + random.nextDouble() * 30.0;

      // Animate the position slightly based on the animation value
      final offsetX = math.sin((animation.value * math.pi * 2) + i) * 5.0;
      final offsetY = math.cos((animation.value * math.pi * 2) + i * 0.5) * 5.0;

      final path = Path();
      path.moveTo(x + offsetX, y + offsetY);
      path.quadraticBezierTo(
          x + leafSize * 0.5 + offsetX,
          y - leafSize * 0.5 + offsetY,
          x + leafSize + offsetX,
          y + offsetY
      );
      path.quadraticBezierTo(
          x + leafSize * 0.5 + offsetX,
          y + leafSize * 0.5 + offsetY,
          x + offsetX,
          y + offsetY
      );

      canvas.drawPath(path, leafPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}