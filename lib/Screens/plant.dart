import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlantScreen extends StatefulWidget {
  const PlantScreen({Key? key}) : super(key: key);

  @override
  State<PlantScreen> createState() => _PlantScreenState();
}

class _PlantScreenState extends State<PlantScreen> {
  final user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> _plants = [];

  @override
  void initState() {
    super.initState();
    fetchUserGarden();
  }

  // ------------------------------------------------------------------------
  // Function That Fetch User ID Since DataBase Is Separated By User ID
  // ------------------------------------------------------------------------
  Future<void> fetchUserGarden() async {
    final gardenRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.uid)
        .collection('Garden');

    final snapshot = await gardenRef.get();
    setState(() {
      _plants = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Save doc ID for deleting
        return data;
      }).toList();
    });
  }

  // ------------------------------------------------------------------------
  // Function For Adding Plants, List Of Plants isn't in Database but
  // Information once added will be !!
  // ------------------------------------------------------------------------
  Future<void> _addNewPlant() async {
    final seasons = ['Spring', 'Summer', 'Autumn', 'Winter'];
    final Map<String, List<String>> recommendedPlantsPerSeason = {
      'Spring': [
        'Carrot',
        'Lettuce',
        'Peas',
        'Spinach',
        'Broccoli',
        'Cauliflower',
        'Beets',
      ],
      'Summer': [
        'Tomato',
        'Cucumber',
        'Zucchini',
        'Eggplant',
        'Bell Pepper',
        'Corn',
        'Green Beans',
      ],
      'Autumn': [
        'Garlic',
        'Onion',
        'Radish',
        'Kale',
        'Turnips',
        'Brussels Sprouts',
        'Cabbage',
      ],
      'Winter': [
        'Winter Lettuce',
        'Spinach',
        'Kale',
        'Swiss Chard',
        'Broccoli',
        'Garlic',
      ],
    };

    // ------------------------------------------------------------------------
    //This is Temp, ESP Need to be added Via CodeBar
    // ------------------------------------------------------------------------
    final espDevices = ['ESP32 #1', 'ESP32 #2', 'ESP32 #3'];

    String? _selectedSeason = seasons.first;
    List<String> _availablePlants = recommendedPlantsPerSeason[_selectedSeason]!;
    String? _selectedPlant = _availablePlants.first;
    String? _selectedEsp32 = espDevices.first;

    final bool? userConfirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Add a New Plant'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_selectedPlant != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Image.asset(
                          'assets/images/'+_selectedPlant!+'.png',
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),

                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Season'),
                      value: _selectedSeason,
                      items: seasons.map((s) {
                        return DropdownMenuItem(value: s, child: Text(s));
                      }).toList(),
                      onChanged: (val) {
                        setStateDialog(() {
                          _selectedSeason = val;
                          _availablePlants = recommendedPlantsPerSeason[_selectedSeason] ?? [];
                          _selectedPlant = _availablePlants.isNotEmpty ? _availablePlants.first : null;
                        });
                      },
                    ),

                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Recommended Plant'),
                      value: _availablePlants.first,
                      items: _availablePlants.map((plant) {
                        return DropdownMenuItem(
                          value: plant,
                          child: Text(plant),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setStateDialog(() {
                          _selectedPlant = val;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Select ESP32'),
                      value: _selectedEsp32,
                      items: espDevices.map((esp) {
                        return DropdownMenuItem(value: esp, child: Text(esp));
                      }).toList(),
                      onChanged: (val) {
                        setStateDialog(() {
                          _selectedEsp32 = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );

    if (userConfirmed == true &&
        _selectedSeason != null &&
        _selectedPlant != null &&
        _selectedEsp32 != null) {
      final gardenRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .collection('Garden');

      await gardenRef.add({
        'name': _selectedPlant,
        'season': _selectedSeason,
        'esp32': _selectedEsp32,
        'image': 'assets/images/'+_selectedPlant!+'.png', // Placeholder image
      });

      fetchUserGarden();
    }
  }

  // ------------------------------------------------------------------------
  // For Deleting The Plant From user and DataBase
  // ------------------------------------------------------------------------
  Future<void> _deletePlant(String docId) async {
    final gardenRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.uid)
        .collection('Garden');

    await gardenRef.doc(docId).delete();
    fetchUserGarden();
  }

  // ------------------------------------------------------------------------
  // Plant Grid For showcasing the Plants
  // ------------------------------------------------------------------------
  Widget _buildPlantTile(Map<String, dynamic> plant, int index) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Image.asset(
                      plant['image'],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  plant['name'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Season: ${plant['season']}'),
                Text('ESP32: ${plant['esp32']}'),
              ],
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deletePlant(plant['id']),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------------------
  // Main Body
  // ------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.brown.shade600,
              Colors.brown.shade300,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.eco, size: 32, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text(
                      'My Garden',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.brown[300],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      itemCount: _plants.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (ctx, index) {
                        final plant = _plants[index];
                        return _buildPlantTile(plant, index);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewPlant,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
