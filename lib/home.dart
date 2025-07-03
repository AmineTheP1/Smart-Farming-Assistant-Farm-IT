import 'package:feecra_project/Screens/historyScreen.dart';
import 'package:feecra_project/Screens/kidsScreen.dart';
import 'package:feecra_project/Screens/reservoirScreen.dart';
import 'package:feecra_project/Screens/vanes.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Screens/capteurs.dart';
import 'Screens/plant.dart';
import 'login.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  // ------------------------------------------------
  // List of Screens corresponding to each tab
  // ------------------------------------------------
  final List<Widget> _screens = [
    const PlantScreen(),    // index 0
    VanesScreen(),          // index 1
    HistoricScreen(),       // index 2
    CapteurScreen(),        // index 3
    ReservoirScreen(),      // index 4
    const KidsScreen(),     // index 5
  ];

  Future<void> _confirmLogout(BuildContext context) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.topSlide,
      title: 'Confirmer la déconnexion',
      desc: 'Êtes-vous certain·e de vouloir vous déconnecter ?',
      btnCancelText: 'Annuler',
      btnOkText: 'Oui',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        Navigator.of(context, rootNavigator: true).pop();
        await FirebaseAuth.instance.signOut();
        if (!context.mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
              (_) => false,
        );
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {

    // ------------------------------------------------
    // Check user authentication
    // ------------------------------------------------
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const LoginScreen();

    return Scaffold(
      resizeToAvoidBottomInset: false,

      // ------------------------------------------------
      // Custom AppBar
      // ------------------------------------------------
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF2E7D32), // Dark Green
                  Color(0xFF66BB6A), // Light Green
                ],
              ),
            ),
          ),
          title: Row(
            children: [
              Image(
                image:AssetImage('assets/images/plant_logo.png'),
                height: 50,
                width: 50,
              ),

              // ------------------------------------------------
              // Custom Text
              // ------------------------------------------------
              Stack(
                children: <Widget>[
                  // Stroke Text
                  Text(
                    'FarmIT',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Colors.white38, // Stroke Color
                    ),
                  ),
                  // Fill Text
                  Text(
                    'FarmIT',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Fill Color
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              tooltip: 'Se déconnecter',
              onPressed: () {_confirmLogout(context);},
            ),
          ],
          centerTitle: false,
          elevation: 0,
        ),
      ),

      // ------------------------------------------------
      // Switchable Main Body
      // ------------------------------------------------
      body: _screens[_currentIndex],

      // ------------------------------------------------
      // Bottom Nav
      // ------------------------------------------------
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2E7D32), // Green background
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.local_florist, size: 32, color: Colors.white38),
                Icon(Icons.local_florist, size: 24, color: Colors.white),
              ],
            ),
            label: 'Plant',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.water_drop, size: 32, color: Colors.white38),
                Icon(Icons.water_drop, size: 24, color: Colors.white),
              ],
            ),
            label: 'Pompes',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.history, size: 32, color: Colors.white38),
                Icon(Icons.history, size: 24, color: Colors.white),
              ],
            ),
            label: 'Historique',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.sensors, size: 32, color: Colors.white38),
                Icon(Icons.sensors, size: 24, color: Colors.white),
              ],
            ),
            label: 'Capteurs',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.straighten, size: 32, color: Colors.white38),
                Icon(Icons.straighten, size: 24, color: Colors.white),
              ],
            ),
            label: 'Réservoir',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.child_friendly, size: 32, color: Colors.white38),
                Icon(Icons.child_friendly, size: 24, color: Colors.white),
              ],
            ),
            label: 'Kids',
          ),
        ],
      ),
    );
  }
}
