import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CapteurScreen extends StatefulWidget {
  const CapteurScreen({super.key});

  @override
  State<CapteurScreen> createState() => _CapteurScreenState();
}

class _CapteurScreenState extends State<CapteurScreen> {
  int? _selectedSensorIndex;
  bool isLoading = true;
  String humidityValue = '';
  String soilMoistureValue = '';
  String temperatureValue = '';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  late MqttServerClient client;
  final String mqttBroker = 'broker.hivemq.com';
  final String topic = 'esp32/soilMoisture';

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    connectToMQTT();
    fetchWeatherData();
  }

  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> fetchWeatherData() async {
    const String apiKey = '50687adfdf95597843aa5ebebd593abb'; // Your OpenWeather API key
    const String cityName = 'Agadir'; // Your city name

    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          temperatureValue = data['main']['temp'].toString();
          humidityValue = data['main']['humidity'].toString();
          isLoading = false;
        });
      } else {
        print('Failed to fetch weather data');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  Future<void> connectToMQTT() async {
    client = MqttServerClient(mqttBroker, '');
    client.port = 1883;
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('FlutterClient_${DateTime.now().millisecondsSinceEpoch}')
        .withWillTopic('willtopic')
        .withWillMessage('Connection Lost')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      print('MQTT Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Connected to MQTT broker');
      client.subscribe(topic, MqttQos.atMostOnce);
      setState(() {
        soilMoistureValue = '71';
      });

    } else {
      print('Failed to connect, status: ${client.connectionStatus}');
    }
  }

  void onConnected() {
    print('Connected');
  }

  void onDisconnected() {
    print('Disconnected');
  }

  void onSubscribed(String topic) {
    print('Subscribed to $topic');
  }

  void _handleCardTap(int index, String sensorImg, String name, String Volt, String Current, String rt, String rh, String type) {
    setState(() {
      _selectedSensorIndex = index;
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sensor Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image(
                  image: AssetImage(sensorImg),
                ),
              ),
              Text(
                'Sensor $index :  $name',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    const TextSpan(text: 'Operating voltage: ', style: TextStyle(fontWeight: FontWeight.bold, height: 2)),
                    TextSpan(text: Volt),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    const TextSpan(text: 'Sensor type: ', style: TextStyle(fontWeight: FontWeight.bold, height: 2)),
                    TextSpan(text: type),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    const TextSpan(text: 'Range temperature: ', style: TextStyle(fontWeight: FontWeight.bold, height: 2)),
                    TextSpan(text: rt),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    const TextSpan(text: 'Range humidity: ', style: TextStyle(fontWeight: FontWeight.bold, height: 2)),
                    TextSpan(text: rh),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _selectedSensorIndex = null;
                });
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Les Capteurs Actuels",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
            Card(
              elevation: 4.0,
              child: InkWell(
                onTap: () => _handleCardTap(
                    0,
                    "assets/images/temperature-sensor.png",
                    "Temperature",
                    "3.5V to 5.5V",
                    "0.3mA to 60uA",
                    "0°C to 50°C",
                    "20% to 90%",
                    "Serial"),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    title: const Text(
                      "Temperature",
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: const Text(
                      'Temperature Sensor',
                      style: TextStyle(fontSize: 12),
                    ),
                    leading: Image.asset('assets/images/temperature-sensor.png', height: 60),
                    trailing: isLoading
                        ? const CircularProgressIndicator()
                        : Text('$temperatureValue°C',
                        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            Card(
              elevation: 4.0,
              child: InkWell(
                onTap: () => _handleCardTap(
                    1,
                    "assets/images/humidity-sensor.png",
                    "Humidity",
                    "3.3V to 5V",
                    "35mA",
                    " -40℃~ +60℃",
                    "0% to 95%",
                    "Analog"),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    title: const Text(
                      "Humidity",
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: const Text(
                      'Humidity Sensor',
                      style: TextStyle(fontSize: 12),
                    ),
                    leading: Image.asset('assets/images/humidity-sensor.png', height: 60),
                    trailing: isLoading
                        ? const CircularProgressIndicator()
                        : Text('$humidityValue%',
                        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            Card(
              elevation: 4.0,
              child: InkWell(
                onTap: () => _handleCardTap(
                    2,
                    "assets/images/meter.png",
                    "Soil Moisture",
                    "3.3V to 5V",
                    "35mA",
                    "-40℃~ +60℃",
                    "0% to 95%",
                    "Analog"),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    title: const Text(
                      "Soil Moisture",
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: const Text(
                      'Soil Moisture Sensor',
                      style: TextStyle(fontSize: 12),
                    ),
                    leading: Image.asset('assets/images/meter.png', height: 60),
                    trailing: soilMoistureValue.isEmpty
                        ? const CircularProgressIndicator()
                        : Text('$soilMoistureValue%',
                        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
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