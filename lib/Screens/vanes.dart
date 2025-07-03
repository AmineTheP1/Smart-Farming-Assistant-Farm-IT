import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:feecra_project/Screens/qr_scanner_screen.dart'; // <-- import your QRScannerScreen

class VanesScreen extends StatefulWidget {
  @override
  _VanesScreenState createState() => _VanesScreenState();
}

class _VanesScreenState extends State<VanesScreen> {
  // final databaseReference = FirebaseDatabase.instance.ref().child('aquaflow/pumps/');

  List<Map<String, dynamic>> items = [
    {
      'imageUrl': 'assets/images/pump.png',
      'title': 'Pomp 1',
      'subtitle': 'Arroser le champ de maïs',
      'switchValue': false,
      'isAutoIrrigation': false,
    },
    {
      'imageUrl': 'assets/images/pump.png',
      'title': 'Pomp 2',
      'subtitle': 'Arroser le champ de fruits',
      'switchValue': false,
      'isAutoIrrigation': false,
    },
    {
      'imageUrl': 'assets/images/pump.png',
      'title': 'Pomp 3',
      'subtitle': 'Arroser le champ de tomates',
      'switchValue': false,
      'isAutoIrrigation': false,
    },
    {
      'imageUrl': 'assets/images/pump.png',
      'title': 'Pomp 4',
      'subtitle': 'Arroser le jardin',
      'switchValue': false,
      'isAutoIrrigation': false,
    },
  ];

  // --------------------------------------------------
  //  Show the configuration modal
  // --------------------------------------------------
  void _showConfigurationModal() {
    bool irrigationAuto = false;
    TimeOfDay startTime = TimeOfDay(hour: 0, minute: 0);
    TimeOfDay endTime = TimeOfDay(hour: 0, minute: 0);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Configuration',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    title: Text('Arrosage automatique'),
                    value: irrigationAuto,
                    onChanged: (value) {
                      setState(() {
                        irrigationAuto = value!;
                      });
                    },
                  ),
                  if (irrigationAuto) ...[
                    ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text('Heure de début'),
                      subtitle: Text(
                        '${startTime.hour}:${startTime.minute.toString().padLeft(2, "0")}',
                      ),
                      onTap: () async {
                        TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: startTime,
                        );
                        if (picked != null) {
                          setState(() {
                            startTime = picked;
                          });
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text('Heure de fin'),
                      subtitle: Text(
                        '${endTime.hour}:${endTime.minute.toString().padLeft(2, "0")}',
                      ),
                      onTap: () async {
                        TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                        );
                        if (picked != null) {
                          setState(() {
                            endTime = picked;
                          });
                        }
                      },
                    ),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Annuler',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Save the changes here, if needed
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Enregistrer',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --------------------------------------------------
  //  Scan a QR code to add a new pump
  // --------------------------------------------------
  Future<void> _scanQRCode() async {
    // Navigate to the scanner screen and wait for the result
    final scannedCode = await Navigator.of(context).push<String?>(
      MaterialPageRoute(builder: (_) => const QRScannerScreen()),
    );

    // If scannedCode is not null, create a new item in the list
    if (scannedCode != null && scannedCode.isNotEmpty) {
      setState(() {
        // For example, let’s create a new pump using the scannedCode
        items.add({
          'imageUrl': 'assets/images/pump.png',
          'title': 'Pump (ID: $scannedCode)',
          'subtitle': 'Nouvelle pompe ajoutée',
          'switchValue': false,
          'isAutoIrrigation': false,
        });
      });

      // Optionally, if you want to also store this in Firebase:
      // databaseReference.child('pump_$scannedCode').set({'active': false});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nouvelle pompe ajoutée: $scannedCode')),
      );
    }
  }

  // --------------------------------------------------
  //  Build method
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vanes Screen'),
      ),

      // List of pumps
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Image.asset(items[index]['imageUrl']),
                      title: Text(items[index]['title']),
                      subtitle: Text(items[index]['subtitle']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: items[index]['switchValue'],
                            onChanged: (bool value) {
                              setState(() {
                                items[index]['switchValue'] = value;
                                // If using Firebase, you could update here:
                                // databaseReference.child('pump${index+1}').set(value);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton.icon(
                          onPressed: () => _showConfigurationModal(),
                          label: const Text('Configuration'),
                          icon: const Icon(Icons.settings),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.teal,
                            disabledForegroundColor: Colors.grey.withOpacity(0.38),
                          ),
                        ),
                        const SizedBox(width: 30),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      // FloatingActionButton to trigger the QR code scanner
      floatingActionButton: FloatingActionButton(
        onPressed: _scanQRCode,
        child: Icon(Icons.add),
      ),
    );
  }
}
