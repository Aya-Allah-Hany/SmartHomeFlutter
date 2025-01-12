import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'mqtt_manager.dart';// Import your MQTT manager

class SoilPage extends StatefulWidget {
  @override
  _SoilPageState createState() => _SoilPageState();
}

class _SoilPageState extends State<SoilPage> {
  final topicController = TextEditingController();
  final List<String> _messages = [];
  final List<ChartData> _chartData = [];
  final MQTTClientWrapper mqttClientWrapper = MQTTClientWrapper();
  String? _currentTopic;
  double _currentReading = 0.0;

  @override
  void initState() {
    super.initState();
    mqttClientWrapper.prepareMqttClient();
    mqttClientWrapper.onMessageReceived = (message) {
      setState(() {
        _messages.add(message);
        try {
          _currentReading = double.parse(message);
          _chartData.add(ChartData(DateTime.now(), _currentReading));
          if (_chartData.length > 20) {
            _chartData.removeAt(0);
          }
        } catch (e) {
          print('Error parsing message to double: $e');
        }
      });
      print('Message received: $message');
    };
  }

  void _subscribeToTopic(String topic) {
    topic = "sensors/soil";
    if (topic.isNotEmpty && topic != _currentTopic) {
      mqttClientWrapper.subscribeToTopic(topic);
      _currentTopic = topic;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the animation file based on the temperature
    String animationAsset;
    
      animationAsset = 'assets/soil.json'; // Hot weather animation
    

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 6, 5, 49),
                  Color(0xFFdbc6b0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.all(29.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Lottie animation
                Lottie.asset(animationAsset),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFdbc6b0),
                        Color(0xFF78809d),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextButton(
                    onPressed: () {
                      final topic = topicController.text;
                      _subscribeToTopic(topic);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: Colors.transparent, // Make the button background transparent
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded corners
                      ),
                      minimumSize: Size(300, 50), // Set minimum size
                    ),
                    child: Text(
                      'Show Humidity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Soil Humidity: $_currentReading',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Positioned home icon at the top left
          Positioned(
            top: 30,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.popAndPushNamed(context, '/home');
              },
              child: Icon(
                Icons.home,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder for ChartData class
class ChartData {
  final DateTime time;
  final double value;

  ChartData(this.time, this.value);
}