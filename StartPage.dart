import 'package:flutter/material.dart';
import 'package:iot/Scripts/HomePage.dart';


class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: Text('Start'),
        ),
      ),
    );
  }
}

